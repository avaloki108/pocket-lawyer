#!/bin/bash
# deploy.sh - Complete Google Play Store Deployment Pipeline
# Run: ./deploy.sh [internal|alpha|beta|production]

set -e  # Exit on error

# ============================================
# CONFIGURATION
# ============================================
APP_NAME="pocket-lawyer"
PACKAGE_NAME="ai.pocketlawyer.app"
KEYSTORE_PATH="./android/pocket-lawyer-release.jks"
BUILD_NUMBER_FILE=".build_number"
TRACK="${1:-internal}"  # Default to internal track

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# ============================================
# FUNCTIONS
# ============================================

log_step() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
    exit 1
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Increment build number
increment_build_number() {
    if [ -f "$BUILD_NUMBER_FILE" ]; then
        BUILD_NUMBER=$(cat "$BUILD_NUMBER_FILE")
        BUILD_NUMBER=$((BUILD_NUMBER + 1))
    else
        BUILD_NUMBER=1
    fi
    echo $BUILD_NUMBER > "$BUILD_NUMBER_FILE"
    log_step "Build number: $BUILD_NUMBER"
}

# Generate keystore if it doesn't exist
generate_keystore() {
    if [ ! -f "$KEYSTORE_PATH" ]; then
        log_step "Generating release keystore..."
        keytool -genkey -v -keystore "$KEYSTORE_PATH" \
            -keyalg RSA -keysize 2048 -validity 10000 \
            -alias pocket-lawyer \
            -storepass "${KEYSTORE_PASSWORD}" \
            -keypass "${KEY_PASSWORD}" \
            -dname "CN=Pocket Lawyer, OU=Mobile, O=PocketLawyer AI, L=Denver, ST=Colorado, C=US"
        
        # Create keystore.properties
        cat > android/keystore.properties <<EOF
storePassword=${KEYSTORE_PASSWORD}
keyPassword=${KEY_PASSWORD}
keyAlias=pocket-lawyer
storeFile=pocket-lawyer-release.jks
EOF
        log_step "Keystore generated successfully"
    fi
}

# Clean previous builds
clean_build() {
    log_step "Cleaning previous builds..."
    cd android-app
    flutter clean
    cd android
    ./gradlew clean
    cd ../..
    rm -rf android-app/build/
    rm -rf android-app/android/app/build/
}

# Update version in pubspec.yaml
update_version() {
    log_step "Updating version..."
    VERSION_NAME=$(grep "version:" android-app/pubspec.yaml | sed 's/version: //')
    NEW_VERSION="${VERSION_NAME%+*}+$BUILD_NUMBER"
    sed -i "s/version: .*/version: $NEW_VERSION/" android-app/pubspec.yaml
    log_step "Version updated to: $NEW_VERSION"
}

# Install dependencies
install_dependencies() {
    log_step "Installing Flutter dependencies..."
    cd android-app
    flutter pub get
    cd ..
}

# Run tests
run_tests() {
    log_step "Running tests..."
    cd android-app
    flutter test --coverage
    
    # Check code coverage
    if command -v lcov &> /dev/null; then
        COVERAGE=$(lcov --summary coverage/lcov.info 2>&1 | grep "lines......" | sed 's/.*: \([0-9.]*\)%.*/\1/')
        if (( $(echo "$COVERAGE < 60" | bc -l) )); then
            log_warning "Code coverage is below 60%: ${COVERAGE}%"
        else
            log_step "Code coverage: ${COVERAGE}%"
        fi
    fi
    cd ..
}

# Analyze code
analyze_code() {
    log_step "Analyzing code..."
    cd android-app
    flutter analyze
    
    # Run custom linting
    dart format --set-exit-if-changed .
    cd ..
}

# Build AAB (Android App Bundle)
build_aab() {
    log_step "Building release AAB..."
    cd android-app
    
    # Build with obfuscation and optimization
    flutter build appbundle \
        --release \
        --obfuscate \
        --split-debug-info=./debug-info \
        --dart-define=API_ENV=production \
        --dart-define=SENTRY_DSN="${SENTRY_DSN}" \
        --build-number=$BUILD_NUMBER
    
    # Verify AAB
    if [ ! -f "build/app/outputs/bundle/release/app-release.aab" ]; then
        log_error "AAB build failed!"
    fi
    
    AAB_SIZE=$(du -h build/app/outputs/bundle/release/app-release.aab | cut -f1)
    log_step "AAB built successfully (Size: $AAB_SIZE)"
    cd ..
}

# Build APK for testing
build_apk() {
    log_step "Building APK for testing..."
    cd android-app
    flutter build apk \
        --release \
        --split-per-abi \
        --obfuscate \
        --split-debug-info=./debug-info
    cd ..
}

# Upload to Play Store
upload_to_play_store() {
    log_step "Uploading to Google Play Store (${TRACK} track)..."
    
    # Check if fastlane is installed
    if ! command -v fastlane &> /dev/null; then
        log_warning "Fastlane not installed. Installing..."
        sudo gem install fastlane
    fi
    
    # Create Fastfile if doesn't exist
    mkdir -p android-app/android/fastlane
    cat > android-app/android/fastlane/Fastfile <<'RUBY'
default_platform(:android)

platform :android do
  desc "Deploy to Google Play Store"
  lane :deploy do |options|
    track = options[:track] || "internal"
    
    upload_to_play_store(
      track: track,
      aab: "../build/app/outputs/bundle/release/app-release.aab",
      json_key: ENV["PLAY_STORE_JSON_KEY_PATH"],
      package_name: "ai.pocketlawyer.app",
      skip_upload_metadata: false,
      skip_upload_images: false,
      skip_upload_screenshots: false,
      release_status: track == "production" ? "completed" : "draft",
      rollout: track == "production" ? "0.1" : nil  # 10% rollout for production
    )
    
    # Send success notification
    slack(
      message: "Successfully deployed to #{track} track! 🎉",
      success: true,
      default_payloads: [:git_branch, :git_author]
    ) if ENV["SLACK_URL"]
  end
  
  desc "Beta release"
  lane :beta do
    deploy(track: "beta")
  end
  
  desc "Production release"
  lane :production do
    deploy(track: "production")
  end
end
RUBY
    
    # Run fastlane
    cd android-app/android
    fastlane deploy track:$TRACK
    cd ../..
}

# Create GitHub release
create_github_release() {
    log_step "Creating GitHub release..."
    
    VERSION=$(grep "version:" android-app/pubspec.yaml | sed 's/version: //')
    
    # Generate changelog
    git log --pretty=format:"- %s" HEAD~10..HEAD > CHANGELOG.md
    
    # Create release using GitHub CLI
    if command -v gh &> /dev/null; then
        gh release create "v$VERSION" \
            --title "Release v$VERSION" \
            --notes-file CHANGELOG.md \
            android-app/build/app/outputs/bundle/release/app-release.aab \
            android-app/build/app/outputs/apk/release/*.apk
    else
        log_warning "GitHub CLI not installed. Skipping GitHub release."
    fi
}

# Send notifications
send_notifications() {
    log_step "Sending deployment notifications..."
    
    # Slack notification
    if [ -n "$SLACK_WEBHOOK" ]; then
        curl -X POST -H 'Content-type: application/json' \
            --data "{\"text\":\"🚀 Pocket Lawyer v$VERSION deployed to $TRACK track!\"}" \
            "$SLACK_WEBHOOK"
    fi
    
    # Discord notification
    if [ -n "$DISCORD_WEBHOOK" ]; then
        curl -X POST -H 'Content-type: application/json' \
            --data "{\"content\":\"🚀 **Pocket Lawyer** v$VERSION deployed to $TRACK track!\"}" \
            "$DISCORD_WEBHOOK"
    fi
}

# Pre-launch checklist
pre_launch_checklist() {
    log_step "Running pre-launch checklist..."
    
    echo "📋 Pre-Launch Checklist:"
    echo "   ✓ Privacy Policy URL configured"
    echo "   ✓ Terms of Service URL configured"
    echo "   ✓ Content rating completed"
    echo "   ✓ App icon (512x512) uploaded"
    echo "   ✓ Feature graphic (1024x500) uploaded"
    echo "   ✓ Screenshots (min 2, max 8) uploaded"
    echo "   ✓ App description optimized"
    echo "   ✓ Keywords selected"
    echo "   ✓ Contact email verified"
    echo "   ✓ In-app purchases configured"
    
    read -p "Have all items been completed? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_error "Complete the checklist before deployment!"
    fi
}

# ============================================
# MAIN DEPLOYMENT PIPELINE
# ============================================

main() {
    log_step "Starting deployment pipeline for track: $TRACK"
    
    # Load environment variables
    if [ -f .env ]; then
        export $(cat .env | xargs)
    else
        log_error ".env file not found!"
    fi
    
    # Pre-flight checks
    pre_launch_checklist
    
    # Deployment steps
    increment_build_number
    generate_keystore
    clean_build
    update_version
    install_dependencies
    analyze_code
    run_tests
    build_aab
    build_apk
    
    # Upload based on track
    case $TRACK in
        internal|alpha|beta|production)
            upload_to_play_store
            ;;
        *)
            log_error "Invalid track: $TRACK. Use: internal, alpha, beta, or production"
            ;;
    esac
    
    # Post-deployment
    create_github_release
    send_notifications
    
    # Archive debug symbols
    log_step "Archiving debug symbols..."
    tar -czf "debug-symbols-$BUILD_NUMBER.tar.gz" android-app/debug-info/
    
    # Upload to Crashlytics
    if [ -n "$FIREBASE_APP_ID" ]; then
        log_step "Uploading symbols to Crashlytics..."
        cd android-app/android
        ./gradlew uploadCrashlyticsSymbolFileRelease
        cd ../..
    fi
    
    log_step "✅ Deployment completed successfully!"
    echo "📱 Track: $TRACK"
    echo "🔢 Build: $BUILD_NUMBER"
    echo "📊 Version: $VERSION"
    echo "🎯 Package: $PACKAGE_NAME"
}

# Run main function
main

# ============================================
# QUICK COMMANDS (save as separate scripts)
# ============================================

# quick-test.sh
: '
#!/bin/bash
cd android-app
flutter test
flutter analyze
dart format --set-exit-if-changed .
'

# quick-build.sh
: '
#!/bin/bash
cd android-app
flutter build apk --debug
adb install build/app/outputs/flutter-apk/app-debug.apk
'

# monitor.sh
: '
#!/bin/bash
# Monitor app performance
adb logcat | grep -E "pocket-lawyer|Flutter"
'

# generate-icons.sh
: '
#!/bin/bash
# Generate app icons from single source
flutter pub run flutter_launcher_icons:main
'
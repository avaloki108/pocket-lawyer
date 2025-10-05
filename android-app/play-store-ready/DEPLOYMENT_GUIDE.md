# Pocket Lawyer - Deployment Guide

## Prerequisites

### Software Requirements
- Flutter SDK (latest stable version)
- Android Studio or VS Code with Flutter extensions
- Java JDK 11 or higher
- Git

### Accounts Needed
- Google Play Console account ($25 one-time fee)
- Firebase project (for analytics and crashlytics)
- API keys for:
  - OpenRouter API
  - DeepSeek API
  - LegiScan API
  - Congress.gov API

## Pre-Deployment Setup

### 1. Environment Configuration

Ensure your `.env` file is properly configured:

```env
OPENROUTER_API_KEY=your_key_here
DEEPSEEK_API_KEY=your_key_here
LEGISCAN_API_KEY=your_key_here
CONGRESS_API_KEY=your_key_here
FIREBASE_API_KEY=your_key_here
```

### 2. Update App Configuration

**File: `android-app/android/app/build.gradle`**

Verify these settings:
```gradle
android {
    compileSdkVersion 34
    defaultConfig {
        applicationId "ai.pocketlawyer.app"
        minSdkVersion 23
        targetSdkVersion 34
        versionCode 1
        versionName "1.0.0"
    }
}
```

### 3. Signing Configuration

**File: `android-app/android/app/build.gradle`**

Add signing configuration:
```gradle
android {
    signingConfigs {
        release {
            storeFile file("../../pocket-lawyer.jks")
            storePassword System.getenv("KEYSTORE_PASSWORD")
            keyAlias System.getenv("KEY_ALIAS")
            keyPassword System.getenv("KEY_PASSWORD")
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            shrinkResources true
        }
    }
}
```

**Note:** The keystore file `pocket-lawyer.jks` already exists in the project root.

## Build Process

### Step 1: Clean Previous Builds

```bash
cd android-app
flutter clean
flutter pub get
```

### Step 2: Run Tests (Optional but Recommended)

```bash
flutter test
```

### Step 3: Build App Bundle (Recommended for Play Store)

```bash
flutter build appbundle --release
```

Output: `android-app/build/app/outputs/bundle/release/app-release.aab`

### Step 4: Build APK (for Testing)

```bash
flutter build apk --release
```

Output: `android-app/build/app/outputs/flutter-apk/app-release.apk`

### Step 5: Verify Build

Check file sizes:
- AAB should be ~40-50 MB
- APK should be ~50-60 MB

## Google Play Console Setup

### 1. Create App

1. Go to https://play.google.com/console
2. Click "Create app"
3. Fill in details:
   - App name: **Pocket Lawyer - AI Legal Assistant**
   - Default language: English (United States)
   - App or game: App
   - Free or paid: Free
4. Accept declarations and create app

### 2. Complete App Content

#### Data Safety
Navigate to: App content > Data safety

**Data Collection:**
- Personal info: Email address (optional for account)
- App activity: No
- App info and performance: Crash logs
- Files and docs: No
- Location: No
- Financial info: No
- Health and fitness: No
- Messages: No
- Photos and videos: No
- Audio files: No
- Music files: No
- Other files: No
- Contacts: No
- Calendar: No

**Data Usage:**
- All collected data is encrypted in transit
- Data is not shared with third parties
- Users can request data deletion

#### Privacy Policy
- Upload privacy policy to your website
- Add URL: `https://pocketlawyer.ai/privacy-policy`

#### App Access
- All features available without special access
- No login required for basic features
- Pro features require subscription

#### Ads
- Contains ads: Yes (Google Mobile Ads)

#### Content Rating
Complete the questionnaire:
- Target age group: Everyone
- Does your app contain violence? No
- Does your app contain sexual content? No
- Does your app contain profanity? No
- Does your app reference controlled substances? No
- Does your app contain gambling? No
- Expected rating: Everyone / PEGI 3

#### Target Audience
- Target age: 18 and older
- App appeals to children: No

#### News App
- Is this a news app? No

#### COVID-19 Contact Tracing
- Is this a COVID-19 contact tracing app? No

#### Data Security
- Encryption in transit: Yes (TLS/SSL)
- Data deletion: Yes (user can request)

### 3. Store Settings

Navigate to: Main store listing

#### App Details
- App name: **Pocket Lawyer - AI Legal Assistant**
- Short description: (Copy from PLAY_STORE_LISTING.md)
- Full description: (Copy from PLAY_STORE_LISTING.md)
- App icon: Upload 512x512 PNG
- Feature graphic: Upload 1024x500 PNG/JPG
- Phone screenshots: Upload 2-8 images (1080x1920 recommended)

#### Categorization
- App category: Business
- Tags: legal, law, lawyer, AI, assistant

#### Contact Details
- Email: support@pocketlawyer.ai
- Phone: (optional)
- Website: https://pocketlawyer.ai

#### Store Listing Experiments (Optional)
- Test different icons, screenshots, and descriptions

### 4. Release Setup

Navigate to: Production > Create new release

#### Upload App Bundle
1. Upload `app-release.aab`
2. Google Play will automatically generate APKs for different device configurations

#### Release Name
```
Version 1.0.0 - Initial Release
```

#### Release Notes
```
🚀 Version 1.0.0 - Initial Release

✨ New Features:
• Comprehensive legal database with 8M+ cases
• AI-powered legal analysis
• State & federal law search
• Case law research with citations
• Legal document templates
• Referral system - Earn Pro access!
• In-app reviews and social sharing
• Multi-state coverage (all 50 states)
• Secure end-to-end encryption
• Free tier with 5 daily queries

Start your legal research journey today!
```

### 5. Pricing & Distribution

Navigate to: Pricing & distribution

- Countries: Select all or specific countries
- Pricing: Free
- Contains ads: Yes
- In-app purchases: Yes
- Content rating: Everyone
- Primary category: Business
- Tags: legal, law, lawyer, AI

### 6. In-App Products Setup

Navigate to: Monetize > In-app products

Create subscription products:

**Pro Monthly**
- Product ID: `pro_monthly`
- Name: Pro Monthly
- Description: Unlimited queries and premium features
- Price: $9.99 USD
- Billing period: Every 1 month

**Pro Yearly**
- Product ID: `pro_yearly`
- Name: Pro Yearly
- Description: Unlimited queries and premium features (Save $30!)
- Price: $89.99 USD
- Billing period: Every 1 year

**Team Monthly**
- Product ID: `team_monthly`
- Name: Team Monthly
- Description: Multi-user access for up to 5 users
- Price: $29.99 USD
- Billing period: Every 1 month

**Team Yearly**
- Product ID: `team_yearly`
- Name: Team Yearly
- Description: Multi-user access for up to 5 users (Save $80!)
- Price: $279.99 USD
- Billing period: Every 1 year

## Pre-Launch Testing

### Internal Testing Track

1. Navigate to: Testing > Internal testing
2. Create release
3. Upload AAB
4. Add testers (email addresses)
5. Share opt-in URL with testers
6. Collect feedback for 3-7 days

### Closed Testing Track (Optional)

1. Navigate to: Testing > Closed testing
2. Create release
3. Add tester list (up to 100 users)
4. Get feedback on real devices
5. Fix any issues found

## Launch!

### Review & Roll Out

1. Navigate to: Production > Create new release
2. Upload final AAB
3. Complete all required sections (should see all green checkmarks)
4. Review all information
5. Click "Roll out to production"

### Expected Review Time
- First submission: 2-3 hours to 7 days
- Typically approved within 2-3 hours
- Monitor email for approval/rejection

## Post-Launch

### Monitor Performance

#### Google Play Console
- Dashboard for downloads, ratings, crashes
- User reviews and feedback
- Revenue (for in-app purchases)
- Pre-launch reports

#### Firebase Console
- Analytics: User engagement, retention
- Crashlytics: Crash reports and stack traces
- Performance: App startup time, network requests

### Respond to Reviews
- Reply to user reviews within 24-48 hours
- Address bugs and feature requests
- Thank users for positive reviews

### Update Strategy

#### Version Updates
1. Increment version in `pubspec.yaml`:
   ```yaml
   version: 1.0.1+2  # 1.0.1 is version name, 2 is version code
   ```
2. Build new AAB/APK
3. Create new release in Play Console
4. Add release notes
5. Roll out (can use staged rollout: 20% → 50% → 100%)

#### Staged Rollout
- Start with 20% of users
- Monitor for crashes/issues
- Increase to 50% after 1-2 days
- Full rollout after 3-5 days

## Troubleshooting

### Common Issues

**Build Fails**
```bash
flutter clean
flutter pub get
flutter build appbundle --release --verbose
```

**Signing Issues**
- Verify keystore file exists
- Check environment variables
- Ensure passwords are correct

**Upload Rejected**
- Check for policy violations
- Ensure all required sections completed
- Verify app icon and screenshots meet requirements

**App Not Appearing in Search**
- Wait 24-48 hours for indexing
- Optimize keywords and description
- Encourage early downloads and reviews

### Support Channels

**Flutter Issues:**
- https://github.com/flutter/flutter/issues
- https://stackoverflow.com/questions/tagged/flutter

**Play Console Issues:**
- https://support.google.com/googleplay/android-developer

**App-Specific Issues:**
- Create GitHub issues in your repository
- Email: support@pocketlawyer.ai

## Security Checklist

- [ ] API keys stored securely (not in code)
- [ ] App uses HTTPS for all network requests
- [ ] Sensitive data encrypted at rest
- [ ] ProGuard enabled for release builds
- [ ] No debug information in release build
- [ ] Privacy policy accessible online
- [ ] Terms of service accessible online
- [ ] User data handling compliant with GDPR/CCPA

## Marketing & Promotion

### Pre-Launch (1-2 weeks before)
- [ ] Create social media accounts
- [ ] Build landing page
- [ ] Create promotional video
- [ ] Reach out to tech bloggers
- [ ] Prepare press release

### Launch Day
- [ ] Announce on social media
- [ ] Send to email list
- [ ] Submit to app directories (AppAdvice, AppRater, etc.)
- [ ] Post in relevant communities (Reddit r/legaltech, r/androidapps)
- [ ] Reach out to influencers

### Post-Launch
- [ ] Monitor and respond to reviews
- [ ] Track analytics and KPIs
- [ ] Implement referral program
- [ ] Create content marketing materials
- [ ] Regular app updates and improvements

## Metrics to Track

### Key Performance Indicators (KPIs)
- Daily Active Users (DAU)
- Monthly Active Users (MAU)
- User retention (Day 1, Day 7, Day 30)
- Conversion rate (free to paid)
- Average revenue per user (ARPU)
- Referral rate
- App store rating
- Crash-free rate

### Target Metrics (First 3 Months)
- 1,000+ installs
- 4.0+ star rating
- 70%+ Day 1 retention
- 30%+ Day 30 retention
- 5%+ conversion to Pro
- 99.5%+ crash-free rate

## Files Included

In the `play-store-ready` directory:

1. **app-release.aab** - Production app bundle (49 MB) ✓
2. **test.apk** - Test APK for device testing (22 MB) ✓
3. **README.txt** - Basic upload information ✓
4. **PLAY_STORE_LISTING.md** - Complete store listing content ✓
5. **DEPLOYMENT_GUIDE.md** - This file ✓

## Next Steps

1. Review all files in `play-store-ready` directory
2. Create/obtain required graphics (icon, feature graphic, screenshots)
3. Set up Google Play Console account
4. Configure environment variables for signing
5. Build release AAB
6. Complete Play Console setup
7. Submit for review
8. Launch! 🚀

## Support

For deployment assistance:
- Email: support@pocketlawyer.ai
- Documentation: See PLAY_STORE_LISTING.md
- Build issues: Check Flutter documentation

---

**Good luck with your launch! 🎉**

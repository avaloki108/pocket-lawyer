# Pocket Lawyer (Flutter)

A Flutter application providing a legal assistant interface with secure storage, biometric auth, and integration points for legislative and AI APIs.

## Features (Current State)
- Splash screen with (optional) biometric authentication
- Home navigation to Chat, Prompts, Settings (placeholders for expansion)
- Riverpod for state management
- Secure storage abstraction
- Pluggable API client repository with graceful OpenAI fallback
- .env + `--dart-define` hybrid configuration for secrets

## Environment Configuration
Secrets are NOT committed. You configure API keys via either:
1. A local `.env` file (development convenience)
2. `--dart-define` at build/run time (recommended for CI / production)

### 1. Create your local `.env`
Copy the example file and fill in values:
```
cd android-app
copy .env.example .env  (Windows)
# OR
cp .env.example .env    (macOS/Linux)
```
Edit `.env`:
```
OPENAI_API_KEY=sk-your-key
LEGISCAN_API_KEY=your-legiscan-key
CONGRESS_GOV_API_KEY=your-congress-key
PINECONE_API_KEY=optional-pinecone
HARVARD_CAP_API_KEY=optional-harvard-cap
DISABLE_BIOMETRIC=false
```
`DISABLE_BIOMETRIC=true` can be set for simulators/emulators or automated tests.

### 2. Using `--dart-define`
You can override (or replace) `.env` values at runtime:
```
flutter run ^
  --dart-define=OPENAI_API_KEY=sk-your-key ^
  --dart-define=LEGISCAN_API_KEY=your-legiscan-key ^
  --dart-define=CONGRESS_GOV_API_KEY=your-congress-key
```
Precedence: dart-define > .env file > empty.

### Security Notes
- Never commit a real `.env` (already ignored in root `.gitignore`).
- Treat anything inside a distributed mobile binary as recoverable by users; do not ship production secrets inside `.env` for release builds—prefer server-side proxying or ephemeral tokens.
- Consider moving OpenAI access through your own backend to apply policy controls, logging, and rate limiting.

## Running the App (Windows cmd.exe)
From repository root:
```
cd android-app
flutter pub get
flutter run
```
Optionally with biometric disabled for faster dev:
```
flutter run --dart-define=DISABLE_BIOMETRIC=true
```

## Running Tests
```
cd android-app
flutter test
```
The provided widget test:
- Loads a test env (disables biometric, supplies dummy keys)
- Pumps the app and asserts Splash -> Home navigation

## Adding New API Integrations
1. Add any new keys to `.env.example` and constants resolution if needed.
2. Access keys via `AppConstants.someApiKey` (auto-resolves dart-define or .env).
3. Avoid hardcoding secrets directly in source.

## Troubleshooting
| Issue | Resolution |
|-------|------------|
| Missing API key warning in console | Add to `.env` or pass via `--dart-define` |
| Biometric dialog blocks tests | Set `DISABLE_BIOMETRIC=true` |
| Keys not updating after change | `flutter clean` then restart, or ensure not overridden by dart-define |
| OpenAI fallback errors | Check network connectivity and key validity |

## Future Enhancements (Suggested)
- Implement actual Pinecone vector search client using `pineconeApiKey`
- Add Harvard CAP case law retrieval using `harvardCapApiKey`
- Introduce caching & offline persistence (Hive integration placeholder)
- Add structured logging + error reporting
- Replace direct OpenAI calls with a backend mediator service

## License
(Define your license here – currently unspecified.)

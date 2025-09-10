# Build Instructions

## Build APK for Assessment

1. **Clean previous builds:**
   ```bash
   flutter clean
   flutter pub get
   ```

2. **Build release APK:**
   ```bash
   flutter build apk --dart-define-from-file=config.json --release
   ```

3. **Copy APK to dist folder:**
   ```bash
   cp build/app/outputs/flutter-apk/app-release.apk dist/technonext-car-route-app.apk
   ```

## APK Location
After building, the APK will be available at:
- `dist/technonext-car-route-app.apk`

## Requirements
- Google Maps API key must be configured in `config.json`
- Android device or emulator for testing
- Internet connection for map tiles and routing

## Features Verified
- ✅ Map loading and interaction
- ✅ Location permission handling
- ✅ Point selection on map
- ✅ Route calculation and display
- ✅ Current location functionality
- ✅ State management working

# 🚀 Deployment Guide - Habit Tracker

## Complete guide to deploy your app to all platforms

---

## 📋 Pre-Deployment Checklist

### 1. **Test Everything**
```bash
# Run tests
flutter test

# Check for issues
flutter analyze

# Test on devices
flutter run --release
```

### 2. **Update Version**
Edit `pubspec.yaml`:
```yaml
version: 1.0.0+1  # version+build_number
```

### 3. **Configure Firebase**
- ✅ Firebase project created
- ✅ Authentication enabled
- ✅ Firestore database created
- ✅ Security rules configured

### 4. **Deploy Cloud Functions** (Optional)
```bash
cd functions
npm install
firebase deploy --only functions
```

---

## 📱 Android Deployment

### Step 1: Configure App

**Edit `android/app/build.gradle`:**
```gradle
android {
    defaultConfig {
        applicationId "com.yourcompany.habittracker"
        minSdkVersion 21
        targetSdkVersion 34
        versionCode 1
        versionName "1.0.0"
    }
}
```

### Step 2: Create Keystore

```bash
# Generate keystore
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload

# Move to android/app
mv ~/upload-keystore.jks android/app/
```

### Step 3: Configure Signing

**Create `android/key.properties`:**
```properties
storePassword=your_store_password
keyPassword=your_key_password
keyAlias=upload
storeFile=upload-keystore.jks
```

**Update `android/app/build.gradle`:**
```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
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

### Step 4: Build APK/AAB

```bash
# Build APK (for testing)
flutter build apk --release

# Build App Bundle (for Play Store)
flutter build appbundle --release
```

**Output:**
- APK: `build/app/outputs/flutter-apk/app-release.apk`
- AAB: `build/app/outputs/bundle/release/app-release.aab`

### Step 5: Upload to Google Play

1. **Go to** [Google Play Console](https://play.google.com/console)
2. **Create app** → Fill in details
3. **Upload AAB** → Production/Testing track
4. **Fill store listing**:
   - Title: "Habitual - Habit Tracker"
   - Short description
   - Full description
   - Screenshots (phone, tablet)
   - Feature graphic
   - App icon
5. **Set pricing** → Free or Paid
6. **Content rating** → Complete questionnaire
7. **Submit for review**

---

## 🍎 iOS Deployment

### Step 1: Configure Xcode

```bash
# Open Xcode
open ios/Runner.xcworkspace
```

**In Xcode:**
1. Select **Runner** → **General**
2. Set **Bundle Identifier**: `com.yourcompany.habittracker`
3. Set **Version**: `1.0.0`
4. Set **Build**: `1`
5. Select **Team** (Apple Developer account)

### Step 2: Configure Signing

1. **Signing & Capabilities** tab
2. Enable **Automatically manage signing**
3. Select your **Team**
4. Xcode will create provisioning profiles

### Step 3: Update Info.plist

**Edit `ios/Runner/Info.plist`:**
```xml
<key>CFBundleDisplayName</key>
<string>Habitual</string>
<key>NSUserNotificationsUsageDescription</key>
<string>We need notification permission to remind you about your habits</string>
<key>NSCameraUsageDescription</key>
<string>To take photos for your habits</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>To select photos for your habits</string>
```

### Step 4: Build IPA

```bash
# Build for iOS
flutter build ios --release

# Or build IPA directly
flutter build ipa --release
```

### Step 5: Upload to App Store

**Option A: Using Xcode**
1. Open `ios/Runner.xcworkspace`
2. Select **Product** → **Archive**
3. Click **Distribute App**
4. Choose **App Store Connect**
5. Follow wizard

**Option B: Using Transporter**
1. Build IPA: `flutter build ipa`
2. Open **Transporter** app
3. Drag IPA file
4. Click **Deliver**

**Option C: Using Command Line**
```bash
# Install fastlane
gem install fastlane

# Upload
fastlane deliver
```

### Step 6: App Store Connect

1. **Go to** [App Store Connect](https://appstoreconnect.apple.com)
2. **Create app** → Fill details
3. **Upload build** (from Xcode/Transporter)
4. **Fill app information**:
   - Name: "Habitual - Habit Tracker"
   - Subtitle
   - Description
   - Keywords
   - Screenshots (iPhone, iPad)
   - App icon
5. **Set pricing** → Free or Paid
6. **Submit for review**

---

## 🌐 Web Deployment

### Step 1: Build Web

```bash
# Build for web
flutter build web --release

# Output in: build/web/
```

### Step 2: Deploy to Firebase Hosting

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login
firebase login

# Initialize hosting
firebase init hosting

# Select:
# - Public directory: build/web
# - Single-page app: Yes
# - Overwrite index.html: No

# Deploy
firebase deploy --only hosting
```

**Your app will be live at:**
`https://your-project-id.web.app`

### Step 3: Custom Domain (Optional)

```bash
# Add custom domain
firebase hosting:channel:deploy production --domain yourdomain.com
```

### Alternative: Deploy to Netlify

```bash
# Install Netlify CLI
npm install -g netlify-cli

# Deploy
cd build/web
netlify deploy --prod
```

### Alternative: Deploy to Vercel

```bash
# Install Vercel CLI
npm install -g vercel

# Deploy
cd build/web
vercel --prod
```

---

## 🖥️ Desktop Deployment

### Windows

```bash
# Build Windows app
flutter build windows --release

# Output: build/windows/runner/Release/
```

**Create Installer:**
```bash
# Install Inno Setup
# Create installer script

# Or use MSIX
flutter pub add msix
flutter pub run msix:create
```

### macOS

```bash
# Build macOS app
flutter build macos --release

# Output: build/macos/Build/Products/Release/
```

**Create DMG:**
```bash
# Install create-dmg
brew install create-dmg

# Create DMG
create-dmg \
  --volname "Habitual" \
  --window-pos 200 120 \
  --window-size 800 400 \
  --icon-size 100 \
  --app-drop-link 600 185 \
  "Habitual.dmg" \
  "build/macos/Build/Products/Release/habitual.app"
```

### Linux

```bash
# Build Linux app
flutter build linux --release

# Output: build/linux/x64/release/bundle/
```

**Create AppImage:**
```bash
# Install appimagetool
# Package your app
```

---

## 🔧 Environment Configuration

### Production vs Development

**Create environment files:**

**`.env.production`:**
```
API_URL=https://us-central1-habit-tracker-93de7.cloudfunctions.net/api
FIREBASE_PROJECT_ID=habit-tracker-93de7
ENVIRONMENT=production
```

**`.env.development`:**
```
API_URL=http://localhost:5001/habit-tracker-93de7/us-central1/api
FIREBASE_PROJECT_ID=habit-tracker-93de7
ENVIRONMENT=development
```

**Use in code:**
```dart
const apiUrl = String.fromEnvironment('API_URL');
```

**Build with environment:**
```bash
flutter build apk --dart-define=API_URL=https://your-api.com
```

---

## 📊 Analytics & Monitoring

### Firebase Analytics

**Add to `pubspec.yaml`:**
```yaml
dependencies:
  firebase_analytics: ^10.7.0
```

**Initialize:**
```dart
import 'package:firebase_analytics/firebase_analytics.dart';

final analytics = FirebaseAnalytics.instance;

// Log events
analytics.logEvent(
  name: 'habit_completed',
  parameters: {'habit_id': habitId},
);
```

### Crashlytics

**Add to `pubspec.yaml`:**
```yaml
dependencies:
  firebase_crashlytics: ^3.4.0
```

**Initialize:**
```dart
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
```

---

## 🔐 Security Checklist

- [ ] Remove debug prints
- [ ] Obfuscate code
- [ ] Secure API keys
- [ ] Enable ProGuard (Android)
- [ ] Configure Firebase Security Rules
- [ ] Enable SSL pinning
- [ ] Remove test accounts
- [ ] Update privacy policy
- [ ] Add terms of service

### Obfuscate Code

```bash
flutter build apk --obfuscate --split-debug-info=build/debug-info
flutter build appbundle --obfuscate --split-debug-info=build/debug-info
flutter build ios --obfuscate --split-debug-info=build/debug-info
```

---

## 📝 Store Listing Assets

### Required Assets

**App Icon:**
- Android: 512x512 PNG
- iOS: 1024x1024 PNG
- Adaptive icon (Android)

**Screenshots:**
- Phone: 1080x1920 (5-8 images)
- Tablet: 1536x2048 (optional)
- iPhone: 1242x2688
- iPad: 2048x2732

**Feature Graphic:**
- 1024x500 PNG (Google Play)

**Promotional Images:**
- Various sizes for marketing

### Description Template

**Short Description:**
```
Build better habits with Habitual - Beautiful, simple, and effective habit tracking with streak visualization and smart reminders.
```

**Full Description:**
```
🎯 HABITUAL - YOUR PERSONAL HABIT TRACKER

Build lasting habits with our beautiful and intuitive habit tracker. Track your progress, maintain streaks, and achieve your goals!

✨ KEY FEATURES:
• Beautiful GitHub-style streak heatmap
• Smart reminders with custom scheduling
• 9 stunning themes including AMOLED black
• Detailed statistics and analytics
• Achievement system
• Calendar view
• Export your data
• Offline support

🎨 CUSTOMIZATION:
• Multiple themes (Ocean Blue, Forest Green, Sunset, and more)
• Custom habit icons
• Personalized accent colors
• Dark mode support

📊 TRACK YOUR PROGRESS:
• Visual streak heatmap
• Detailed statistics
• Calendar view
• Achievement badges
• Export reports

🔔 NEVER MISS A HABIT:
• Smart reminders
• Custom scheduling
• Personalized messages
• Multiple reminders per habit

💎 PREMIUM FEATURES:
• Unlimited habits
• Premium themes
• Advanced analytics
• Data export
• Priority support

Download Habitual today and start building better habits! 🚀
```

---

## 🚀 Deployment Commands Summary

```bash
# Android
flutter build appbundle --release --obfuscate --split-debug-info=build/debug-info

# iOS
flutter build ipa --release --obfuscate --split-debug-info=build/debug-info

# Web
flutter build web --release

# Windows
flutter build windows --release

# macOS
flutter build macos --release

# Linux
flutter build linux --release
```

---

## 📱 Testing Before Release

### Beta Testing

**Android (Google Play):**
1. Create **Internal Testing** track
2. Upload AAB
3. Add testers by email
4. Share testing link

**iOS (TestFlight):**
1. Upload build to App Store Connect
2. Add to TestFlight
3. Add testers
4. Share TestFlight link

**Web:**
```bash
# Deploy to staging
firebase hosting:channel:deploy staging
```

---

## 🔄 CI/CD Setup (Optional)

### GitHub Actions

**Create `.github/workflows/deploy.yml`:**
```yaml
name: Deploy

on:
  push:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter test
      - run: flutter build appbundle --release
      - uses: r0adkll/upload-google-play@v1
        with:
          serviceAccountJsonPlainText: ${{ secrets.SERVICE_ACCOUNT_JSON }}
          packageName: com.yourcompany.habittracker
          releaseFiles: build/app/outputs/bundle/release/app-release.aab
          track: production
```

---

## 📊 Post-Launch

### Monitor

- [ ] Check crash reports
- [ ] Monitor analytics
- [ ] Read user reviews
- [ ] Track downloads
- [ ] Monitor performance

### Update

```bash
# Increment version
# pubspec.yaml: version: 1.0.1+2

# Build and deploy
flutter build appbundle --release
# Upload to stores
```

---

## 🆘 Troubleshooting

### Build Errors

**Android:**
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter build appbundle
```

**iOS:**
```bash
cd ios
pod deintegrate
pod install
cd ..
flutter clean
flutter pub get
flutter build ios
```

### Common Issues

**Issue:** Signing error (iOS)
**Fix:** Check provisioning profiles in Xcode

**Issue:** Build fails (Android)
**Fix:** Update Gradle version

**Issue:** Firebase not working
**Fix:** Re-download google-services.json / GoogleService-Info.plist

---

## 📚 Resources

- [Flutter Deployment Docs](https://docs.flutter.dev/deployment)
- [Google Play Console](https://play.google.com/console)
- [App Store Connect](https://appstoreconnect.apple.com)
- [Firebase Console](https://console.firebase.google.com)

---

**Your app is ready to deploy! 🎉**

Choose your platform and follow the steps above!

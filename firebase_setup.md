# Firebase Setup Guide 🔥

Complete guide to setting up Firebase for the Laza E-commerce mobile app.

## Prerequisites

- Google Account
- Flutter project created
- Firebase CLI (optional, for deployment)

---

## Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click **Add project**
3. Enter project name: `laza-ecommerce` (or your choice)
4. Disable Google Analytics (optional for MVP)
5. Click **Create project**

---

## Step 2: Register Android App

1. In Firebase Console, click **Android icon** (⚙️)
2. **Android package name**: `com.example.laza` (must match `android/app/build.gradle`)
   ```gradle
   // Check in android/app/build.gradle:
   applicationId "com.example.laza"
   ```
3. **App nickname**: Laza Android (optional)
4. Click **Register app**
5. **Download `google-services.json`**
6. Move file to: `android/app/google-services.json`

### Verify Android Configuration

```bash
# Check if file exists
ls android/app/google-services.json
```

---

## Step 3: Register iOS App (Optional, macOS only)

1. In Firebase Console, click **iOS icon** (🍎)
2. **iOS bundle ID**: `com.example.laza` (must match Xcode project)
   - Open `ios/Runner.xcworkspace` in Xcode
   - Check **Bundle Identifier** in General tab
3. Click **Register app**
4. **Download `GoogleService-Info.plist`**
5. Open Xcode: `ios/Runner.xcworkspace`
6. Drag `GoogleService-Info.plist` into `Runner` folder (in Xcode, not Finder)
7. Ensure **Copy items if needed** is checked

---

## Step 4: Enable Authentication

1. In Firebase Console → **Authentication**
2. Click **Get started**
3. Go to **Sign-in method** tab
4. Enable **Email/Password**
   - Click **Email/Password**
   - Toggle **Enable**
   - Click **Save**

---

## Step 5: Create Firestore Database

1. In Firebase Console → **Firestore Database**
2. Click **Create database**
3. **Select location**: Choose closest region (e.g., `us-central`)
4. **Security rules**: Start in **Test mode** (we'll update later)
5. Click **Create**

---

## Step 6: Deploy Firestore Security Rules

### Option 1: Firebase CLI (Recommended)

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Initialize Firebase in project (one-time only)
firebase init firestore

# Select:
# - Use existing project: laza-ecommerce
# - Firestore rules file: firestore.rules
# - Firestore indexes file: firestore.indexes.json (default)

# Deploy rules
firebase deploy --only firestore:rules
```

### Option 2: Manual (Firebase Console)

1. Go to **Firestore Database** → **Rules** tab
2. Copy contents from `firestore.rules`
3. Paste into Firebase Console editor
4. Click **Publish**

### Verify Rules

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    match /carts/{userId}/items/{itemId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    match /favorites/{userId}/items/{itemId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

---

## Step 7: Test Firebase Connection

### Test on Android

```bash
flutter clean
flutter pub get
flutter run
```

**Expected console output:**
```
Firebase initialized successfully
```

### Test on iOS

```bash
cd ios
pod install
cd ..
flutter run
```

---

## Step 8: Verify Firestore Collections

1. **Sign up** a test user in the app
2. **Add items to cart** and **favorites**
3. Check Firebase Console → **Firestore Database**
4. You should see:
   ```
   users/
     {userId}/
       - email: "test@example.com"
       - createdAt: timestamp
   
   carts/
     {userId}/
       items/
         {productId}/
           - id, title, price, quantity...
   
   favorites/
     {userId}/
       items/
         {productId}/
           - id, title, price, image
   ```

---

## Troubleshooting

### "No Firebase App '[DEFAULT]' has been created"

**Cause**: Missing or incorrect configuration files.

**Solution**:
1. Verify `google-services.json` is in `android/app/`
2. Verify `GoogleService-Info.plist` is in `ios/Runner/` (via Xcode)
3. Run:
   ```bash
   flutter clean
   flutter pub get
   ```
4. Rebuild app

**Alternative**: App will use **Mock Mode** automatically if Firebase fails to initialize.

### Firestore Permission Denied

**Cause**: Security rules not deployed or incorrect.

**Solution**:
1. Check rules in Firebase Console
2. Ensure user is authenticated (`request.auth != null`)
3. Verify UID matches (`request.auth.uid == userId`)

### iOS Build Errors

**Cause**: CocoaPods or plist not configured.

**Solution**:
```bash
cd ios
pod deintegrate
pod install
cd ..
flutter clean
flutter run
```

---

## Environment Variables (Optional)

For multiple Firebase environments (dev, prod):

### Using FlutterFire CLI

```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase
flutterfire configure

# This generates lib/firebase_options.dart
```

Then in `main.dart`:
```dart
import 'firebase_options.dart';

await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

---

## Next Steps

1. ✅ Firebase project created
2. ✅ Android/iOS apps registered
3. ✅ Authentication enabled
4. ✅ Firestore database created
5. ✅ Security rules deployed
6. ✅ App tested and connected

**You're all set!** 🎉

For issues, check [Firebase Documentation](https://firebase.google.com/docs) or the app's README.md.

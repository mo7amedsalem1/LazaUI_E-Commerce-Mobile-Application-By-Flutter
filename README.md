# Laza E-commerce Mobile App 🛍️

A modern e-commerce mobile application built with Flutter for both iOS and Android platforms, featuring Firebase authentication, real-time Firestore database, and integration with the Platzi Fake Store API.

![Flutter](https://img.shields.io/badge/Flutter-02569B?logo=flutter&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?logo=firebase&logoColor=black)
![Dart](https://img.shields.io/badge/Dart-0175C2?logo=dart&logoColor=white)

## ✨ Features

- 🔐 **Authentication**: Email/password sign up, login, and password reset with Firebase
- 📱 **Onboarding**: 3-page welcome carousel for first-time users
- 🛒 **Shopping**: Browse products from Platzi Fake Store API with search
- 💚 **Favorites**: Save products to wishlist with Firestore persistence
- 🛍️ **Cart**: Add/remove items with quantity management
- 💳 **Checkout**: Mock checkout process with cart clearing
- 👤 **Profile**: User profile with logout functionality
- 🎨 **Laza UI**: Modern, clean design following Laza UI Kit with Poppins typography

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK** (3.9.2 or higher)
- **Dart SDK** (included with Flutter)
- **Android Studio** / **Xcode** (for Android/iOS development)
- **Firebase Account**
- **Git**

### 1. Install Flutter

#### Windows
```bash
# Download Flutter SDK from https://flutter.dev/docs/get-started/install/windows
# Extract to C:\src\flutter
# Add to PATH: C:\src\flutter\bin

flutter doctor
```

#### macOS/Linux
```bash
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"
flutter doctor
```

### 2. Clone Repository

```bash
git clone <your-repo-url>
cd e-commerce mobile application
```

### 3. Install Dependencies

```bash
flutter pub get
```

### 4. Firebase Setup

**See [firebase_setup.md](firebase_setup.md) for detailed instructions.**

Quick steps:
1. Create Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
2. Add Android/iOS apps
3. Download `google-services.json` (Android) → `android/app/`
4. Download `GoogleService-Info.plist` (iOS) → `ios/Runner/`
5. Enable Email/Password authentication
6. Create Firestore database
7. Deploy Firestore rules from `firestore.rules`

### 5. Install Firestore Rules

```bash
firebase deploy --only firestore:rules
```

Or manually copy from `firestore.rules` to Firebase Console → Firestore Database → Rules.

## 📱 Running the App

### Android

```bash
flutter run
```

Or using Android Studio:
1. Open project
2. Select Android emulator/device
3. Click Run ▶️

### iOS (macOS only)

```bash
cd ios
pod install
cd ..
flutter run
```

Or using Xcode:
1. Open `ios/Runner.xcworkspace`
2. Select iOS simulator/device
3. Click Run ▶️

### Build APK (Android)

```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

### Build iOS (macOS only)

```bash
flutter build ios --release
```

## 🧪 Testing

### Appium E2E Tests

See [tests/appium/README.md](tests/appium/README.md) for detailed setup.

```bash
# Install dependencies
pip install Appium-Python-Client

# Run tests
python tests/appium/auth_test.py
python tests/appium/cart_test.py
```

## 🗂️ Project Structure

```
lib/
├── models/           # Data models (Product)
├── providers/        # State management (Auth, Cart, Wishlist)
├── screens/          # UI screens
│   ├── auth/        # Login, SignUp, Onboarding
│   ├── home/        # Product browsing
│   ├── product/     # Product details, Favorites
│   ├── cart/        # Shopping cart
│   └── profile/     # User profile
├── services/         # Firebase & API services
├── widgets/          # Reusable components
└── main.dart         # App entry point

tests/
└── appium/          # E2E test scripts
```

## 🔥 Firestore Collections

```
users/{uid}
  - email: string
  - createdAt: timestamp

carts/{userId}/items/{productId}
  - id: number
  - title: string
  - price: number
  - image: string
  - quantity: number
  - totalPrice: number

favorites/{userId}/items/{productId}
  - id: number
  - title: string
  - price: number
  - image: string
```

## 📦 Dependencies

```yaml
dependencies:
  firebase_core: ^4.2.1
  firebase_auth: ^6.1.2
  cloud_firestore: ^6.1.0
  http: ^1.6.0
  provider: ^6.1.5+1
  google_fonts: ^6.1.0
  shared_preferences: ^2.3.3
```

## 🎨 Design

Based on **Laza E-commerce UI Kit** (Figma):
- **Font**: Poppins (via Google Fonts)
- **Colors**: Purple primary (#9775FA), Dark text (#1D1E20)
- **Style**: Clean, minimal, modern e-commerce design

## 🔐 Mock Mode

If Firebase is not configured, the app automatically switches to **Mock Mode**:
- In-memory authentication (no real Firebase)
- Local storage for cart and favorites
- Perfect for UI testing without backend setup

## 📸 Screenshots

> Add screenshots here after building the app

## 🐛 Troubleshooting

### "No Firebase App"
- Ensure `google-services.json` / `GoogleService-Info.plist` are in correct locations
- Run `flutter clean && flutter pub get`
- App will use Mock Mode if Firebase fails to initialize

### Build Errors
```bash
flutter clean
flutter pub get
flutter run
```

## 📄 License

This project is for educational purposes.

## 👥 Contributors

- Your Name

## 🔗 Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Platzi Fake Store API](https://fakeapi.platzi.com/)
- [Laza UI Kit](https://www.figma.com/community)

# SSM Student Hub - Flutter ERP Application Setup Guide

## Project Overview
SSM Student Hub is a comprehensive Flutter + Firebase College ERP mobile application designed for student information management, attendance tracking, marks management, and real-time notifications.

## Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK
- Firebase account
- Firebase CLI
- Android Studio or Xcode (for emulator)
- Git

## Step 1: Firebase Project Setup

### 1.1 Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add Project"
3. Project name: `ssm-student-hub`
4. Enable Google Analytics (optional)
5. Create the project

### 1.2 Register Android App
1. Go to Project Settings → Your Apps
2. Click "Add App" → Android
3. Package name: `com.ssm.student_hub`
4. App nickname: `SSM Student Hub Android`
5. Download `google-services.json`
6. Place it in `android/app/`

### 1.3 Register iOS App
1. Click "Add App" → iOS
2. Bundle ID: `com.ssm.student-hub`
3. App nickname: `SSM Student Hub iOS`
4. Download `GoogleService-Info.plist`
5. Place it in `ios/Runner/`

### 1.4 Enable Firebase Services
- ✅ Firestore Database
- ✅ Authentication (Email/Password)
- ✅ Storage (for PDFs and uploads)
- ✅ Cloud Messaging (for notifications)
- ✅ Cloud Functions (optional for backend logic)

## Step 2: Local Project Setup

### 2.1 Create Flutter Project
```bash
flutter create ssm_student_hub --org com.ssm --project-name student_hub
cd ssm_student_hub
```

### 2.2 Add Dependencies
Update `pubspec.yaml` with all required packages.

### 2.3 Configure Firebase
```bash
flutter pub add firebase_core
flutter pub add firebase_auth
flutter pub add cloud_firestore
flutter pub add firebase_storage
flutter pub add firebase_messaging

# Run Firebase setup
flutter pub run firebase_core:install_ios_pod
```

## Step 3: Firestore Database Setup

### 3.1 Create Collections
See `FIRESTORE_SCHEMA.md` for complete collection structure.

### 3.2 Security Rules
See `FIREBASE_SECURITY_RULES.txt` for role-based access control.

## Step 4: Authentication Setup
The authentication module is located in `lib/features/auth/`

## Step 5: Run the Application
```bash
flutter run
```

## Production Deployment

### Android
```bash
cd android
./gradlew bundleRelease
# Upload to Google Play Console
```

### iOS
```bash
cd ios
pod install
# Build and upload via Xcode or fastlane
```

## Folder Structure
```
ssm_student_hub/
├── android/
├── ios/
├── lib/
│   ├── config/
│   │   ├── firebase_config.dart
│   │   └── app_routes.dart
│   ├── core/
│   │   ├── errors/
│   │   ├── utils/
│   │   └── constants/
│   ├── features/
│   │   ├── auth/
│   │   ├── student/
│   │   ├── faculty/
│   │   ├── hod/
│   │   └── admin/
│   ├── models/
│   ├── services/
│   ├── repositories/
│   └── main.dart
├── test/
├── pubspec.yaml
└── README.md
```

## Important Notes
- Keep Firebase configuration files secure
- Never commit sensitive keys to Git
- Use environment variables for API keys
- Test on both Android and iOS
- Follow Flutter best practices
- Implement proper error handling
- Add comprehensive logging

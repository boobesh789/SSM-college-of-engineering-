# SSM Student Hub - Flutter ERP Application

## Overview

SSM Student Hub is a comprehensive Flutter + Firebase College ERP mobile application designed for student information management, attendance tracking, marks management, assignment submission, and real-time notifications.

## Features

### Authentication
- ✅ Firebase Email/Password Authentication
- ✅ Email Verification
- ✅ Password Reset
- ✅ Role-Based Access Control
- ✅ User Approval Workflow

### Student Features
- 📊 View Attendance
- 📈 View Assessment Marks (Assessment 1, 2, Internal)
- 📝 View Semester Results
- 📥 Submit Assignments
- ⏱️ CGPA Calculator
- 📅 View Timetable
- 🔔 Notifications

### Faculty Features
- ✍️ Mark Attendance
- 📊 Enter Marks
- 📋 Create Assessments
- 📝 Create Assignments
- 📤 Upload Study Materials
- 👀 View Assignment Submissions
- 📢 Send Notifications to Students

### HOD Features
- 👥 Manage Department Faculty
- 📚 Manage Department Subjects
- 📊 View Department Reports
- ✅ Approve Faculty Accounts

### Admin Features
- 👨‍💼 Manage All Users
- ✅ Approve Student & Faculty Registrations
- 📊 System Analytics
- 📢 Create College Announcements
- 📋 Audit Logs

## Project Structure

```
lib/
├── main.dart                          # Entry point
├── config/
│   ├── app_routes.dart               # Router configuration
│   └── firebase_config.dart          # Firebase setup
├── core/
│   ├── constants/
│   │   └── app_constants.dart       # App constants
│   ├── design/
│   │   └── design_tokens.dart       # Design tokens
│   ├── errors/
│   │   └── app_exceptions.dart      # Custom exceptions
│   ├── extensions/
│   │   ├── string_extensions.dart   # String utilities
│   │   └── date_extensions.dart     # Date utilities
│   ├── layout/
│   │   └── responsive_layout.dart   # Responsive UI
│   ├── theme/
│   │   └── app_theme.dart          # Theme configuration
│   ├── utils/
│   │   ├── logger.dart             # Logging
│   │   └── ui_utils.dart           # UI utilities
│   └── widgets/
│       └── common_widgets.dart      # Reusable widgets
├── models/
│   ├── user_model.dart              # User model
│   └── app_models.dart              # App models
├── features/
│   ├── auth/
│   │   ├── providers/
│   │   │   └── auth_provider.dart   # Auth providers
│   │   ├── screens/
│   │   │   ├── login_screen.dart
│   │   │   ├── registration_screen.dart
│   │   │   ├── email_verification_screen.dart
│   │   │   └── forgot_password_screen.dart
│   │   └── services/
│   │       └── auth_service.dart    # Auth service
│   ├── student/
│   │   ├── screens/
│   │   │   └── student_dashboard_screen.dart
│   │   └── providers/
│   │       └── student_provider.dart
│   ├── faculty/
│   │   ├── screens/
│   │   │   └── faculty_dashboard_screen.dart
│   │   └── providers/
│   │       └── faculty_provider.dart
│   ├── hod/
│   │   ├── screens/
│   │   │   └── hod_dashboard_screen.dart
│   │   └── providers/
│   │       └── hod_provider.dart
│   └── admin/
│       ├── screens/
│       │   └── admin_dashboard_screen.dart
│       └── providers/
│           └── admin_provider.dart
└── repositories/
    ├── user_repository.dart          # User data
    └── student_repository.dart       # Student data
```

## Tech Stack

- **Frontend**: Flutter 3.16+
- **State Management**: Riverpod
- **Backend**: Firebase
  - Authentication: Firebase Auth
  - Database: Firestore
  - Storage: Cloud Storage
  - Messaging: Cloud Messaging
- **UI Framework**: Material Design 3
- **Language**: Dart

## Dependencies

### Firebase
```yaml
firebase_core: ^2.24.0
firebase_auth: ^4.13.0
cloud_firestore: ^4.13.0
firebase_storage: ^11.5.0
firebase_messaging: ^14.7.0
```

### State Management
```yaml
riverpod: ^2.4.0
flutter_riverpod: ^2.4.0
riverpod_generator: ^2.3.0
```

### UI & Navigation
```yaml
go_router: ^12.0.0
flutter_animate: ^4.2.0
material_design_icons_flutter: ^7.0.0
```

### Data & Serialization
```yaml
json_serializable: ^6.7.0
json_annotation: ^4.8.1
frozen_annotation: ^2.4.0
```

## Setup Instructions

### Prerequisites
- Flutter SDK 3.16+
- Dart SDK
- Firebase account
- Android Studio or Xcode
- Git

### Step 1: Clone the Repository
```bash
git clone https://github.com/boobesh789/SSM-college-of-engineering-.git
cd SSM-college-of-engineering-/flutter_erp_app
```

### Step 2: Firebase Setup

1. Create a Firebase project at [https://console.firebase.google.com](https://console.firebase.google.com)
2. Project name: `ssm-student-hub`
3. Enable these services:
   - Authentication (Email/Password)
   - Firestore Database
   - Cloud Storage
   - Cloud Messaging

### Step 3: Register Android App

1. In Firebase Console → Project Settings → Your Apps → Add App → Android
2. Package name: `com.ssm.student_hub`
3. Download `google-services.json`
4. Place in `android/app/google-services.json`

### Step 4: Register iOS App

1. In Firebase Console → Project Settings → Your Apps → Add App → iOS
2. Bundle ID: `com.ssm.student-hub`
3. Download `GoogleService-Info.plist`
4. Add to Xcode: `ios/Runner/GoogleService-Info.plist`

### Step 5: Update Firebase Config

Update `lib/config/firebase_config.dart` with credentials from Firebase Console:

```dart
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'YOUR_API_KEY',
  appId: 'YOUR_APP_ID',
  messagingSenderId: 'YOUR_SENDER_ID',
  projectId: 'ssm-student-hub',
  storageBucket: 'ssm-student-hub.appspot.com',
);
```

### Step 6: Install Dependencies

```bash
flutter pub get
```

### Step 7: Deploy Firestore Rules

1. Copy contents from `firestore.rules`
2. In Firebase Console → Firestore → Rules
3. Paste and publish

### Step 8: Run the App

```bash
# Android
flutter run -d android

# iOS
flutter run -d ios
```

## Firestore Collections

- `users` - User accounts with roles
- `departments` - Department information
- `subjects` - Course/Subject information
- `attendance` - Attendance records
- `assessments` - Test/Assessment information
- `assignments` - Assignment details
- `results` - Semester results
- `timetable` - Class schedule
- `notifications` - User notifications
- `audit_logs` - System activity logs
- `college_announcements` - Admin announcements

## Security Rules

The application implements role-based access control:

- **Students**: Can only view their own attendance, marks, assignments, and results
- **Faculty**: Can manage attendance and marks for their assigned subjects
- **HOD**: Can manage faculty and subjects in their department
- **Admin**: Has full system access

## Testing

Test accounts for development:

```
# Student
Email: student@ssm.edu
Password: Student@123

# Faculty
Email: faculty@ssm.edu
Password: Faculty@123

# HOD
Email: hod@ssm.edu
Password: HOD@123

# Admin
Email: admin@ssm.edu
Password: Admin@123
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
# Build in Xcode or use fastlane
```

## Contributing

For college members only. Please follow Flutter best practices and maintain code quality.

## Documentation

- [Setup Instructions](SETUP_INSTRUCTIONS.md)
- [Firestore Schema](FIRESTORE_SCHEMA.md)
- [Firebase Security Rules](FIREBASE_SECURITY_RULES.txt)
- [Project Structure](PROJECT_STRUCTURE.md)

## Support

For issues or questions, please contact the development team.

## License

This project is for SSM College use only.

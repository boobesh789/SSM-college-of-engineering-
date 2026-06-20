# Project Structure Documentation

## Folder Organization

### Root Directory
```
flutter_erp_app/
├── android/                          # Android platform code
├── ios/                              # iOS platform code
├── lib/                              # Main Flutter code
│   ├── config/                       # Configuration files
│   │   ├── app_routes.dart          # Router configuration
│   │   └── firebase_config.dart     # Firebase setup
│   ├── core/                         # Core utilities
│   │   ├── constants/               # App constants
│   │   ├── errors/                  # Custom exceptions
│   │   ├── extensions/              # Dart extensions
│   │   ├── theme/                   # App theming
│   │   └── utils/                   # Utility functions
│   ├── features/                     # Feature modules
│   │   ├── auth/                    # Authentication
│   │   │   ├── providers/           # Riverpod providers
│   │   │   ├── screens/             # Auth UI screens
│   │   │   └── services/            # Auth services
│   │   ├── student/                 # Student features
│   │   │   ├── models/              # Data models
│   │   │   ├── providers/           # Riverpod providers
│   │   │   ├── repositories/        # Data repositories
│   │   │   ├── screens/             # UI screens
│   │   │   └── services/            # Business logic
│   │   ├── faculty/                 # Faculty features
│   │   │   └── screens/
│   │   ├── hod/                     # HOD features
│   │   │   └── screens/
│   │   └── admin/                   # Admin features
│   │       └── screens/
│   ├── models/                       # Shared data models
│   ├── repositories/                 # Shared repositories
│   ├── services/                     # Shared services
│   └── main.dart                     # Entry point
├── assets/                           # Static assets
│   ├── fonts/                        # Custom fonts
│   ├── images/                       # Images
│   ├── icons/                        # Custom icons
│   └── animations/                   # Animations
├── test/                             # Unit and widget tests
├── pubspec.yaml                      # Dependencies
├── .gitignore                        # Git ignore rules
├── SETUP_INSTRUCTIONS.md             # Setup guide
├── FIRESTORE_SCHEMA.md               # Database schema
└── FIREBASE_SECURITY_RULES.txt       # Security rules
```

## Feature Module Structure (Recommended Pattern)

Each feature module should follow this structure:

```
feature_name/
├── models/                          # Data classes
│   ├── feature_model.dart
│   └── feature_dto.dart
├── providers/                       # Riverpod providers
│   └── feature_provider.dart
├── repositories/                    # Data layer
│   └── feature_repository.dart
├── screens/                         # UI layer
│   ├── feature_screen.dart
│   └── feature_detail_screen.dart
├── services/                        # Business logic
│   └── feature_service.dart
└── widgets/                         # Reusable widgets
    └── feature_widget.dart
```

## Architecture Pattern

### Clean Architecture with Riverpod

1. **Presentation Layer** (UI)
   - Screens
   - Widgets
   - State management with Riverpod

2. **Domain Layer** (Business Logic)
   - Models
   - Services
   - Repositories

3. **Data Layer** (Backend)
   - Firebase services
   - Firestore operations
   - Remote data sources

## Current Implementation Status

### ✅ Completed
- [x] Authentication Module (Complete)
- [x] Dashboard Screens (All 4 roles)
- [x] Project structure
- [x] Firebase configuration
- [x] Riverpod providers setup
- [x] Security rules

### 🔄 In Progress / TODO
- [ ] Student Features
  - [ ] Attendance screen
  - [ ] Marks viewing
  - [ ] Assignment management
  - [ ] Results dashboard
  - [ ] CGPA calculator

- [ ] Faculty Features
  - [ ] Mark attendance
  - [ ] Enter marks
  - [ ] Create assignments
  - [ ] Upload materials
  - [ ] View submissions

- [ ] HOD Features
  - [ ] Manage faculty
  - [ ] Manage subjects
  - [ ] View reports
  - [ ] Faculty approvals

- [ ] Admin Features
  - [ ] User management
  - [ ] Registration approvals
  - [ ] System analytics
  - [ ] Audit logs

## File Naming Conventions

- **Screens**: `*_screen.dart` (e.g., `login_screen.dart`)
- **Models**: `*_model.dart` (e.g., `user_model.dart`)
- **Providers**: `*_provider.dart` (e.g., `auth_provider.dart`)
- **Repositories**: `*_repository.dart` (e.g., `user_repository.dart`)
- **Services**: `*_service.dart` (e.g., `auth_service.dart`)
- **Widgets**: `*_widget.dart` or descriptive name (e.g., `custom_button.dart`)
- **Utilities**: `*_utils.dart` (e.g., `date_utils.dart`)

## Dependency Injection

All services and repositories are provided via Riverpod providers:

```dart
final authServiceProvider = Provider((ref) => AuthService());
final userRepositoryProvider = Provider((ref) => UserRepository());
```

## State Management with Riverpod

### Provider Types Used
- **Provider**: For simple values (services, repositories)
- **FutureProvider**: For async operations (fetching data)
- **StreamProvider**: For real-time updates (auth state, notifications)
- **StateNotifierProvider**: For complex state management

## Testing Structure

```
test/
├── features/
│   ├── auth/
│   │   ├── auth_service_test.dart
│   │   └── auth_provider_test.dart
│   └── student/
│       └── student_provider_test.dart
└── core/
    └── extensions/
        └── string_extensions_test.dart
```

## Best Practices Implemented

1. ✅ Separation of concerns
2. ✅ DRY (Don't Repeat Yourself)
3. ✅ Single Responsibility Principle
4. ✅ Dependency Injection via Riverpod
5. ✅ Error handling with custom exceptions
6. ✅ Logging for debugging
7. ✅ Role-based access control
8. ✅ Data validation
9. ✅ Material Design 3 compliance
10. ✅ Responsive layouts

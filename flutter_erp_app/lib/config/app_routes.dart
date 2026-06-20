import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/registration_screen.dart';
import '../features/auth/screens/email_verification_screen.dart';
import '../features/auth/screens/forgot_password_screen.dart';
import '../features/student/screens/student_dashboard_screen.dart';
import '../features/faculty/screens/faculty_dashboard_screen.dart';
import '../features/hod/screens/hod_dashboard_screen.dart';
import '../features/admin/screens/admin_dashboard_screen.dart';
import '../features/auth/providers/auth_provider.dart';
import '../core/constants/app_constants.dart';

// Routes
class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String registration = '/registration';
  static const String emailVerification = '/email-verification';
  static const String forgotPassword = '/forgot-password';
  static const String studentDashboard = '/student-dashboard';
  static const String facultyDashboard = '/faculty-dashboard';
  static const String hodDashboard = '/hod-dashboard';
  static const String adminDashboard = '/admin-dashboard';
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: AppRoutes.login,
    redirect: (context, state) {
      // Handle authentication redirect logic
      final isLoggingIn = state.matchedLocation == AppRoutes.login ||
          state.matchedLocation == AppRoutes.registration ||
          state.matchedLocation == AppRoutes.emailVerification ||
          state.matchedLocation == AppRoutes.forgotPassword;

      // If user is authenticated
      if (authState.hasValue && authState.value != null) {
        // Redirect to appropriate dashboard based on role
        if (isLoggingIn) {
          return _getDashboardRoute(authState.value!.role);
        }
      } else if (authState.hasError || authState.isLoading) {
        // During loading or error, stay on current page
        return null;
      } else {
        // Not authenticated, redirect to login
        if (!isLoggingIn) {
          return AppRoutes.login;
        }
      }
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.registration,
        builder: (context, state) => const RegistrationScreen(),
      ),
      GoRoute(
        path: AppRoutes.emailVerification,
        builder: (context, state) => const EmailVerificationScreen(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.studentDashboard,
        builder: (context, state) => const StudentDashboardScreen(),
      ),
      GoRoute(
        path: AppRoutes.facultyDashboard,
        builder: (context, state) => const FacultyDashboardScreen(),
      ),
      GoRoute(
        path: AppRoutes.hodDashboard,
        builder: (context, state) => const HodDashboardScreen(),
      ),
      GoRoute(
        path: AppRoutes.adminDashboard,
        builder: (context, state) => const AdminDashboardScreen(),
      ),
    ],
  );
});

/// Get dashboard route based on user role
String _getDashboardRoute(String role) {
  switch (role) {
    case UserRole.admin:
      return AppRoutes.adminDashboard;
    case UserRole.hod:
      return AppRoutes.hodDashboard;
    case UserRole.faculty:
      return AppRoutes.facultyDashboard;
    case UserRole.student:
      return AppRoutes.studentDashboard;
    default:
      return AppRoutes.login;
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';
import '../repositories/user_repository.dart';
import '../models/user_model.dart';
import '../core/utils/logger.dart';

// Service Providers
final authServiceProvider = Provider((ref) => AuthService());

final userRepositoryProvider = Provider((ref) => UserRepository());

// Auth State Provider - Stream of current user from Firebase
final authStateProvider = StreamProvider<UserModel?>((ref) async* {
  final authService = ref.watch(authServiceProvider);
  final userRepository = ref.watch(userRepositoryProvider);

  await for (final user in authService.authStateChanges) {
    if (user != null) {
      try {
        final userModel = await userRepository.getUserByUid(user.uid);
        yield userModel;
      } catch (e) {
        AppLogger.error('Error fetching user model in authStateProvider', e);
        yield null;
      }
    } else {
      yield null;
    }
  }
});

// Current user UID Provider
final currentUserUidProvider = Provider<String?>((ref) {
  return ref.watch(authServiceProvider).currentUserUid;
});

// Current user model Provider
final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  final authState = ref.watch(authStateProvider);
  return authState.whenData((user) => user);
});

// User role provider - easy access to current user role
final currentUserRoleProvider = Provider<String?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.whenData((user) => user?.role).value;
});

// User department provider - easy access to current user department
final currentUserDepartmentProvider = Provider<String?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.whenData((user) => user?.department).value;
});

// Login Provider
final loginProvider = FutureProvider.family<UserModel, Map<String, String>>((ref, params) async {
  final authService = ref.watch(authServiceProvider);
  return authService.loginUser(
    email: params['email']!,
    password: params['password']!,
  );
});

// Registration Provider
final registrationProvider =
    FutureProvider.family<UserModel, Map<String, String>>((ref, params) async {
  final authService = ref.watch(authServiceProvider);
  return authService.registerUser(
    email: params['email']!,
    password: params['password']!,
    fullName: params['fullName']!,
    role: params['role']!,
    department: params['department']!,
    registrationNumber: params['registrationNumber'],
    employeeId: params['employeeId'],
    phoneNumber: params['phoneNumber'],
  );
});

// Email verification provider
final emailVerificationProvider = FutureProvider<bool>((ref) async {
  final authService = ref.watch(authServiceProvider);
  return authService.checkEmailVerification();
});

// Resend email verification provider
final resendEmailVerificationProvider = FutureProvider<void>((ref) async {
  final authService = ref.watch(authServiceProvider);
  return authService.resendEmailVerification();
});

// Password reset provider
final passwordResetProvider = FutureProvider.family<void, String>((ref, email) async {
  final authService = ref.watch(authServiceProvider);
  return authService.sendPasswordResetEmail(email);
});

// Get all users provider (admin only)
final allUsersProvider = FutureProvider<List<UserModel>>((ref) async {
  final userRepository = ref.watch(userRepositoryProvider);
  return userRepository.getAllUsers();
});

// Get users by role provider
final usersByRoleProvider = FutureProvider.family<List<UserModel>, String>((ref, role) async {
  final userRepository = ref.watch(userRepositoryProvider);
  return userRepository.getUsersByRole(role);
});

// Get users by department provider
final usersByDepartmentProvider =
    FutureProvider.family<List<UserModel>, String>((ref, department) async {
  final userRepository = ref.watch(userRepositoryProvider);
  return userRepository.getUsersByDepartment(department);
});

// Pending approvals provider (admin only)
final pendingApprovalsProvider = FutureProvider<List<UserModel>>((ref) async {
  final userRepository = ref.watch(userRepositoryProvider);
  return userRepository.getPendingApprovals();
});

// Get specific user provider
final userProvider = FutureProvider.family<UserModel, String>((ref, uid) async {
  final userRepository = ref.watch(userRepositoryProvider);
  return userRepository.getUserByUid(uid);
});

// Logout provider
final logoutProvider = FutureProvider<void>((ref) async {
  final authService = ref.watch(authServiceProvider);
  return authService.logout();
});

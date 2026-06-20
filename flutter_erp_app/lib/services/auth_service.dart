import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../core/errors/app_exceptions.dart';
import '../core/utils/logger.dart';
import '../core/constants/app_constants.dart';

/// Firebase Authentication Service
/// Handles all authentication operations including login, registration, email verification, etc.
class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get current user
  User? get currentUser => _firebaseAuth.currentUser;

  /// Check if user is authenticated
  bool get isAuthenticated => _firebaseAuth.currentUser != null;

  /// Get current user UID
  String? get currentUserUid => _firebaseAuth.currentUser?.uid;

  /// Stream of authentication state
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  /// Register user with email and password
  /// Returns UserModel if successful
  Future<UserModel> registerUser({
    required String email,
    required String password,
    required String fullName,
    required String role,
    required String department,
    String? registrationNumber,
    String? employeeId,
    String? phoneNumber,
  }) async {
    try {
      AppLogger.info('Attempting to register user: $email');

      // Validate inputs
      if (email.isEmpty || password.isEmpty || fullName.isEmpty) {
        throw ValidationException(
          message: ErrorMessages.invalidEmailError,
        );
      }

      // Create user account
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw AuthException(
          message: 'Failed to create user account',
        );
      }

      // Create user document in Firestore
      final newUser = UserModel(
        uid: user.uid,
        email: email,
        fullName: fullName,
        role: role,
        department: department,
        registrationNumber: registrationNumber,
        employeeId: employeeId,
        phoneNumber: phoneNumber,
        isEmailVerified: false,
        isApproved: false, // Needs admin approval
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _firestore
          .collection(FirestoreCollections.users)
          .doc(user.uid)
          .set(newUser.toFirestore());

      // Send email verification
      await _sendEmailVerification();

      AppLogger.info('User registered successfully: $email');
      return newUser;
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Firebase Auth Error: ${e.code}', e);
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      AppLogger.error('Registration error', e);
      rethrow;
    }
  }

  /// Login user with email and password
  Future<UserModel> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      AppLogger.info('Attempting to login user: $email');

      // Sign in with email and password
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw AuthException(
          message: 'Login failed. Please try again.',
        );
      }

      // Check if email is verified
      await user.reload();
      if (!user.emailVerified) {
        throw AuthException(
          message: ErrorMessages.emailNotVerifiedError,
        );
      }

      // Get user data from Firestore
      final userDoc = await _firestore
          .collection(FirestoreCollections.users)
          .doc(user.uid)
          .get();

      if (!userDoc.exists) {
        throw AuthException(
          message: 'User data not found',
        );
      }

      final userData = userDoc.data() as Map<String, dynamic>;

      // Check if user is approved
      if (userData['isApproved'] != true) {
        throw AuthException(
          message: ErrorMessages.userNotApprovedError,
        );
      }

      AppLogger.info('User logged in successfully: $email');
      return UserModel.fromFirestore(userData, user.uid);
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Firebase Auth Error: ${e.code}', e);
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      AppLogger.error('Login error', e);
      rethrow;
    }
  }

  /// Send email verification link
  Future<void> _sendEmailVerification() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        AppLogger.info('Email verification sent to: ${user.email}');
      }
    } catch (e) {
      AppLogger.error('Failed to send email verification', e);
      rethrow;
    }
  }

  /// Check email verification status and update
  Future<bool> checkEmailVerification() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        await user.reload();
        final isVerified = user.emailVerified;

        // Update Firestore if verified
        if (isVerified) {
          await _firestore
              .collection(FirestoreCollections.users)
              .doc(user.uid)
              .update({'isEmailVerified': true});
          AppLogger.info('Email verified for user: ${user.email}');
        }

        return isVerified;
      }
      return false;
    } catch (e) {
      AppLogger.error('Error checking email verification', e);
      rethrow;
    }
  }

  /// Resend email verification link
  Future<void> resendEmailVerification() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        AppLogger.info('Email verification resent to: ${user.email}');
      }
    } catch (e) {
      AppLogger.error('Failed to resend email verification', e);
      rethrow;
    }
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      AppLogger.info('Sending password reset email to: $email');
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      AppLogger.info('Password reset email sent successfully');
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Firebase Auth Error: ${e.code}', e);
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      AppLogger.error('Error sending password reset email', e);
      rethrow;
    }
  }

  /// Update user password
  Future<void> updatePassword(String newPassword) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        await user.updatePassword(newPassword);
        AppLogger.info('Password updated successfully');
      }
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Firebase Auth Error: ${e.code}', e);
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      AppLogger.error('Error updating password', e);
      rethrow;
    }
  }

  /// Get user model from Firestore
  Future<UserModel> getUserModel(String uid) async {
    try {
      final userDoc = await _firestore
          .collection(FirestoreCollections.users)
          .doc(uid)
          .get();

      if (!userDoc.exists) {
        throw AuthException(
          message: 'User data not found',
        );
      }

      return UserModel.fromFirestore(
        userDoc.data() as Map<String, dynamic>,
        uid,
      );
    } catch (e) {
      AppLogger.error('Error fetching user model', e);
      rethrow;
    }
  }

  /// Update user profile
  Future<void> updateUserProfile({
    required String uid,
    String? fullName,
    String? phoneNumber,
    String? profileImageUrl,
  }) async {
    try {
      final updateData = <String, dynamic>{};
      if (fullName != null) updateData['fullName'] = fullName;
      if (phoneNumber != null) updateData['phoneNumber'] = phoneNumber;
      if (profileImageUrl != null) updateData['profileImageUrl'] = profileImageUrl;
      updateData['updatedAt'] = DateTime.now();

      await _firestore
          .collection(FirestoreCollections.users)
          .doc(uid)
          .update(updateData);

      AppLogger.info('User profile updated: $uid');
    } catch (e) {
      AppLogger.error('Error updating user profile', e);
      rethrow;
    }
  }

  /// Update FCM token for push notifications
  Future<void> updateFcmToken(String token) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        await _firestore
            .collection(FirestoreCollections.users)
            .doc(user.uid)
            .update({'fcmToken': token});
        AppLogger.info('FCM token updated for user: ${user.uid}');
      }
    } catch (e) {
      AppLogger.error('Error updating FCM token', e);
      rethrow;
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      AppLogger.info('User logging out');
      await _firebaseAuth.signOut();
      AppLogger.info('User logged out successfully');
    } catch (e) {
      AppLogger.error('Error during logout', e);
      rethrow;
    }
  }

  /// Handle Firebase Authentication Exceptions
  AuthException _handleFirebaseAuthException(FirebaseAuthException e) {
    String message = 'An error occurred';
    String? code = e.code;

    switch (e.code) {
      case 'user-not-found':
        message = 'No user found with this email';
        break;
      case 'wrong-password':
        message = 'Invalid password';
        break;
      case 'invalid-email':
        message = ErrorMessages.invalidEmailError;
        break;
      case 'user-disabled':
        message = 'This user account has been disabled';
        break;
      case 'too-many-requests':
        message = 'Too many login attempts. Please try again later';
        break;
      case 'operation-not-allowed':
        message = 'This operation is not allowed';
        break;
      case 'email-already-in-use':
        message = ErrorMessages.emailAlreadyUsedError;
        break;
      case 'weak-password':
        message = 'Password is too weak. Please use a stronger password';
        break;
      case 'invalid-credential':
        message = 'Invalid email or password';
        break;
      default:
        message = e.message ?? 'Authentication failed';
    }

    return AuthException(
      message: message,
      code: code,
      originalError: e,
    );
  }
}

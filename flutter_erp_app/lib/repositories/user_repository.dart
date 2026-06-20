import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../core/errors/app_exceptions.dart';
import '../core/utils/logger.dart';
import '../core/constants/app_constants.dart';

/// User Repository for handling user data operations
class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get user data by UID
  Future<UserModel> getUserByUid(String uid) async {
    try {
      final doc = await _firestore
          .collection(FirestoreCollections.users)
          .doc(uid)
          .get();

      if (!doc.exists) {
        throw DatabaseException(
          message: 'User not found',
        );
      }

      return UserModel.fromFirestore(
        doc.data() as Map<String, dynamic>,
        uid,
      );
    } catch (e) {
      AppLogger.error('Error fetching user', e);
      rethrow;
    }
  }

  /// Create user document
  Future<void> createUser(String uid, UserModel user) async {
    try {
      await _firestore
          .collection(FirestoreCollections.users)
          .doc(uid)
          .set(user.toFirestore());
      AppLogger.info('User document created: $uid');
    } catch (e) {
      AppLogger.error('Error creating user document', e);
      rethrow;
    }
  }

  /// Update user document
  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    try {
      data['updatedAt'] = DateTime.now();
      await _firestore
          .collection(FirestoreCollections.users)
          .doc(uid)
          .update(data);
      AppLogger.info('User document updated: $uid');
    } catch (e) {
      AppLogger.error('Error updating user document', e);
      rethrow;
    }
  }

  /// Get all users (admin only)
  Future<List<UserModel>> getAllUsers() async {
    try {
      final snapshot = await _firestore
          .collection(FirestoreCollections.users)
          .get();

      return snapshot.docs
          .map((doc) => UserModel.fromFirestore(
                doc.data(),
                doc.id,
              ))
          .toList();
    } catch (e) {
      AppLogger.error('Error fetching all users', e);
      rethrow;
    }
  }

  /// Get users by role
  Future<List<UserModel>> getUsersByRole(String role) async {
    try {
      final snapshot = await _firestore
          .collection(FirestoreCollections.users)
          .where('role', isEqualTo: role)
          .get();

      return snapshot.docs
          .map((doc) => UserModel.fromFirestore(
                doc.data(),
                doc.id,
              ))
          .toList();
    } catch (e) {
      AppLogger.error('Error fetching users by role', e);
      rethrow;
    }
  }

  /// Get users by department
  Future<List<UserModel>> getUsersByDepartment(String department) async {
    try {
      final snapshot = await _firestore
          .collection(FirestoreCollections.users)
          .where('department', isEqualTo: department)
          .get();

      return snapshot.docs
          .map((doc) => UserModel.fromFirestore(
                doc.data(),
                doc.id,
              ))
          .toList();
    } catch (e) {
      AppLogger.error('Error fetching users by department', e);
      rethrow;
    }
  }

  /// Get pending user approvals (admin only)
  Future<List<UserModel>> getPendingApprovals() async {
    try {
      final snapshot = await _firestore
          .collection(FirestoreCollections.users)
          .where('isApproved', isEqualTo: false)
          .get();

      return snapshot.docs
          .map((doc) => UserModel.fromFirestore(
                doc.data(),
                doc.id,
              ))
          .toList();
    } catch (e) {
      AppLogger.error('Error fetching pending approvals', e);
      rethrow;
    }
  }

  /// Approve user (admin only)
  Future<void> approveUser(String uid) async {
    try {
      await _firestore
          .collection(FirestoreCollections.users)
          .doc(uid)
          .update({
        'isApproved': true,
        'updatedAt': DateTime.now(),
      });
      AppLogger.info('User approved: $uid');
    } catch (e) {
      AppLogger.error('Error approving user', e);
      rethrow;
    }
  }

  /// Reject user (admin only)
  Future<void> rejectUser(String uid) async {
    try {
      await _firestore
          .collection(FirestoreCollections.users)
          .doc(uid)
          .delete();
      AppLogger.info('User rejected: $uid');
    } catch (e) {
      AppLogger.error('Error rejecting user', e);
      rethrow;
    }
  }
}

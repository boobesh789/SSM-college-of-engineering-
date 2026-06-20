import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// User model representing a user in the system
@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String uid,
    required String email,
    required String fullName,
    required String role, // admin, hod, faculty, student
    required String department, // ECE, CSE, IT, EEE, Mechanical, Civil
    String? registrationNumber, // For students
    String? employeeId, // For faculty/hod
    String? phoneNumber,
    String? profileImageUrl,
    required bool isEmailVerified,
    required bool isApproved,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? fcmToken,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  factory UserModel.fromFirestore(Map<String, dynamic> data, String uid) {
    return UserModel(
      uid: uid,
      email: data['email'] ?? '',
      fullName: data['fullName'] ?? '',
      role: data['role'] ?? '',
      department: data['department'] ?? '',
      registrationNumber: data['registrationNumber'],
      employeeId: data['employeeId'],
      phoneNumber: data['phoneNumber'],
      profileImageUrl: data['profileImageUrl'],
      isEmailVerified: data['isEmailVerified'] ?? false,
      isApproved: data['isApproved'] ?? false,
      createdAt: (data['createdAt'] as dynamic)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as dynamic)?.toDate() ?? DateTime.now(),
      fcmToken: data['fcmToken'],
    );
  }

  Map<String, dynamic> toFirestore() => {
        'email': email,
        'fullName': fullName,
        'role': role,
        'department': department,
        'registrationNumber': registrationNumber,
        'employeeId': employeeId,
        'phoneNumber': phoneNumber,
        'profileImageUrl': profileImageUrl,
        'isEmailVerified': isEmailVerified,
        'isApproved': isApproved,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'fcmToken': fcmToken,
      };
}

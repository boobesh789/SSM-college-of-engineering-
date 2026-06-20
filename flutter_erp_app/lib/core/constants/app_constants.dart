/// User Roles
class UserRole {
  static const String admin = 'admin';
  static const String hod = 'hod';
  static const String faculty = 'faculty';
  static const String student = 'student';

  static const List<String> allRoles = [admin, hod, faculty, student];
}

/// Departments
class Departments {
  static const String ece = 'ECE';
  static const String cse = 'CSE';
  static const String it = 'IT';
  static const String eee = 'EEE';
  static const String mechanical = 'Mechanical';
  static const String civil = 'Civil';

  static const List<String> allDepartments = [
    ece,
    cse,
    it,
    eee,
    mechanical,
    civil,
  ];
}

/// Firestore Collections
class FirestoreCollections {
  static const String users = 'users';
  static const String departments = 'departments';
  static const String subjects = 'subjects';
  static const String attendance = 'attendance';
  static const String assessments = 'assessments';
  static const String assignments = 'assignments';
  static const String results = 'results';
  static const String timetable = 'timetable';
  static const String notifications = 'notifications';
  static const String auditLogs = 'audit_logs';
  static const String collegeAnnouncements = 'college_announcements';
}

/// Error Messages
class ErrorMessages {
  static const String networkError = 'Network error. Please check your connection.';
  static const String unauthorizedError = 'Unauthorized access. Please login again.';
  static const String notFoundError = 'Resource not found.';
  static const String serverError = 'Server error. Please try again later.';
  static const String invalidEmailError = 'Please enter a valid email address.';
  static const String invalidPasswordError = 'Password must be at least 8 characters.';
  static const String passwordMismatchError = 'Passwords do not match.';
  static const String emailAlreadyUsedError = 'This email is already registered.';
  static const String userNotApprovedError = 'Your account is not yet approved by admin.';
  static const String emailNotVerifiedError = 'Please verify your email before login.';
}

/// Success Messages
class SuccessMessages {
  static const String registrationSuccess = 'Registration successful! Check your email for verification.';
  static const String emailVerificationSent = 'Verification email sent. Check your inbox.';
  static const String passwordResetSent = 'Password reset link sent to your email.';
  static const String passwordChangedSuccess = 'Password changed successfully!';
  static const String profileUpdatedSuccess = 'Profile updated successfully!';
}

/// Validation Constants
class ValidationConstants {
  static const int minPasswordLength = 8;
  static const int maxNameLength = 100;
  static const int maxEmailLength = 255;
  static const int minPhoneLength = 10;
  static const int maxPhoneLength = 15;
}

/// Attendance Status
class AttendanceStatus {
  static const String present = 'present';
  static const String absent = 'absent';
  static const String leave = 'leave';

  static const List<String> allStatuses = [present, absent, leave];
}

/// Assessment Types
class AssessmentTypes {
  static const String assessment1 = 'Assessment1';
  static const String assessment2 = 'Assessment2';
  static const String quiz = 'Quiz';
  static const String midterm = 'Midterm';
  static const String endterm = 'Endterm';

  static const List<String> allTypes = [assessment1, assessment2, quiz, midterm, endterm];
}

/// Grade Points
class GradePoints {
  static const double gradeA = 10.0;
  static const double gradeB = 8.0;
  static const double gradeC = 6.0;
  static const double gradeD = 4.0;
  static const double gradeF = 0.0;
}

/// API Endpoints
class ApiEndpoints {
  static const String baseUrl = 'https://firestore.googleapis.com/v1';
  static const String projectId = 'ssm-student-hub';
}

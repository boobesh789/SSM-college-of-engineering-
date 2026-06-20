import 'package:flutter/material.dart';

/// Response model for handling API responses
class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;
  final dynamic error;

  ApiResponse({
    required this.success,
    this.message,
    this.data,
    this.error,
  });

  factory ApiResponse.success(T data, {String? message}) {
    return ApiResponse(
      success: true,
      message: message,
      data: data,
    );
  }

  factory ApiResponse.error(String message, {dynamic error}) {
    return ApiResponse(
      success: false,
      message: message,
      error: error,
    );
  }
}

/// Loading state
class LoadingState {
  final bool isLoading;
  final String? message;

  LoadingState({this.isLoading = false, this.message});
}

/// Authentication state
class AuthState {
  final bool isAuthenticated;
  final String? userId;
  final String? userRole;
  final String? userDepartment;

  AuthState({
    required this.isAuthenticated,
    this.userId,
    this.userRole,
    this.userDepartment,
  });

  factory AuthState.unauthenticated() {
    return AuthState(isAuthenticated: false);
  }

  factory AuthState.authenticated({
    required String userId,
    required String userRole,
    required String userDepartment,
  }) {
    return AuthState(
      isAuthenticated: true,
      userId: userId,
      userRole: userRole,
      userDepartment: userDepartment,
    );
  }
}

/// Attendance record model
class AttendanceRecord {
  final String id;
  final String subjectId;
  final String studentId;
  final String date;
  final String status; // present, absent, leave
  final String? remarks;

  AttendanceRecord({
    required this.id,
    required this.subjectId,
    required this.studentId,
    required this.date,
    required this.status,
    this.remarks,
  });
}

/// Marks record model
class MarksRecord {
  final String id;
  final String studentId;
  final String subjectId;
  final String assessmentType; // Assessment1, Assessment2, etc.
  final double marksObtained;
  final double totalMarks;
  final double percentage;
  final String? remarks;

  MarksRecord({
    required this.id,
    required this.studentId,
    required this.subjectId,
    required this.assessmentType,
    required this.marksObtained,
    required this.totalMarks,
    required this.percentage,
    this.remarks,
  });

  double get gradePoint {
    if (percentage >= 90) return 10.0;
    if (percentage >= 80) return 9.0;
    if (percentage >= 70) return 8.0;
    if (percentage >= 60) return 7.0;
    if (percentage >= 50) return 6.0;
    return 0.0;
  }

  String get grade {
    if (percentage >= 90) return 'A';
    if (percentage >= 80) return 'B';
    if (percentage >= 70) return 'C';
    if (percentage >= 60) return 'D';
    if (percentage >= 50) return 'E';
    return 'F';
  }
}

/// Assignment model
class Assignment {
  final String id;
  final String subjectId;
  final String title;
  final String description;
  final DateTime dueDate;
  final double totalMarks;
  final String? submissionUrl;
  final DateTime? submittedAt;
  final bool isSubmitted;
  final double? obtainedMarks;
  final String? feedback;

  Assignment({
    required this.id,
    required this.subjectId,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.totalMarks,
    this.submissionUrl,
    this.submittedAt,
    required this.isSubmitted,
    this.obtainedMarks,
    this.feedback,
  });

  bool get isOverdue => DateTime.now().isAfter(dueDate) && !isSubmitted;

  int get daysRemaining {
    final now = DateTime.now();
    if (now.isAfter(dueDate)) return 0;
    return dueDate.difference(now).inDays;
  }
}

/// Subject model
class Subject {
  final String id;
  final String code;
  final String name;
  final String facultyId;
  final String department;
  final int semester;
  final int creditHours;
  final String? syllabus;

  Subject({
    required this.id,
    required this.code,
    required this.name,
    required this.facultyId,
    required this.department,
    required this.semester,
    required this.creditHours,
    this.syllabus,
  });
}

/// Result model
class Result {
  final String id;
  final String studentId;
  final int semester;
  final String academicYear;
  final List<SubjectResult> subjects;
  final double cgpa;
  final double gpa;
  final int totalCredits;
  final int earnedCredits;
  final DateTime publishedAt;

  Result({
    required this.id,
    required this.studentId,
    required this.semester,
    required this.academicYear,
    required this.subjects,
    required this.cgpa,
    required this.gpa,
    required this.totalCredits,
    required this.earnedCredits,
    required this.publishedAt,
  });
}

/// Subject result within a Result
class SubjectResult {
  final String subjectId;
  final String code;
  final String name;
  final int creditHours;
  final double internalMarks;
  final double externalMarks;
  final double totalMarks;
  final double gradePoint;
  final String grade;

  SubjectResult({
    required this.subjectId,
    required this.code,
    required this.name,
    required this.creditHours,
    required this.internalMarks,
    required this.externalMarks,
    required this.totalMarks,
    required this.gradePoint,
    required this.grade,
  });
}

/// Notification model
class AppNotification {
  final String id;
  final String userId;
  final String title;
  final String message;
  final String type; // announcement, assignment, result, attendance, etc.
  final String? relatedId;
  final DateTime createdAt;
  final bool isRead;

  AppNotification({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.type,
    this.relatedId,
    required this.createdAt,
    required this.isRead,
  });
}

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/app_models.dart';
import '../errors/app_exceptions.dart';

class AttendanceRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get attendance records for a student
  Future<List<AttendanceRecord>> getStudentAttendance({
    required String studentId,
    required String subjectId,
  }) async {
    try {
      final snapshot = await _firestore
          .collection('attendance')
          .doc(subjectId)
          .collection('records')
          .orderBy('date', descending: true)
          .get();

      final records = <AttendanceRecord>[];
      for (var doc in snapshot.docs) {
        final studentDoc = await doc.reference.collection('students').doc(studentId).get();
        if (studentDoc.exists) {
          records.add(
            AttendanceRecord(
              id: studentDoc.id,
              subjectId: subjectId,
              studentId: studentId,
              date: doc.id,
              status: studentDoc['status'] ?? 'absent',
              remarks: studentDoc['remarks'],
            ),
          );
        }
      }
      return records;
    } catch (e) {
      throw DatabaseException(message: 'Failed to fetch attendance records', originalError: e);
    }
  }

  /// Get attendance percentage for a subject
  Future<double> getAttendancePercentage({
    required String studentId,
    required String subjectId,
  }) async {
    try {
      final records = await getStudentAttendance(
        studentId: studentId,
        subjectId: subjectId,
      );

      if (records.isEmpty) return 0.0;

      final presentCount = records.where((r) => r.status == 'present').length;
      return (presentCount / records.length) * 100;
    } catch (e) {
      throw DatabaseException(message: 'Failed to calculate attendance percentage', originalError: e);
    }
  }
}

class MarksRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get marks for a student in a subject
  Future<List<MarksRecord>> getStudentMarks({
    required String studentId,
    required String subjectId,
  }) async {
    try {
      final snapshot = await _firestore
          .collection('assessments')
          .where('subjectId', isEqualTo: subjectId)
          .get();

      final marks = <MarksRecord>[];
      for (var doc in snapshot.docs) {
        final marksDoc = await doc.reference
            .collection('marks')
            .doc(studentId)
            .get();

        if (marksDoc.exists) {
          final marksData = marksDoc.data() as Map<String, dynamic>;
          marks.add(
            MarksRecord(
              id: marksDoc.id,
              studentId: studentId,
              subjectId: subjectId,
              assessmentType: doc['type'] ?? 'Unknown',
              marksObtained: (marksData['marksObtained'] ?? 0).toDouble(),
              totalMarks: (doc['totalMarks'] ?? 0).toDouble(),
              percentage: (marksData['percentage'] ?? 0).toDouble(),
              remarks: marksData['remarks'],
            ),
          );
        }
      }
      return marks;
    } catch (e) {
      throw DatabaseException(message: 'Failed to fetch marks', originalError: e);
    }
  }

  /// Get average marks for a student in a subject
  Future<double> getAverageMarks({
    required String studentId,
    required String subjectId,
  }) async {
    try {
      final marks = await getStudentMarks(
        studentId: studentId,
        subjectId: subjectId,
      );

      if (marks.isEmpty) return 0.0;

      final totalPercentage = marks.fold<double>(0.0, (sum, m) => sum + m.percentage);
      return totalPercentage / marks.length;
    } catch (e) {
      throw DatabaseException(message: 'Failed to calculate average marks', originalError: e);
    }
  }
}

class AssignmentRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get assignments for a student
  Future<List<Assignment>> getStudentAssignments({
    required String studentId,
    required String subjectId,
  }) async {
    try {
      final snapshot = await _firestore
          .collection('assignments')
          .where('subjectId', isEqualTo: subjectId)
          .orderBy('dueDate', descending: true)
          .get();

      final assignments = <Assignment>[];
      for (var doc in snapshot.docs) {
        final assignmentData = doc.data();
        final submissionsSnapshot = await doc.reference
            .collection('submissions')
            .where('studentId', isEqualTo: studentId)
            .get();

        bool isSubmitted = submissionsSnapshot.docs.isNotEmpty;
        DateTime? submittedAt;
        double? obtainedMarks;
        String? feedback;

        if (isSubmitted) {
          final submissionData = submissionsSnapshot.docs.first.data();
          submittedAt = (submissionData['submittedAt'] as Timestamp?)?.toDate();
          obtainedMarks = (submissionData['marksObtained'] as num?)?.toDouble();
          feedback = submissionData['feedback'];
        }

        assignments.add(
          Assignment(
            id: doc.id,
            subjectId: subjectId,
            title: assignmentData['title'] ?? 'Assignment',
            description: assignmentData['description'] ?? '',
            dueDate: (assignmentData['dueDate'] as Timestamp).toDate(),
            totalMarks: (assignmentData['totalMarks'] ?? 0).toDouble(),
            submissionUrl: isSubmitted ? submissionsSnapshot.docs.first['fileUrl'] : null,
            submittedAt: submittedAt,
            isSubmitted: isSubmitted,
            obtainedMarks: obtainedMarks,
            feedback: feedback,
          ),
        );
      }
      return assignments;
    } catch (e) {
      throw DatabaseException(message: 'Failed to fetch assignments', originalError: e);
    }
  }
}

class ResultRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get results for a student
  Future<List<Result>> getStudentResults(String studentId) async {
    try {
      final snapshot = await _firestore
          .collection('results')
          .where('studentId', isEqualTo: studentId)
          .orderBy('semester', descending: true)
          .get();

      final results = <Result>[];
      for (var doc in snapshot.docs) {
        final resultData = doc.data();
        final subjectsList = (resultData['subjects'] as List?)??
            [];

        final subjects = <SubjectResult>[];
        for (var subject in subjectsList) {
          subjects.add(
            SubjectResult(
              subjectId: subject['subjectId'] ?? '',
              code: subject['code'] ?? '',
              name: subject['name'] ?? '',
              creditHours: subject['creditHours'] ?? 0,
              internalMarks: (subject['internalMarks'] ?? 0).toDouble(),
              externalMarks: (subject['externalMarks'] ?? 0).toDouble(),
              totalMarks: (subject['totalMarks'] ?? 0).toDouble(),
              gradePoint: (subject['gradePoint'] ?? 0).toDouble(),
              grade: subject['grade'] ?? 'F',
            ),
          );
        }

        results.add(
          Result(
            id: doc.id,
            studentId: studentId,
            semester: resultData['semester'] ?? 0,
            academicYear: resultData['academicYear'] ?? '',
            subjects: subjects,
            cgpa: (resultData['cgpa'] ?? 0).toDouble(),
            gpa: (resultData['gpa'] ?? 0).toDouble(),
            totalCredits: resultData['totalCredits'] ?? 0,
            earnedCredits: resultData['earnedCredits'] ?? 0,
            publishedAt: (resultData['publishedAt'] as Timestamp).toDate(),
          ),
        );
      }
      return results;
    } catch (e) {
      throw DatabaseException(message: 'Failed to fetch results', originalError: e);
    }
  }

  /// Get latest CGPA for a student
  Future<double> getLatestCGPA(String studentId) async {
    try {
      final snapshot = await _firestore
          .collection('results')
          .where('studentId', isEqualTo: studentId)
          .orderBy('publishedAt', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return 0.0;

      return (snapshot.docs.first['cgpa'] ?? 0).toDouble();
    } catch (e) {
      throw DatabaseException(message: 'Failed to fetch CGPA', originalError: e);
    }
  }
}

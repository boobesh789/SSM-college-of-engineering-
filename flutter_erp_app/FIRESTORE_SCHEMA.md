# Firestore Database Schema

## Collections Overview

### 1. users
Stores all user information with role-based data.

```
collection: users
├── document: {userId}
│   ├── email (string) - User email
│   ├── fullName (string) - Full name
│   ├── role (string) - admin, hod, faculty, student
│   ├── department (string) - ECE, CSE, IT, EEE, Mechanical, Civil
│   ├── registrationNumber (string) - For students
│   ├── employeeId (string) - For faculty/hod
│   ├── phoneNumber (string)
│   ├── profileImageUrl (string)
│   ├── isEmailVerified (boolean)
│   ├── isApproved (boolean) - By admin
│   ├── createdAt (timestamp)
│   ├── updatedAt (timestamp)
│   └── fcmToken (string) - For push notifications
```

### 2. departments
Manages department information and hierarchy.

```
collection: departments
├── document: {departmentId}
│   ├── name (string) - ECE, CSE, etc.
│   ├── code (string) - ECE, CSE, etc.
│   ├── hodId (string) - Reference to users collection
│   ├── description (string)
│   ├── building (string)
│   ├── floor (string)
│   ├── createdAt (timestamp)
│   └── updatedAt (timestamp)
```

### 3. subjects
Store subject/course information.

```
collection: subjects
├── document: {subjectId}
│   ├── code (string) - CS101, EC202, etc.
│   ├── name (string)
│   ├── creditHours (number)
│   ├── departmentId (string)
│   ├── facultyId (string) - Assigned faculty
│   ├── semester (number) - 1-8
│   ├── description (string)
│   ├── syllabus (string) - URL to PDF
│   ├── createdAt (timestamp)
│   └── updatedAt (timestamp)
│
│   ├── subcollection: enrollments
│   │   └── document: {studentId}
│   │       ├── enrollmentDate (timestamp)
│   │       ├── status (string) - active, withdrawn, completed
│   │       └── grade (string)
│
│   └── subcollection: materials
│       └── document: {materialId}
│           ├── title (string)
│           ├── type (string) - notes, book, video, etc.
│           ├── fileUrl (string)
│           ├── uploadedAt (timestamp)
│           └── uploadedBy (string) - facultyId
```

### 4. attendance
Tracks student attendance for each subject.

```
collection: attendance
├── document: {subjectId}
│   └── subcollection: records
│       └── document: {YYYY-MM-DD}
│           ├── date (timestamp)
│           ├── classNumber (number)
│           ├── topic (string)
│           └── subcollection: students
│               └── document: {studentId}
│                   ├── status (string) - present, absent, leave
│                   ├── remarks (string)
│                   └── markedAt (timestamp)
```

### 5. assessments
Stores assessment information (Assessment 1, Assessment 2, etc.)

```
collection: assessments
├── document: {assessmentId}
│   ├── subjectId (string)
│   ├── type (string) - Assessment1, Assessment2, Quiz, etc.
│   ├── title (string)
│   ├── totalMarks (number)
│   ├── date (timestamp)
│   ├── dueDate (timestamp)
│   ├── createdBy (string) - facultyId
│   ├── description (string)
│   ├── createdAt (timestamp)
│   └── updatedAt (timestamp)
│
│   └── subcollection: marks
│       └── document: {studentId}
│           ├── marksObtained (number)
│           ├── percentage (number)
│           ├── remarks (string)
│           ├── markedAt (timestamp)
│           └── markedBy (string) - facultyId
```

### 6. assignments
Store assignment details and submissions.

```
collection: assignments
├── document: {assignmentId}
│   ├── subjectId (string)
│   ├── title (string)
│   ├── description (string)
│   ├── instructions (string)
│   ├── totalMarks (number)
│   ├── dueDate (timestamp)
│   ├── createdBy (string) - facultyId
│   ├── createdAt (timestamp)
│   ├── attachments (array) - URLs to resources
│   └── updatedAt (timestamp)
│
│   └── subcollection: submissions
│       └── document: {submissionId}
│           ├── studentId (string)
│           ├── fileUrl (string) - URL to submitted file
│           ├── fileName (string)
│           ├── fileType (string) - pdf, docx, image, etc.
│           ├── submittedAt (timestamp)
│           ├── isLate (boolean)
│           ├── marksObtained (number)
│           ├── feedback (string)
│           ├── gradedAt (timestamp)
│           └── gradedBy (string) - facultyId
```

### 7. results
Stores semester results and performance.

```
collection: results
├── document: {resultId}
│   ├── studentId (string)
│   ├── semester (number)
│   ├── academicYear (string) - 2023-24
│   ├── subjects (array)
│   │   ├── subjectId (string)
│   │   ├── code (string)
│   │   ├── name (string)
│   │   ├── creditHours (number)
│   │   ├── internalMarks (number)
│   │   ├── externalMarks (number)
│   │   ├── totalMarks (number)
│   │   ├── gradePoint (number)
│   │   └── grade (string) - A, B, C, D, F
│   ├── cgpa (number)
│   ├── gpa (number)
│   ├── totalCredits (number)
│   ├── earnedCredits (number)
│   ├── publishedAt (timestamp)
│   └── updatedAt (timestamp)
```

### 8. timetable
Stores class timetable information.

```
collection: timetable
├── document: {timetableId}
│   ├── departmentId (string)
│   ├── semester (number)
│   ├── academicYear (string)
│   ├── startDate (timestamp)
│   ├── endDate (timestamp)
│   ├── schedule (array)
│   │   ├── day (string) - Monday, Tuesday, etc.
│   │   └── slots (array)
│   │       ├── slotNumber (number)
│   │       ├── startTime (string) - HH:mm
│   │       ├── endTime (string) - HH:mm
│   │       ├── subjectId (string)
│   │       ├── facultyId (string)
│   │       ├── room (string)
│   │       └── type (string) - lecture, lab, tutorial
│   ├── createdAt (timestamp)
│   └── updatedAt (timestamp)
```

### 9. notifications
Stores system notifications for users.

```
collection: notifications
├── document: {notificationId}
│   ├── userId (string)
│   ├── title (string)
│   ├── message (string)
│   ├── type (string) - announcement, assignment, result, attendance, etc.
│   ├── relatedId (string) - ID of related document (assignment, result, etc.)
│   ├── senderId (string) - Who sent the notification
│   ├── isRead (boolean)
│   ├── createdAt (timestamp)
│   ├── readAt (timestamp)
│   └── expiresAt (timestamp)
```

### 10. audit_logs
Tracks all important system actions for security and compliance.

```
collection: audit_logs
├── document: {logId}
│   ├── userId (string)
│   ├── action (string) - create, update, delete, login, etc.
│   ├── resourceType (string) - user, subject, assignment, marks, etc.
│   ├── resourceId (string)
│   ├── changes (object) - what was changed
│   │   ├── field (string)
│   │   ├── oldValue (any)
│   │   └── newValue (any)
│   ├── ipAddress (string)
│   ├── userAgent (string)
│   ├── timestamp (timestamp)
│   └── status (string) - success, failed
```

### 11. college_announcements
Global announcements from admin.

```
collection: college_announcements
├── document: {announcementId}
│   ├── title (string)
│   ├── content (string)
│   ├── createdBy (string) - adminId
│   ├── priority (string) - low, medium, high, urgent
│   ├── targetAudience (string) - all, students, faculty, department
│   ├── targetDepartment (string) - if department-specific
│   ├── imageUrl (string)
│   ├── createdAt (timestamp)
│   ├── expiresAt (timestamp)
│   └── isActive (boolean)
```

## Indexing Strategy

### Required Indexes
1. `users` - Filter by role, department, isApproved
2. `subjects` - Filter by departmentId, semester
3. `attendance` - Query by subjectId, date
4. `assessments` - Filter by subjectId, type
5. `assignments` - Filter by subjectId, dueDate
6. `notifications` - Query by userId, isRead, createdAt
7. `audit_logs` - Filter by timestamp, userId, action

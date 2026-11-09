import 'package:flutter/material.dart';
import '../models/student.dart';
import '../models/faculty.dart';
import '../models/appointment.dart';
import '../models/notification.dart';
import '../data/mock_students.dart';
import '../data/mock_faculty.dart';
import '../data/mock_appointments.dart';
import '../data/mock_notifications.dart';

enum UserRole { student, faculty }

class AppStateProvider extends ChangeNotifier {
  // Current Active Role
  UserRole _currentRole = UserRole.student;
  UserRole get currentRole => _currentRole;

  // Active Student
  Student _currentStudent = initialStudent;
  Student get currentStudent => _currentStudent;

  // Active Faculty (for Faculty Module view)
  late Faculty _currentFaculty;
  Faculty get currentFaculty => _currentFaculty;

  // Full Faculty Directory
  List<Faculty> _facultyList = [];
  List<Faculty> get facultyList => _facultyList;

  // Recently Viewed Faculty (for Student Dashboard)
  final List<Faculty> _recentlyViewedFaculty = [];
  List<Faculty> get recentlyViewedFaculty => _recentlyViewedFaculty;

  // All Appointments (Shared across student and faculty)
  List<Appointment> _appointments = [];
  List<Appointment> get appointments => _appointments;

  // Notifications
  List<AppNotification> _notifications = [];
  List<AppNotification> get notifications => _notifications;

  // Filter & Search state for Faculty Directory
  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  String _selectedDepartment = 'All';
  String get selectedDepartment => _selectedDepartment;

  String _selectedAvailabilityFilter = 'All'; // All, Available Now, Mon-Fri
  String get selectedAvailabilityFilter => _selectedAvailabilityFilter;

  String _sortBy = 'Recommended'; // Recommended, Rating, Experience, Name
  String get sortBy => _sortBy;

  AppStateProvider() {
    _initializeData();
  }

  void _initializeData() {
    _facultyList = List.from(initialFacultyList);
    _appointments = List.from(initialAppointments);
    _notifications = List.from(initialNotifications);
    _currentFaculty = _facultyList.firstWhere(
      (f) => f.id == 'FAC-CSE-01',
      orElse: () => _facultyList.first,
    );
    // Add default recently viewed
    if (_facultyList.length >= 3) {
      _recentlyViewedFaculty.addAll([_facultyList[0], _facultyList[1], _facultyList[4]]);
    }
  }

  // --- Role Management ---
  void setRole(UserRole role) {
    if (_currentRole != role) {
      _currentRole = role;
      notifyListeners();
    }
  }

  void switchRole() {
    _currentRole = _currentRole == UserRole.student ? UserRole.faculty : UserRole.student;
    notifyListeners();
  }

  void setCurrentFaculty(String facultyId) {
    final found = _facultyList.firstWhere((f) => f.id == facultyId, orElse: () => _currentFaculty);
    _currentFaculty = found;
    notifyListeners();
  }

  // --- Profile Edits ---
  void updateStudentProfile({
    required String name,
    required String rollNumber,
    required String department,
    required String year,
    required String email,
    required String phone,
  }) {
    _currentStudent = _currentStudent.copyWith(
      name: name,
      rollNumber: rollNumber,
      department: department,
      year: year,
      email: email,
      phone: phone,
    );

    // Also update any existing appointments with this student's updated info
    _appointments = _appointments.map((apt) {
      if (apt.studentId == _currentStudent.id) {
        return apt.copyWith(
          studentName: name,
          studentRollNumber: rollNumber,
          studentDepartment: department,
        );
      }
      return apt;
    }).toList();

    notifyListeners();
  }

  void updateFacultyProfile({
    required String facultyId,
    required String name,
    required String designation,
    required String department,
    required String qualification,
    required String experience,
    required String specialization,
    required String officeLocation,
    required String officeHours,
    required String email,
    required String phone,
    required String about,
    required List<String> areasOfExpertise,
  }) {
    final index = _facultyList.indexWhere((f) => f.id == facultyId);
    if (index != -1) {
      final updated = _facultyList[index].copyWith(
        name: name,
        designation: designation,
        department: department,
        qualification: qualification,
        experience: experience,
        specialization: specialization,
        officeLocation: officeLocation,
        officeHours: officeHours,
        email: email,
        phone: phone,
        about: about,
        areasOfExpertise: areasOfExpertise,
      );
      _facultyList[index] = updated;

      if (_currentFaculty.id == facultyId) {
        _currentFaculty = updated;
      }

      // Update faculty details in appointments
      _appointments = _appointments.map((apt) {
        if (apt.facultyId == facultyId) {
          return apt.copyWith(
            facultyName: name,
            facultyDepartment: department,
            facultyOffice: officeLocation,
          );
        }
        return apt;
      }).toList();

      notifyListeners();
    }
  }

  // --- Faculty Availability Management ---
  void updateFacultyAvailability({
    required String facultyId,
    required List<String> workingDays,
    required String openingTime,
    required String closingTime,
    required int slotDurationMinutes,
    required List<String> availableSlots,
    required List<DateTime> unavailableDates,
    required List<String> holidays,
  }) {
    final index = _facultyList.indexWhere((f) => f.id == facultyId);
    if (index != -1) {
      final updated = _facultyList[index].copyWith(
        workingDays: workingDays,
        openingTime: openingTime,
        closingTime: closingTime,
        slotDurationMinutes: slotDurationMinutes,
        availableSlots: availableSlots,
        unavailableDates: unavailableDates,
        holidays: holidays,
      );
      _facultyList[index] = updated;

      if (_currentFaculty.id == facultyId) {
        _currentFaculty = updated;
      }

      // Add a notification for availability update
      _addNotification(
        title: 'Schedule Updated 🗓️',
        message: 'Your availability configuration has been successfully saved.',
        type: NotificationType.reminder,
        targetRole: TargetRole.faculty,
      );

      notifyListeners();
    }
  }

  // --- Recently Viewed Faculty ---
  void recordFacultyView(Faculty faculty) {
    _recentlyViewedFaculty.removeWhere((f) => f.id == faculty.id);
    _recentlyViewedFaculty.insert(0, faculty);
    if (_recentlyViewedFaculty.length > 5) {
      _recentlyViewedFaculty.removeLast();
    }
    notifyListeners();
  }

  // --- Appointment Queries & Actions ---

  // Check if a time slot for a faculty is already booked (pending or approved) on a date
  bool isSlotAlreadyBooked(String facultyId, DateTime date, String timeSlot) {
    return _appointments.any((apt) {
      final isSameDay = apt.date.year == date.year &&
          apt.date.month == date.month &&
          apt.date.day == date.day;
      final isActiveStatus = apt.status == AppointmentStatus.pending ||
          apt.status == AppointmentStatus.approved;
      return apt.facultyId == facultyId && isSameDay && apt.timeSlot == timeSlot && isActiveStatus;
    });
  }

  // Book an appointment (Student workflow)
  String bookAppointment({
    required Faculty faculty,
    required DateTime date,
    required String timeSlot,
    required String appointmentType,
    required String purpose,
    required String additionalMessage,
  }) {
    final newId = 'APT-2026-${(1000 + _appointments.length + 1)}';

    final newAppointment = Appointment(
      id: newId,
      studentId: _currentStudent.id,
      studentName: _currentStudent.name,
      studentRollNumber: _currentStudent.rollNumber,
      studentDepartment: _currentStudent.department,
      facultyId: faculty.id,
      facultyName: faculty.name,
      facultyDepartment: faculty.department,
      facultyOffice: faculty.officeLocation,
      date: date,
      timeSlot: timeSlot,
      appointmentType: appointmentType,
      purpose: purpose,
      additionalMessage: additionalMessage,
      status: AppointmentStatus.pending,
      createdAt: DateTime.now(),
    );

    _appointments.insert(0, newAppointment);

    // Generate local notification for Faculty
    _addNotification(
      title: 'New Appointment Request 📋',
      message: '${_currentStudent.name} (${_currentStudent.rollNumber}) booked an appointment for $timeSlot.',
      type: NotificationType.request,
      targetRole: TargetRole.faculty,
      appointmentId: newId,
    );

    // Generate confirmation notification for Student
    _addNotification(
      title: 'Booking Request Sent 🚀',
      message: 'Your appointment request with ${faculty.name} for $timeSlot is pending confirmation.',
      type: NotificationType.reminder,
      targetRole: TargetRole.student,
      appointmentId: newId,
    );

    notifyListeners();
    return newId;
  }

  // Approve an appointment (Faculty workflow)
  void approveAppointment(String appointmentId) {
    final index = _appointments.indexWhere((a) => a.id == appointmentId);
    if (index != -1) {
      final apt = _appointments[index];
      _appointments[index] = apt.copyWith(status: AppointmentStatus.approved);

      // Generate local notification for Student
      _addNotification(
        title: 'Appointment Approved! 🎉',
        message: '${apt.facultyName} has approved your consultation on ${apt.timeSlot}.',
        type: NotificationType.approval,
        targetRole: TargetRole.student,
        appointmentId: appointmentId,
      );

      notifyListeners();
    }
  }

  // Reject an appointment (Faculty workflow)
  void rejectAppointment(String appointmentId, String reason) {
    final index = _appointments.indexWhere((a) => a.id == appointmentId);
    if (index != -1) {
      final apt = _appointments[index];
      _appointments[index] = apt.copyWith(
        status: AppointmentStatus.rejected,
        rejectionReason: reason.trim().isEmpty ? 'Faculty unavailable for requested time slot.' : reason,
      );

      // Generate local notification for Student
      _addNotification(
        title: 'Appointment Declined ⚠️',
        message: '${apt.facultyName} declined your slot: ${reason.trim().isEmpty ? "Faculty unavailable." : reason}',
        type: NotificationType.rejection,
        targetRole: TargetRole.student,
        appointmentId: appointmentId,
      );

      notifyListeners();
    }
  }

  // Cancel an appointment (Student or Faculty)
  void cancelAppointment(String appointmentId, String reason) {
    final index = _appointments.indexWhere((a) => a.id == appointmentId);
    if (index != -1) {
      final apt = _appointments[index];
      _appointments[index] = apt.copyWith(
        status: AppointmentStatus.cancelled,
        cancellationReason: reason.trim().isEmpty ? 'Cancelled by user.' : reason,
      );

      // Generate local notification for both parties
      _addNotification(
        title: 'Appointment Cancelled 🚫',
        message: 'The appointment ($appointmentId) with ${apt.studentName} was cancelled.',
        type: NotificationType.cancellation,
        targetRole: TargetRole.faculty,
        appointmentId: appointmentId,
      );

      _addNotification(
        title: 'Appointment Cancelled 🚫',
        message: 'Your appointment ($appointmentId) with ${apt.facultyName} has been cancelled.',
        type: NotificationType.cancellation,
        targetRole: TargetRole.student,
        appointmentId: appointmentId,
      );

      notifyListeners();
    }
  }

  // Helper getters for student appointments
  List<Appointment> get studentAppointments {
    return _appointments.where((a) => a.studentId == _currentStudent.id).toList();
  }

  List<Appointment> get studentUpcomingAppointments {
    return studentAppointments
        .where((a) => a.status == AppointmentStatus.approved)
        .toList();
  }

  List<Appointment> get studentPendingAppointments {
    return studentAppointments
        .where((a) => a.status == AppointmentStatus.pending)
        .toList();
  }

  List<Appointment> get studentCompletedAppointments {
    return studentAppointments
        .where((a) => a.status == AppointmentStatus.completed)
        .toList();
  }

  List<Appointment> get studentCancelledAppointments {
    return studentAppointments
        .where((a) => a.status == AppointmentStatus.cancelled)
        .toList();
  }

  // Helper getters for faculty appointments
  List<Appointment> get facultyAppointments {
    return _appointments.where((a) => a.facultyId == _currentFaculty.id).toList();
  }

  List<Appointment> get facultyPendingRequests {
    return facultyAppointments
        .where((a) => a.status == AppointmentStatus.pending)
        .toList();
  }

  List<Appointment> get facultyApprovedAppointments {
    return facultyAppointments
        .where((a) => a.status == AppointmentStatus.approved)
        .toList();
  }

  List<Appointment> get facultyTodayAppointments {
    final now = DateTime.now();
    return facultyApprovedAppointments.where((a) {
      return a.date.year == now.year && a.date.month == now.month && a.date.day == now.day;
    }).toList();
  }

  List<Appointment> get facultyCompletedAppointments {
    return facultyAppointments
        .where((a) => a.status == AppointmentStatus.completed)
        .toList();
  }

  // --- Notification Actions ---
  void _addNotification({
    required String title,
    required String message,
    required NotificationType type,
    required TargetRole targetRole,
    String? appointmentId,
  }) {
    final newNotif = AppNotification(
      id: 'NOTIF-${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      message: message,
      type: type,
      targetRole: targetRole,
      timestamp: DateTime.now(),
      isRead: false,
      appointmentId: appointmentId,
    );
    _notifications.insert(0, newNotif);
  }

  int unreadNotificationsCount(UserRole role) {
    final target = role == UserRole.student ? TargetRole.student : TargetRole.faculty;
    return _notifications.where((n) => (n.targetRole == target || n.targetRole == TargetRole.all) && !n.isRead).length;
  }

  List<AppNotification> getNotificationsForRole(UserRole role) {
    final target = role == UserRole.student ? TargetRole.student : TargetRole.faculty;
    return _notifications.where((n) => n.targetRole == target || n.targetRole == TargetRole.all).toList();
  }

  void markNotificationAsRead(String notifId) {
    final index = _notifications.indexWhere((n) => n.id == notifId);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      notifyListeners();
    }
  }

  void markAllNotificationsAsRead(UserRole role) {
    final target = role == UserRole.student ? TargetRole.student : TargetRole.faculty;
    _notifications = _notifications.map((n) {
      if (n.targetRole == target || n.targetRole == TargetRole.all) {
        return n.copyWith(isRead: true);
      }
      return n;
    }).toList();
    notifyListeners();
  }

  void clearAllNotifications(UserRole role) {
    final target = role == UserRole.student ? TargetRole.student : TargetRole.faculty;
    _notifications.removeWhere((n) => n.targetRole == target || n.targetRole == TargetRole.all);
    notifyListeners();
  }

  // --- Faculty Filter and Search ---
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setDepartmentFilter(String dept) {
    _selectedDepartment = dept;
    notifyListeners();
  }

  void setAvailabilityFilter(String filter) {
    _selectedAvailabilityFilter = filter;
    notifyListeners();
  }

  void setSortBy(String sort) {
    _sortBy = sort;
    notifyListeners();
  }

  List<Faculty> get filteredFacultyList {
    return _facultyList.where((faculty) {
      // Search query
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchesName = faculty.name.toLowerCase().contains(q);
        final matchesDept = faculty.department.toLowerCase().contains(q);
        final matchesSpec = faculty.specialization.toLowerCase().contains(q);
        final matchesExpertise = faculty.areasOfExpertise.any((e) => e.toLowerCase().contains(q));
        if (!matchesName && !matchesDept && !matchesSpec && !matchesExpertise) {
          return false;
        }
      }

      // Department filter
      if (_selectedDepartment != 'All') {
        if (faculty.department != _selectedDepartment) {
          return false;
        }
      }

      // Availability filter
      if (_selectedAvailabilityFilter == 'Available Now') {
        if (!faculty.isAvailableNow) return false;
      }

      return true;
    }).toList()
      ..sort((a, b) {
        if (_sortBy == 'Rating') {
          return b.rating.compareTo(a.rating);
        } else if (_sortBy == 'Name') {
          return a.name.compareTo(b.name);
        } else if (_sortBy == 'Experience') {
          return b.experience.compareTo(a.experience);
        }
        return 0; // Recommended default
      });
  }
}

enum AppointmentStatus {
  pending,
  approved,
  rejected,
  completed,
  cancelled,
}

extension AppointmentStatusExtension on AppointmentStatus {
  String get label {
    switch (this) {
      case AppointmentStatus.pending:
        return 'Pending';
      case AppointmentStatus.approved:
        return 'Approved';
      case AppointmentStatus.rejected:
        return 'Rejected';
      case AppointmentStatus.completed:
        return 'Completed';
      case AppointmentStatus.cancelled:
        return 'Cancelled';
    }
  }
}

class Appointment {
  final String id;
  final String studentId;
  final String studentName;
  final String studentRollNumber;
  final String studentDepartment;
  final String facultyId;
  final String facultyName;
  final String facultyDepartment;
  final String facultyOffice;
  final DateTime date;
  final String timeSlot;
  final String appointmentType;
  final String purpose;
  final String additionalMessage;
  final AppointmentStatus status;
  final DateTime createdAt;
  final String? rejectionReason;
  final String? cancellationReason;

  const Appointment({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.studentRollNumber,
    required this.studentDepartment,
    required this.facultyId,
    required this.facultyName,
    required this.facultyDepartment,
    required this.facultyOffice,
    required this.date,
    required this.timeSlot,
    required this.appointmentType,
    required this.purpose,
    required this.additionalMessage,
    required this.status,
    required this.createdAt,
    this.rejectionReason,
    this.cancellationReason,
  });

  Appointment copyWith({
    String? id,
    String? studentId,
    String? studentName,
    String? studentRollNumber,
    String? studentDepartment,
    String? facultyId,
    String? facultyName,
    String? facultyDepartment,
    String? facultyOffice,
    DateTime? date,
    String? timeSlot,
    String? appointmentType,
    String? purpose,
    String? additionalMessage,
    AppointmentStatus? status,
    DateTime? createdAt,
    String? rejectionReason,
    String? cancellationReason,
  }) {
    return Appointment(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      studentRollNumber: studentRollNumber ?? this.studentRollNumber,
      studentDepartment: studentDepartment ?? this.studentDepartment,
      facultyId: facultyId ?? this.facultyId,
      facultyName: facultyName ?? this.facultyName,
      facultyDepartment: facultyDepartment ?? this.facultyDepartment,
      facultyOffice: facultyOffice ?? this.facultyOffice,
      date: date ?? this.date,
      timeSlot: timeSlot ?? this.timeSlot,
      appointmentType: appointmentType ?? this.appointmentType,
      purpose: purpose ?? this.purpose,
      additionalMessage: additionalMessage ?? this.additionalMessage,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      cancellationReason: cancellationReason ?? this.cancellationReason,
    );
  }
}

enum NotificationType {
  request,
  approval,
  rejection,
  cancellation,
  reminder,
}

enum TargetRole {
  student,
  faculty,
  all,
}

class AppNotification {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final TargetRole targetRole;
  final DateTime timestamp;
  final bool isRead;
  final String? appointmentId;

  const AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.targetRole,
    required this.timestamp,
    this.isRead = false,
    this.appointmentId,
  });

  AppNotification copyWith({
    String? id,
    String? title,
    String? message,
    NotificationType? type,
    TargetRole? targetRole,
    DateTime? timestamp,
    bool? isRead,
    String? appointmentId,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      targetRole: targetRole ?? this.targetRole,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      appointmentId: appointmentId ?? this.appointmentId,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/notification.dart';
import '../../providers/app_state_provider.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/empty_state_view.dart';
import '../student/appointments/appointment_details_screen.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppStateProvider>();
    final notifications = appState.getNotificationsForRole(appState.currentRole);
    final unreadCount = appState.unreadNotificationsCount(appState.currentRole);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Notifications',
        showNotificationAction: false,
        actions: [
          if (notifications.isNotEmpty)
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert_rounded, color: AppColors.primaryRoyalBlue),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              onSelected: (value) {
                if (value == 'mark_read') {
                  appState.markAllNotificationsAsRead(appState.currentRole);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('All notifications marked as read.'),
                      backgroundColor: AppColors.primaryRoyalBlue,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                } else if (value == 'clear_all') {
                  appState.clearAllNotifications(appState.currentRole);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Notifications cleared.'),
                      backgroundColor: AppColors.secondaryBlue,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              itemBuilder: (_) => [
                const PopupMenuItem(
                  value: 'mark_read',
                  child: Row(
                    children: [
                      Icon(Icons.done_all_rounded, size: 18, color: AppColors.primaryRoyalBlue),
                      SizedBox(width: 8),
                      Text('Mark all as read'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'clear_all',
                  child: Row(
                    children: [
                      Icon(Icons.delete_sweep_outlined, size: 18, color: AppColors.statusRejected),
                      SizedBox(width: 8),
                      Text('Clear all'),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
      body: notifications.isEmpty
          ? const EmptyStateView(
              icon: Icons.notifications_off_outlined,
              title: 'No Notifications Yet',
              message: 'You are all caught up! Activity regarding appointments and requests will appear here.',
            )
          : Column(
              children: [
                // Unread status banner
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  color: AppColors.veryLightBlue.withValues(alpha: 0.6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            unreadCount > 0 ? Icons.mark_email_unread_rounded : Icons.mark_email_read_rounded,
                            size: 16,
                            color: AppColors.primaryRoyalBlue,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            unreadCount > 0
                                ? '$unreadCount Unread Notification${unreadCount > 1 ? "s" : ""}'
                                : 'All Notifications Read',
                            style: const TextStyle(
                              color: AppColors.primaryRoyalBlue,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      if (unreadCount > 0)
                        InkWell(
                          onTap: () => appState.markAllNotificationsAsRead(appState.currentRole),
                          child: const Text(
                            'Mark all read',
                            style: TextStyle(
                              color: AppColors.secondaryBlue,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: notifications.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final notif = notifications[index];
                      return _buildNotificationCard(context, notif, appState);
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildNotificationCard(
    BuildContext context,
    AppNotification notif,
    AppStateProvider appState,
  ) {
    IconData icon;
    Color iconColor;
    Color iconBg;

    switch (notif.type) {
      case NotificationType.approval:
        icon = Icons.check_circle_rounded;
        iconColor = AppColors.statusApproved;
        iconBg = AppColors.statusApprovedBg;
        break;
      case NotificationType.request:
        icon = Icons.assignment_turned_in_rounded;
        iconColor = AppColors.primaryRoyalBlue;
        iconBg = AppColors.lightBlue;
        break;
      case NotificationType.rejection:
        icon = Icons.cancel_rounded;
        iconColor = AppColors.statusRejected;
        iconBg = AppColors.statusRejectedBg;
        break;
      case NotificationType.cancellation:
        icon = Icons.do_not_disturb_on_rounded;
        iconColor = AppColors.statusCancelled;
        iconBg = AppColors.statusCancelledBg;
        break;
      case NotificationType.reminder:
        icon = Icons.alarm_rounded;
        iconColor = AppColors.statusPending;
        iconBg = AppColors.statusPendingBg;
        break;
    }

    final timeAgo = _formatTimestamp(notif.timestamp);

    return InkWell(
      onTap: () {
        if (!notif.isRead) {
          appState.markNotificationAsRead(notif.id);
        }
        if (notif.appointmentId != null) {
          final matched = appState.appointments.where((a) => a.id == notif.appointmentId).toList();
          if (matched.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AppointmentDetailsScreen(appointment: matched.first),
              ),
            );
          }
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: notif.isRead ? AppColors.white : AppColors.veryLightBlue.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: notif.isRead ? AppColors.borderColor : AppColors.primaryRoyalBlue.withValues(alpha: 0.4),
            width: notif.isRead ? 1 : 1.3,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryRoyalBlue.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          notif.title,
                          style: TextStyle(
                            color: AppColors.primaryText,
                            fontSize: 14.5,
                            fontWeight: notif.isRead ? FontWeight.w600 : FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (!notif.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.primaryRoyalBlue,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    notif.message,
                    style: TextStyle(
                      color: notif.isRead ? AppColors.secondaryText : AppColors.primaryText,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        timeAgo,
                        style: const TextStyle(
                          color: AppColors.mutedText,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (notif.appointmentId != null)
                        const Row(
                          children: [
                            Text(
                              'View Appointment',
                              style: TextStyle(
                                color: AppColors.primaryRoyalBlue,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 3),
                            Icon(Icons.arrow_forward_ios_rounded, size: 10, color: AppColors.primaryRoyalBlue),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return DateFormat('MMM d, h:mm a').format(dt);
  }
}

import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../models/appointment.dart';

class StatusBadge extends StatelessWidget {
  final AppointmentStatus status;
  final bool showDot;

  const StatusBadge({
    super.key,
    required this.status,
    this.showDot = true,
  });

  @override
  Widget build(BuildContext context) {
    Color textColor;
    Color bgColor;
    IconData icon;

    switch (status) {
      case AppointmentStatus.approved:
        textColor = AppColors.statusApproved;
        bgColor = AppColors.statusApprovedBg;
        icon = Icons.check_circle_rounded;
        break;
      case AppointmentStatus.pending:
        textColor = AppColors.statusPending;
        bgColor = AppColors.statusPendingBg;
        icon = Icons.access_time_filled_rounded;
        break;
      case AppointmentStatus.rejected:
        textColor = AppColors.statusRejected;
        bgColor = AppColors.statusRejectedBg;
        icon = Icons.cancel_rounded;
        break;
      case AppointmentStatus.completed:
        textColor = AppColors.secondaryBlue;
        bgColor = AppColors.lightBlue;
        icon = Icons.task_alt_rounded;
        break;
      case AppointmentStatus.cancelled:
        textColor = AppColors.statusCancelled;
        bgColor = AppColors.statusCancelledBg;
        icon = Icons.do_disturb_on_rounded;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: textColor.withValues(alpha: 0.25),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDot) ...[
            Icon(icon, size: 13, color: textColor),
            const SizedBox(width: 5),
          ],
          Text(
            status.label,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

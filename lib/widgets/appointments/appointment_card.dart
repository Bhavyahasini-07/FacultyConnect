import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../models/appointment.dart';
import '../common/status_badge.dart';

class AppointmentCard extends StatelessWidget {
  final Appointment appointment;
  final bool isFacultyPerspective;
  final VoidCallback onTap;
  final VoidCallback? onCancel;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;

  const AppointmentCard({
    super.key,
    required this.appointment,
    this.isFacultyPerspective = false,
    required this.onTap,
    this.onCancel,
    this.onApprove,
    this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('EEE, MMM d, yyyy');
    final formattedDate = dateFormat.format(appointment.date);

    final isActionable = appointment.status == AppointmentStatus.pending ||
        appointment.status == AppointmentStatus.approved;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderColor, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryRoyalBlue.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: ID + Status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.veryLightBlue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        appointment.id,
                        style: const TextStyle(
                          color: AppColors.primaryRoyalBlue,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    StatusBadge(status: appointment.status),
                  ],
                ),
                const SizedBox(height: 12),
                // Person Details (Faculty for student; Student for faculty)
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: AppColors.veryLightBlue,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFacultyPerspective ? Icons.school_rounded : Icons.person_outline_rounded,
                        color: AppColors.primaryRoyalBlue,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isFacultyPerspective ? appointment.studentName : appointment.facultyName,
                            style: const TextStyle(
                              color: AppColors.primaryText,
                              fontSize: 15.5,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isFacultyPerspective
                                ? '${appointment.studentRollNumber} • ${appointment.studentDepartment}'
                                : '${appointment.facultyDepartment} • ${appointment.facultyOffice}',
                            style: const TextStyle(
                              color: AppColors.secondaryText,
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Date & Time Box
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.veryLightBlue.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.borderColor.withValues(alpha: 0.8)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.event_rounded, size: 15, color: AppColors.primaryRoyalBlue),
                      const SizedBox(width: 6),
                      Text(
                        formattedDate,
                        style: const TextStyle(
                          color: AppColors.primaryText,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.schedule_rounded, size: 15, color: AppColors.primaryRoyalBlue),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          appointment.timeSlot,
                          style: const TextStyle(
                            color: AppColors.primaryText,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                // Purpose tag
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.lightBlue.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        appointment.appointmentType,
                        style: const TextStyle(
                          color: AppColors.primaryRoyalBlue,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        appointment.purpose,
                        style: const TextStyle(
                          color: AppColors.secondaryText,
                          fontSize: 12.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                // Actions row
                if (isFacultyPerspective && appointment.status == AppointmentStatus.pending) ...[
                  const SizedBox(height: 14),
                  const Divider(height: 1, color: AppColors.borderColor),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: onReject,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.statusRejected,
                            side: const BorderSide(color: AppColors.statusRejected, width: 1.2),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.close_rounded, size: 16),
                              SizedBox(width: 4),
                              Text('Reject', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onApprove,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.statusApproved,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check_rounded, size: 16),
                              SizedBox(width: 4),
                              Text('Approve', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ] else if (!isFacultyPerspective && isActionable && onCancel != null) ...[
                  const SizedBox(height: 12),
                  const Divider(height: 1, color: AppColors.borderColor),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton.icon(
                        onPressed: onCancel,
                        icon: const Icon(Icons.cancel_outlined, size: 16, color: AppColors.statusRejected),
                        label: const Text(
                          'Cancel Slot',
                          style: TextStyle(
                            color: AppColors.statusRejected,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                      ),
                      TextButton.icon(
                        onPressed: onTap,
                        icon: const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: AppColors.primaryRoyalBlue),
                        label: const Text(
                          'View Details',
                          style: TextStyle(
                            color: AppColors.primaryRoyalBlue,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

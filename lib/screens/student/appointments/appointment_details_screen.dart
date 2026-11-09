import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/appointment.dart';
import '../../../providers/app_state_provider.dart';
import '../../../widgets/common/custom_app_bar.dart';
import '../../../widgets/common/status_badge.dart';
import '../../../widgets/common/confirm_dialog.dart';
import '../../../widgets/common/primary_button.dart';
import '../../../widgets/common/secondary_button.dart';

class AppointmentDetailsScreen extends StatelessWidget {
  final Appointment appointment;

  const AppointmentDetailsScreen({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppStateProvider>();
    // Get live updated instance of this appointment
    final liveApt = appState.appointments.firstWhere(
      (a) => a.id == appointment.id,
      orElse: () => appointment,
    );

    final isFacultyPerspective = appState.currentRole == UserRole.faculty;
    final dateFormat = DateFormat('EEEE, MMMM d, yyyy');
    final formattedDate = dateFormat.format(liveApt.date);
    final bookingCreatedDate = DateFormat('MMM d, yyyy • h:mm a').format(liveApt.createdAt);

    final canCancel = liveApt.status == AppointmentStatus.pending ||
        liveApt.status == AppointmentStatus.approved;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Appointment Details',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status and ID Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.borderColor, width: 1.2),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryRoyalBlue.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'APPOINTMENT ID',
                            style: TextStyle(
                              color: AppColors.secondaryText,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            liveApt.id,
                            style: const TextStyle(
                              color: AppColors.primaryText,
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      StatusBadge(status: liveApt.status),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Divider(height: 1, color: AppColors.borderColor),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      const Icon(Icons.history_toggle_off_rounded, size: 16, color: AppColors.secondaryText),
                      const SizedBox(width: 8),
                      Text(
                        'Requested on $bookingCreatedDate',
                        style: const TextStyle(
                          color: AppColors.secondaryText,
                          fontSize: 12.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Rejection or Cancellation Note if applicable
            if (liveApt.rejectionReason != null && liveApt.rejectionReason!.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.statusRejectedBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.statusRejected.withValues(alpha: 0.3)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.warning_amber_rounded, color: AppColors.statusRejected, size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Faculty Rejection Reason',
                            style: TextStyle(
                              color: AppColors.statusRejected,
                              fontWeight: FontWeight.w700,
                              fontSize: 13.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            liveApt.rejectionReason!,
                            style: const TextStyle(
                              color: AppColors.primaryText,
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
            ],

            if (liveApt.cancellationReason != null && liveApt.cancellationReason!.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.statusCancelledBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.statusCancelled.withValues(alpha: 0.3)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline_rounded, color: AppColors.statusCancelled, size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Cancellation Reason',
                            style: TextStyle(
                              color: AppColors.statusCancelled,
                              fontWeight: FontWeight.w700,
                              fontSize: 13.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            liveApt.cancellationReason!,
                            style: const TextStyle(
                              color: AppColors.primaryText,
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
            ],

            // Faculty Information Section
            _buildSectionHeader('Faculty Information', Icons.badge_outlined),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.borderColor),
              ),
              child: Column(
                children: [
                  _buildInfoTile('Faculty Name', liveApt.facultyName, isHighlight: true),
                  _buildInfoTile('Department', liveApt.facultyDepartment),
                  _buildInfoTile('Office Location', liveApt.facultyOffice),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Student Information Section
            _buildSectionHeader('Student Information', Icons.school_outlined),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.borderColor),
              ),
              child: Column(
                children: [
                  _buildInfoTile('Student Name', liveApt.studentName, isHighlight: true),
                  _buildInfoTile('Roll Number', liveApt.studentRollNumber),
                  _buildInfoTile('Department', liveApt.studentDepartment),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Schedule & Time Section
            _buildSectionHeader('Schedule & Slot', Icons.calendar_today_rounded),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.borderColor),
              ),
              child: Column(
                children: [
                  _buildInfoTile('Appointment Date', formattedDate),
                  _buildInfoTile('Reserved Time Slot', liveApt.timeSlot, isHighlight: true),
                  _buildInfoTile('Consultation Type', liveApt.appointmentType),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Purpose & Note Section
            _buildSectionHeader('Purpose & Agenda', Icons.description_outlined),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Primary Objective:',
                    style: TextStyle(
                      color: AppColors.secondaryText,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    liveApt.purpose,
                    style: const TextStyle(
                      color: AppColors.primaryText,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                  ),
                  if (liveApt.additionalMessage.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    const Divider(height: 1, color: AppColors.borderColor),
                    const SizedBox(height: 12),
                    const Text(
                      'Additional Message / Notes:',
                      style: TextStyle(
                        color: AppColors.secondaryText,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      liveApt.additionalMessage,
                      style: const TextStyle(
                        color: AppColors.primaryText,
                        fontSize: 13.5,
                        height: 1.45,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Actions Based on Status & Role
            if (isFacultyPerspective && liveApt.status == AppointmentStatus.pending) ...[
              Row(
                children: [
                  Expanded(
                    child: SecondaryButton(
                      text: 'Decline Request',
                      icon: Icons.close_rounded,
                      textColor: AppColors.statusRejected,
                      onPressed: () async {
                        final result = await ConfirmDialog.show(
                          context: context,
                          title: 'Decline Appointment?',
                          message: 'Are you sure you want to decline this request from ${liveApt.studentName}?',
                          confirmText: 'Decline',
                          confirmColor: AppColors.statusRejected,
                          requireReasonInput: true,
                          reasonHint: 'State reason (e.g., lecture duty, exam schedule)...',
                          icon: Icons.cancel_outlined,
                        );
                        if (result != null && result['confirmed'] == true) {
                          appState.rejectAppointment(liveApt.id, result['reason'] ?? '');
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Appointment declined.'),
                                backgroundColor: AppColors.statusRejected,
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final result = await ConfirmDialog.show(
                          context: context,
                          title: 'Approve Appointment?',
                          message: 'Confirm appointment with ${liveApt.studentName} for ${liveApt.timeSlot}?',
                          confirmText: 'Approve',
                          confirmColor: AppColors.statusApproved,
                          icon: Icons.check_circle_outline_rounded,
                        );
                        if (result != null && result['confirmed'] == true) {
                          appState.approveAppointment(liveApt.id);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Appointment successfully approved!'),
                                backgroundColor: AppColors.statusApproved,
                              ),
                            );
                          }
                        }
                      },
                      icon: const Icon(Icons.check_rounded, color: Colors.white),
                      label: const Text(
                        'Approve Slot',
                        style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.statusApproved,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                  ),
                ],
              ),
            ] else if (canCancel) ...[
              SecondaryButton(
                text: 'Cancel This Appointment',
                icon: Icons.cancel_outlined,
                textColor: AppColors.statusRejected,
                onPressed: () async {
                  final result = await ConfirmDialog.show(
                    context: context,
                    title: 'Cancel Appointment?',
                    message: 'Are you sure you want to cancel this scheduled appointment? This action cannot be undone.',
                    confirmText: 'Yes, Cancel',
                    confirmColor: AppColors.statusRejected,
                    requireReasonInput: true,
                    reasonHint: 'Optional reason for cancellation...',
                    icon: Icons.warning_rounded,
                  );
                  if (result != null && result['confirmed'] == true) {
                    appState.cancelAppointment(liveApt.id, result['reason'] ?? '');
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Appointment cancelled.'),
                          backgroundColor: AppColors.statusCancelled,
                        ),
                      );
                    }
                  }
                },
              ),
            ],
            const SizedBox(height: 16),
            PrimaryButton(
              text: 'Back to Appointments',
              icon: Icons.arrow_back_rounded,
              onPressed: () => Navigator.of(context).maybePop(),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primaryRoyalBlue),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: AppColors.primaryText,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoTile(String label, String value, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.secondaryText,
              fontSize: 13,
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                color: isHighlight ? AppColors.primaryRoyalBlue : AppColors.primaryText,
                fontSize: 13.5,
                fontWeight: isHighlight ? FontWeight.w700 : FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

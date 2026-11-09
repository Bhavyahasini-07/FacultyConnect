import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../providers/app_state_provider.dart';
import '../../../widgets/appointments/appointment_card.dart';
import '../../../widgets/common/confirm_dialog.dart';
import '../../../widgets/common/empty_state_view.dart';
import '../../student/appointments/appointment_details_screen.dart';

class AppointmentRequestsScreen extends StatelessWidget {
  const AppointmentRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppStateProvider>();
    final pendingRequests = appState.facultyPendingRequests;
    final allFacultyAppointments = appState.facultyAppointments;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.mainBackground,
        appBar: AppBar(
          title: const Text('Appointment Requests'),
          automaticallyImplyLeading: false,
          bottom: TabBar(
            indicatorColor: AppColors.primaryRoyalBlue,
            indicatorWeight: 3,
            labelColor: AppColors.primaryRoyalBlue,
            unselectedLabelColor: AppColors.secondaryText,
            labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
            tabs: [
              Tab(text: 'Pending Requests (${pendingRequests.length})'),
              Tab(text: 'All Consultations (${allFacultyAppointments.length})'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1: Pending Requests
            pendingRequests.isEmpty
                ? const EmptyStateView(
                    icon: Icons.check_circle_outline_rounded,
                    title: 'No Pending Requests',
                    message: 'Great job! You have addressed all pending appointment requests.',
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: pendingRequests.length,
                    itemBuilder: (context, index) {
                      final apt = pendingRequests[index];
                      return AppointmentCard(
                        appointment: apt,
                        isFacultyPerspective: true,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AppointmentDetailsScreen(appointment: apt),
                            ),
                          );
                        },
                        onApprove: () async {
                          final result = await ConfirmDialog.show(
                            context: context,
                            title: 'Approve Request?',
                            message:
                                'Confirm appointment with ${apt.studentName} (${apt.studentRollNumber}) for ${apt.timeSlot}?',
                            confirmText: 'Approve',
                            confirmColor: AppColors.statusApproved,
                            icon: Icons.check_circle_rounded,
                          );

                          if (result != null && result['confirmed'] == true) {
                            appState.approveAppointment(apt.id);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Appointment with ${apt.studentName} approved!'),
                                  backgroundColor: AppColors.statusApproved,
                                ),
                              );
                            }
                          }
                        },
                        onReject: () async {
                          final result = await ConfirmDialog.show(
                            context: context,
                            title: 'Decline Request?',
                            message:
                                'Provide a brief reason to notify ${apt.studentName} about the slot rejection.',
                            confirmText: 'Decline Slot',
                            confirmColor: AppColors.statusRejected,
                            requireReasonInput: true,
                            reasonHint: 'e.g., examination duty, conflicting conference...',
                            icon: Icons.cancel_rounded,
                          );

                          if (result != null && result['confirmed'] == true) {
                            appState.rejectAppointment(apt.id, result['reason'] ?? '');
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Request declined and student notified.'),
                                  backgroundColor: AppColors.statusRejected,
                                ),
                              );
                            }
                          }
                        },
                      );
                    },
                  ),

            // Tab 2: All Consultations for this faculty
            allFacultyAppointments.isEmpty
                ? const EmptyStateView(
                    icon: Icons.calendar_today_rounded,
                    title: 'No Appointments Found',
                    message: 'No student consultation records exist yet.',
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: allFacultyAppointments.length,
                    itemBuilder: (context, index) {
                      final apt = allFacultyAppointments[index];
                      return AppointmentCard(
                        appointment: apt,
                        isFacultyPerspective: true,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AppointmentDetailsScreen(appointment: apt),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}

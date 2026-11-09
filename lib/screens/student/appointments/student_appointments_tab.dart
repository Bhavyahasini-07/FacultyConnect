import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/appointment.dart';
import '../../../providers/app_state_provider.dart';
import '../../../widgets/appointments/appointment_card.dart';
import '../../../widgets/common/confirm_dialog.dart';
import '../../../widgets/common/empty_state_view.dart';
import 'appointment_details_screen.dart';

class StudentAppointmentsTab extends StatefulWidget {
  final int initialTabIndex;

  const StudentAppointmentsTab({super.key, this.initialTabIndex = 0});

  @override
  State<StudentAppointmentsTab> createState() => _StudentAppointmentsTabState();
}

class _StudentAppointmentsTabState extends State<StudentAppointmentsTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _tabs = [
    'All',
    'Upcoming',
    'Pending',
    'Completed',
    'Cancelled',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _tabs.length,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Appointment> _getAppointmentsForTab(int tabIndex, AppStateProvider state) {
    switch (tabIndex) {
      case 0:
        return state.studentAppointments;
      case 1:
        return state.studentUpcomingAppointments;
      case 2:
        return state.studentPendingAppointments;
      case 3:
        return state.studentCompletedAppointments;
      case 4:
        return state.studentCancelledAppointments;
      default:
        return state.studentAppointments;
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppStateProvider>();

    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      appBar: AppBar(
        title: const Text('My Appointments'),
        automaticallyImplyLeading: false,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          indicatorColor: AppColors.primaryRoyalBlue,
          indicatorWeight: 3,
          labelColor: AppColors.primaryRoyalBlue,
          unselectedLabelColor: AppColors.secondaryText,
          labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
          tabs: [
            Tab(text: 'All (${appState.studentAppointments.length})'),
            Tab(text: 'Upcoming (${appState.studentUpcomingAppointments.length})'),
            Tab(text: 'Pending (${appState.studentPendingAppointments.length})'),
            Tab(text: 'Completed (${appState.studentCompletedAppointments.length})'),
            Tab(text: 'Cancelled (${appState.studentCancelledAppointments.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: List.generate(_tabs.length, (index) {
          final list = _getAppointmentsForTab(index, appState);

          if (list.isEmpty) {
            return EmptyStateView(
              icon: Icons.event_busy_rounded,
              title: 'No ${_tabs[index]} Appointments',
              message: 'You currently have no consultations in the ${_tabs[index].toLowerCase()} category.',
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            itemBuilder: (context, i) {
              final apt = list[i];
              return AppointmentCard(
                appointment: apt,
                isFacultyPerspective: false,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AppointmentDetailsScreen(appointment: apt),
                    ),
                  );
                },
                onCancel: (apt.status == AppointmentStatus.pending ||
                        apt.status == AppointmentStatus.approved)
                    ? () async {
                        final result = await ConfirmDialog.show(
                          context: context,
                          title: 'Cancel Appointment?',
                          message:
                              'Are you sure you want to cancel your consultation with ${apt.facultyName}?',
                          confirmText: 'Cancel Appointment',
                          confirmColor: AppColors.statusRejected,
                          requireReasonInput: true,
                          reasonHint: 'Reason for cancellation...',
                          icon: Icons.cancel_outlined,
                        );

                        if (result != null && result['confirmed'] == true) {
                          appState.cancelAppointment(apt.id, result['reason'] ?? '');
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Appointment has been cancelled.'),
                                backgroundColor: AppColors.statusCancelled,
                              ),
                            );
                          }
                        }
                      }
                    : null,
              );
            },
          );
        }),
      ),
    );
  }
}

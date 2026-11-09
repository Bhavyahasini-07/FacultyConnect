import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/appointment.dart';
import '../../../providers/app_state_provider.dart';
import '../../../widgets/common/stat_card.dart';
import '../../notifications/notifications_screen.dart';
import '../../student/appointments/appointment_details_screen.dart';

class FacultyDashboardScreen extends StatelessWidget {
  final ValueChanged<int> onNavigateTab;

  const FacultyDashboardScreen({super.key, required this.onNavigateTab});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppStateProvider>();
    final faculty = appState.currentFaculty;
    final unreadCount = appState.unreadNotificationsCount(UserRole.faculty);
    final totalRequests = appState.facultyAppointments.length;
    final pendingCount = appState.facultyPendingRequests.length;
    final approvedCount = appState.facultyApprovedAppointments.length;
    final completedCount = appState.facultyCompletedAppointments.length;
    final todayAppointments = appState.facultyTodayAppointments;

    // Analytics calculations
    final decidedTotal = approvedCount + completedCount + (totalRequests - pendingCount - approvedCount - completedCount);
    final acceptanceRate = decidedTotal > 0
        ? (((approvedCount + completedCount) / totalRequests) * 100).toInt()
        : 88;

    final todayFormatted = DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now());

    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Navy Blue Gradient Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                decoration: const BoxDecoration(
                  gradient: AppColors.headerGradient,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Bar: Faculty Avatar + Details + Notifications
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                                gradient: AppColors.primaryGradient,
                              ),
                              child: ClipOval(
                                child: Image.network(
                                  faculty.avatarUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Center(
                                    child: Text(
                                      faculty.name.split(' ').map((n) => n.isNotEmpty ? n[0] : '').take(2).join(),
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  faculty.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 17.5,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${faculty.designation} • ${faculty.department.split(" ").first}',
                                  style: TextStyle(
                                    color: AppColors.lightBlue.withValues(alpha: 0.9),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        // Notifications
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            IconButton(
                              icon: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                                ),
                                child: const Icon(
                                  Icons.notifications_none_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const NotificationsScreen(),
                                  ),
                                );
                              },
                            ),
                            if (unreadCount > 0)
                              Positioned(
                                top: 6,
                                right: 6,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: AppColors.statusRejected,
                                    shape: BoxShape.circle,
                                  ),
                                  constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                                  child: Text(
                                    '$unreadCount',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    // Today's date pill
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.calendar_today_rounded, size: 14, color: AppColors.skyBlue),
                          const SizedBox(width: 8),
                          Text(
                            todayFormatted,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 2. Statistics Grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Request Statistics',
                      style: TextStyle(
                        color: AppColors.primaryText,
                        fontSize: 16.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: StatCard(
                            title: 'Total Requests',
                            value: '$totalRequests',
                            icon: Icons.assignment_rounded,
                            onTap: () => onNavigateTab(1),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: StatCard(
                            title: 'Pending Action',
                            value: '$pendingCount',
                            icon: Icons.pending_actions_rounded,
                            iconColor: AppColors.statusPending,
                            iconBgColor: AppColors.statusPendingBg,
                            onTap: () => onNavigateTab(1),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: StatCard(
                            title: 'Approved',
                            value: '$approvedCount',
                            icon: Icons.check_circle_rounded,
                            iconColor: AppColors.statusApproved,
                            iconBgColor: AppColors.statusApprovedBg,
                            onTap: () => onNavigateTab(2),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: StatCard(
                            title: 'Completed',
                            value: '$completedCount',
                            icon: Icons.task_alt_rounded,
                            iconColor: AppColors.secondaryBlue,
                            iconBgColor: AppColors.veryLightBlue,
                            onTap: () => onNavigateTab(2),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 3. Visual Analytics Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Consultation Analytics',
                            style: TextStyle(
                              color: AppColors.primaryText,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.statusApprovedBg,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '$acceptanceRate% Acceptance',
                              style: const TextStyle(
                                color: AppColors.statusApproved,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      // Progress Bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: totalRequests > 0 ? (approvedCount + completedCount) / totalRequests : 0.75,
                          minHeight: 10,
                          backgroundColor: AppColors.veryLightBlue,
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryRoyalBlue),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildLegendDot(AppColors.primaryRoyalBlue, 'Approved ($approvedCount)'),
                          _buildLegendDot(AppColors.statusPending, 'Pending ($pendingCount)'),
                          _buildLegendDot(AppColors.secondaryBlue, 'Completed ($completedCount)'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 4. Quick Actions Row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildQuickActionBtn(
                        title: 'Review Requests',
                        icon: Icons.rule_rounded,
                        count: pendingCount,
                        onTap: () => onNavigateTab(1),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildQuickActionBtn(
                        title: 'Edit Availability',
                        icon: Icons.edit_calendar_rounded,
                        onTap: () => onNavigateTab(3),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 5. Today's Consultation Schedule
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Today\'s Appointments',
                      style: TextStyle(
                        color: AppColors.primaryText,
                        fontSize: 16.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextButton(
                      onPressed: () => onNavigateTab(2),
                      child: const Text(
                        'Full Schedule',
                        style: TextStyle(color: AppColors.primaryRoyalBlue, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: todayAppointments.isNotEmpty
                    ? Column(
                        children: todayAppointments.map((apt) {
                          return _buildTodayAppointmentTile(context, apt);
                        }).toList(),
                      )
                    : Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: AppColors.borderColor),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: const BoxDecoration(
                                color: AppColors.veryLightBlue,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.event_available_rounded, color: AppColors.primaryRoyalBlue),
                            ),
                            const SizedBox(width: 14),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'No Appointments Scheduled for Today',
                                    style: TextStyle(
                                      color: AppColors.primaryText,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Check the Requests tab to confirm incoming student requests.',
                                    style: TextStyle(color: AppColors.secondaryText, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegendDot(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          text,
          style: const TextStyle(color: AppColors.secondaryText, fontSize: 11, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildQuickActionBtn({
    required String title,
    required IconData icon,
    int? count,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.veryLightBlue,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.primaryRoyalBlue),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: AppColors.primaryText,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            if (count != null && count > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.statusPending,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$count',
                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayAppointmentTile(BuildContext context, Appointment apt) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: AppColors.veryLightBlue,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.school_rounded, color: AppColors.primaryRoyalBlue, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  apt.studentName,
                  style: const TextStyle(
                    color: AppColors.primaryText,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${apt.timeSlot} • ${apt.appointmentType}',
                  style: const TextStyle(color: AppColors.secondaryText, fontSize: 12),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.primaryRoyalBlue),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AppointmentDetailsScreen(appointment: apt),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

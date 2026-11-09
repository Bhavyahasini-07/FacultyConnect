import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/appointment.dart';
import '../../../providers/app_state_provider.dart';
import '../../../widgets/common/stat_card.dart';
import '../../notifications/notifications_screen.dart';
import '../appointments/appointment_details_screen.dart';
import '../faculty_profile/faculty_profile_screen.dart';

class StudentDashboardTab extends StatelessWidget {
  final ValueChanged<int> onNavigateTab;

  const StudentDashboardTab({super.key, required this.onNavigateTab});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppStateProvider>();
    final student = appState.currentStudent;
    final unreadCount = appState.unreadNotificationsCount(UserRole.student);
    final upcomingList = appState.studentUpcomingAppointments;
    final recentlyViewed = appState.recentlyViewedFaculty;

    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Navy-to-Royal-Blue Gradient Header
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
                    // Top Bar: Student Avatar + Greeting + Notifications
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                                gradient: AppColors.accentGradient,
                              ),
                              child: ClipOval(
                                child: Image.network(
                                  student.avatarUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => const Center(
                                    child: Text(
                                      'BH',
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hello, ${student.name.split(" ").first} 👋',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Roll No: ${student.rollNumber} • ${student.year}',
                                  style: TextStyle(
                                    color: AppColors.lightBlue.withValues(alpha: 0.9),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        // Notification Icon with Badge
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
                    const SizedBox(height: 20),
                    // Quick Search Bar leading directly to Explore Tab
                    InkWell(
                      onTap: () => onNavigateTab(1), // Navigate to Explore Tab
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.search_rounded, color: AppColors.primaryRoyalBlue, size: 22),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Find professors, departments, subjects...',
                                style: TextStyle(color: AppColors.mutedText, fontSize: 13.5),
                              ),
                            ),
                            Icon(Icons.tune_rounded, color: AppColors.secondaryText, size: 18),
                          ],
                        ),
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
                      'Consultation Summary',
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
                            title: 'Total Booked',
                            value: '${appState.studentAppointments.length}',
                            icon: Icons.calendar_month_rounded,
                            onTap: () => onNavigateTab(2),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: StatCard(
                            title: 'Pending',
                            value: '${appState.studentPendingAppointments.length}',
                            icon: Icons.hourglass_top_rounded,
                            iconColor: AppColors.statusPending,
                            iconBgColor: AppColors.statusPendingBg,
                            onTap: () => onNavigateTab(2),
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
                            value: '${appState.studentUpcomingAppointments.length}',
                            icon: Icons.check_circle_outline_rounded,
                            iconColor: AppColors.statusApproved,
                            iconBgColor: AppColors.statusApprovedBg,
                            onTap: () => onNavigateTab(2),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: StatCard(
                            title: 'Completed',
                            value: '${appState.studentCompletedAppointments.length}',
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

              // 3. Quick Action Banner
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryRoyalBlue.withValues(alpha: 0.25),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Need Academic Guidance?',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Book a slot with your department supervisor or domain mentor in seconds.',
                              style: TextStyle(
                                color: AppColors.lightBlue.withValues(alpha: 0.9),
                                fontSize: 12.5,
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () => onNavigateTab(1), // Go to directory
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primaryRoyalBlue,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.add_rounded, size: 16),
                            SizedBox(width: 4),
                            Text('Book Now', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 4. Upcoming Appointment Preview
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Upcoming Appointment',
                      style: TextStyle(
                        color: AppColors.primaryText,
                        fontSize: 16.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextButton(
                      onPressed: () => onNavigateTab(2),
                      child: const Text(
                        'View All',
                        style: TextStyle(color: AppColors.primaryRoyalBlue, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: upcomingList.isNotEmpty
                    ? _buildUpcomingCard(context, upcomingList.first)
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
                                    'No Approved Consultations Today',
                                    style: TextStyle(
                                      color: AppColors.primaryText,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Schedule a meeting with faculty to discuss queries or project reviews.',
                                    style: TextStyle(color: AppColors.secondaryText, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
              const SizedBox(height: 24),

              // 5. Recently Viewed / Featured Faculty
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Recently Viewed Faculty',
                      style: TextStyle(
                        color: AppColors.primaryText,
                        fontSize: 16.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextButton(
                      onPressed: () => onNavigateTab(1),
                      child: const Text(
                        'Explore More',
                        style: TextStyle(color: AppColors.primaryRoyalBlue, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 196,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  itemCount: recentlyViewed.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 14),
                  itemBuilder: (context, index) {
                    final faculty = recentlyViewed[index];
                    return _buildRecentFacultyCard(context, faculty);
                  },
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUpcomingCard(BuildContext context, Appointment apt) {
    final dateFormat = DateFormat('EEE, MMM d');
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderColor, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryRoyalBlue.withValues(alpha: 0.06),
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.statusApprovedBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_rounded, size: 13, color: AppColors.statusApproved),
                    const SizedBox(width: 4),
                    Text(
                      'Confirmed Slot',
                      style: const TextStyle(
                        color: AppColors.statusApproved,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                apt.id,
                style: const TextStyle(
                  color: AppColors.secondaryText,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            apt.facultyName,
            style: const TextStyle(
              color: AppColors.primaryText,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${apt.facultyDepartment} • ${apt.facultyOffice}',
            style: const TextStyle(color: AppColors.secondaryText, fontSize: 12.5),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.veryLightBlue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.event_rounded, size: 15, color: AppColors.primaryRoyalBlue),
                const SizedBox(width: 6),
                Text(
                  dateFormat.format(apt.date),
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12.5),
                ),
                const SizedBox(width: 14),
                const Icon(Icons.schedule_rounded, size: 15, color: AppColors.primaryRoyalBlue),
                const SizedBox(width: 6),
                Text(
                  apt.timeSlot,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AppointmentDetailsScreen(appointment: apt),
                    ),
                  );
                },
                child: const Row(
                  children: [
                    Text('View Details', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_forward_ios_rounded, size: 12),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentFacultyCard(BuildContext context, dynamic faculty) {
    return Container(
      width: 170,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderColor),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryRoyalBlue.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: AppColors.primaryGradient,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
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
          const SizedBox(height: 10),
          Text(
            faculty.name,
            style: const TextStyle(
              color: AppColors.primaryText,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            faculty.department.split(' ').first,
            style: const TextStyle(color: AppColors.secondaryText, fontSize: 11),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 32,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FacultyProfileScreen(faculty: faculty),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.veryLightBlue,
                foregroundColor: AppColors.primaryRoyalBlue,
                padding: EdgeInsets.zero,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('View', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}

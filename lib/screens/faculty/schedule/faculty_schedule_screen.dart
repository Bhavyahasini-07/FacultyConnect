import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/appointment.dart';
import '../../../providers/app_state_provider.dart';
import '../../../widgets/common/empty_state_view.dart';
import '../../../widgets/common/status_badge.dart';
import '../../student/appointments/appointment_details_screen.dart';

class FacultyScheduleScreen extends StatefulWidget {
  const FacultyScheduleScreen({super.key});

  @override
  State<FacultyScheduleScreen> createState() => _FacultyScheduleScreenState();
}

class _FacultyScheduleScreenState extends State<FacultyScheduleScreen> {
  String _viewMode = 'Daily'; // Daily, Weekly, Monthly
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDay = DateTime(now.year, now.month, now.day);
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppStateProvider>();
    final faculty = appState.currentFaculty;
    final allFacultyApts = appState.facultyAppointments;

    // Filter appointments according to selected view mode & day
    final filteredAppointments = allFacultyApts.where((apt) {
      if (_viewMode == 'Daily') {
        return apt.date.year == _selectedDay.year &&
            apt.date.month == _selectedDay.month &&
            apt.date.day == _selectedDay.day;
      } else if (_viewMode == 'Weekly') {
        final diff = apt.date.difference(_selectedDay).inDays;
        return diff >= -3 && diff <= 3;
      } else {
        // Monthly
        return apt.date.year == _selectedDay.year && apt.date.month == _selectedDay.month;
      }
    }).toList()
      ..sort((a, b) => a.timeSlot.compareTo(b.timeSlot));

    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      appBar: AppBar(
        title: const Text('Faculty Schedule'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // View Mode Selector Segmented Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: AppColors.white,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.veryLightBlue,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: ['Daily', 'Weekly', 'Monthly'].map((mode) {
                        final isSelected = _viewMode == mode;
                        return Expanded(
                          child: InkWell(
                            onTap: () => setState(() => _viewMode = mode),
                            borderRadius: BorderRadius.circular(10),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.primaryRoyalBlue : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                mode,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : AppColors.primaryText,
                                  fontSize: 13,
                                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Date Navigator Strip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: const BoxDecoration(
              color: AppColors.white,
              border: Border(bottom: BorderSide(color: AppColors.borderColor)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left_rounded, color: AppColors.primaryRoyalBlue),
                  onPressed: () {
                    setState(() {
                      if (_viewMode == 'Daily') {
                        _selectedDay = _selectedDay.subtract(const Duration(days: 1));
                      } else if (_viewMode == 'Weekly') {
                        _selectedDay = _selectedDay.subtract(const Duration(days: 7));
                      } else {
                        _selectedDay = DateTime(_selectedDay.year, _selectedDay.month - 1, 1);
                      }
                    });
                  },
                ),
                Text(
                  _formatDateHeader(_selectedDay, _viewMode),
                  style: const TextStyle(
                    color: AppColors.primaryText,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right_rounded, color: AppColors.primaryRoyalBlue),
                  onPressed: () {
                    setState(() {
                      if (_viewMode == 'Daily') {
                        _selectedDay = _selectedDay.add(const Duration(days: 1));
                      } else if (_viewMode == 'Weekly') {
                        _selectedDay = _selectedDay.add(const Duration(days: 7));
                      } else {
                        _selectedDay = DateTime(_selectedDay.year, _selectedDay.month + 1, 1);
                      }
                    });
                  },
                ),
              ],
            ),
          ),

          // Schedule Time Slot Visualizer
          Expanded(
            child: filteredAppointments.isEmpty
                ? EmptyStateView(
                    icon: Icons.event_note_rounded,
                    title: 'No Appointments Scheduled',
                    message: 'There are no consultations scheduled for this period.',
                    buttonText: 'Jump to Today',
                    onButtonPressed: () {
                      final now = DateTime.now();
                      setState(() {
                        _selectedDay = DateTime(now.year, now.month, now.day);
                      });
                    },
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredAppointments.length,
                    itemBuilder: (context, index) {
                      final apt = filteredAppointments[index];
                      return _buildScheduleItemCard(context, apt, faculty.officeLocation);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleItemCard(BuildContext context, Appointment apt, String defaultOffice) {
    Color indicatorColor;
    switch (apt.status) {
      case AppointmentStatus.approved:
        indicatorColor = AppColors.statusApproved;
        break;
      case AppointmentStatus.pending:
        indicatorColor = AppColors.statusPending;
        break;
      case AppointmentStatus.completed:
        indicatorColor = AppColors.secondaryBlue;
        break;
      case AppointmentStatus.rejected:
        indicatorColor = AppColors.statusRejected;
        break;
      case AppointmentStatus.cancelled:
        indicatorColor = AppColors.statusCancelled;
        break;
    }

    final dateStr = DateFormat('EEE, MMM d').format(apt.date);

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AppointmentDetailsScreen(appointment: apt),
          ),
        );
      },
      borderRadius: BorderRadius.circular(18),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.borderColor, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryRoyalBlue.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Color-coded status edge indicator
              Container(
                width: 6,
                decoration: BoxDecoration(
                  color: indicatorColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(18),
                    bottomLeft: Radius.circular(18),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.access_time_rounded, size: 15, color: AppColors.primaryRoyalBlue),
                              const SizedBox(width: 6),
                              Text(
                                apt.timeSlot,
                                style: const TextStyle(
                                  color: AppColors.primaryRoyalBlue,
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          StatusBadge(status: apt.status),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        apt.studentName,
                        style: const TextStyle(
                          color: AppColors.primaryText,
                          fontSize: 15.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Roll: ${apt.studentRollNumber} • ${apt.studentDepartment}',
                        style: const TextStyle(
                          color: AppColors.secondaryText,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.veryLightBlue,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '$dateStr • ${apt.appointmentType}: "${apt.purpose}"',
                          style: const TextStyle(
                            color: AppColors.primaryText,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDateHeader(DateTime date, String mode) {
    if (mode == 'Daily') {
      return DateFormat('EEEE, MMMM d, yyyy').format(date);
    } else if (mode == 'Weekly') {
      final start = date.subtract(const Duration(days: 3));
      final end = date.add(const Duration(days: 3));
      return '${DateFormat("MMM d").format(start)} – ${DateFormat("MMM d, yyyy").format(end)}';
    } else {
      return DateFormat('MMMM yyyy').format(date);
    }
  }
}

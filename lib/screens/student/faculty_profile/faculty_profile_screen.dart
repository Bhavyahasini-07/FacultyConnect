import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/faculty.dart';
import '../../../providers/app_state_provider.dart';
import '../../../widgets/common/custom_app_bar.dart';
import '../../../widgets/common/primary_button.dart';
import '../booking/appointment_booking_screen.dart';

class FacultyProfileScreen extends StatefulWidget {
  final Faculty faculty;

  const FacultyProfileScreen({super.key, required this.faculty});

  @override
  State<FacultyProfileScreen> createState() => _FacultyProfileScreenState();
}

class _FacultyProfileScreenState extends State<FacultyProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Record view in recently viewed faculty
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<AppStateProvider>().recordFacultyView(widget.faculty);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppStateProvider>();
    final liveFaculty = appState.facultyList.firstWhere(
      (f) => f.id == widget.faculty.id,
      orElse: () => widget.faculty,
    );

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Faculty Profile',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Profile Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.borderColor, width: 1.2),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryRoyalBlue.withValues(alpha: 0.06),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Avatar
                      Stack(
                        children: [
                          Container(
                            width: 76,
                            height: 76,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: AppColors.primaryGradient,
                              border: Border.all(color: AppColors.borderColor, width: 2),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: Image.network(
                                liveFaculty.avatarUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Center(
                                  child: Text(
                                    liveFaculty.name.split(' ').map((n) => n.isNotEmpty ? n[0] : '').take(2).join(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 18,
                              height: 18,
                              decoration: BoxDecoration(
                                color: liveFaculty.isAvailableNow ? AppColors.statusApproved : AppColors.statusCancelled,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2.5),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      // Core Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              liveFaculty.name,
                              style: const TextStyle(
                                color: AppColors.primaryText,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              liveFaculty.designation,
                              style: const TextStyle(
                                color: AppColors.primaryRoyalBlue,
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              liveFaculty.department,
                              style: const TextStyle(
                                color: AppColors.secondaryText,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.star_rounded, size: 17, color: Color(0xFFF59E0B)),
                                const SizedBox(width: 3),
                                Text(
                                  '${liveFaculty.rating.toStringAsFixed(1)} (${liveFaculty.totalReviews} consultations)',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12.5,
                                    color: AppColors.primaryText,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  const Divider(height: 1, color: AppColors.borderColor),
                  const SizedBox(height: 14),
                  // Quick Info Grid
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildQuickBadge(Icons.workspace_premium_outlined, liveFaculty.experience),
                      _buildQuickBadge(Icons.school_outlined, 'Ph.D. Qualified'),
                      _buildQuickBadge(
                        Icons.access_time_rounded,
                        liveFaculty.isAvailableNow ? 'Available Today' : 'Scheduled',
                        isGreen: liveFaculty.isAvailableNow,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // About Section
            _buildSectionHeader('About Faculty', Icons.info_outline_rounded),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.borderColor),
              ),
              child: Text(
                liveFaculty.about,
                style: const TextStyle(
                  color: AppColors.primaryText,
                  fontSize: 13.5,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Qualifications & Office Details
            _buildSectionHeader('Academic & Office Details', Icons.meeting_room_outlined),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.borderColor),
              ),
              child: Column(
                children: [
                  _buildDetailRow('Qualification', liveFaculty.qualification),
                  _buildDetailRow('Office Location', liveFaculty.officeLocation),
                  _buildDetailRow('Official Office Hours', liveFaculty.officeHours),
                  _buildDetailRow('Official Email', liveFaculty.email),
                  _buildDetailRow('Contact Extension', liveFaculty.phone),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Areas of Expertise
            _buildSectionHeader('Areas of Expertise', Icons.psychology_outlined),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: liveFaculty.areasOfExpertise.map((skill) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: AppColors.veryLightBlue,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.borderColor),
                  ),
                  child: Text(
                    skill,
                    style: const TextStyle(
                      color: AppColors.primaryRoyalBlue,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Weekly Availability & Slots
            _buildSectionHeader('Weekly Schedule & Time Slots', Icons.event_available_rounded),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded, size: 16, color: AppColors.primaryRoyalBlue),
                      const SizedBox(width: 8),
                      Text(
                        'Working Days: ${liveFaculty.workingDays.join(", ")}',
                        style: const TextStyle(
                          color: AppColors.primaryText,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.schedule_rounded, size: 16, color: AppColors.primaryRoyalBlue),
                      const SizedBox(width: 8),
                      Text(
                        'Consultation Window: ${liveFaculty.openingTime} - ${liveFaculty.closingTime}',
                        style: const TextStyle(
                          color: AppColors.primaryText,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Divider(height: 1, color: AppColors.borderColor),
                  const SizedBox(height: 12),
                  const Text(
                    'Regular Active Slots:',
                    style: TextStyle(
                      color: AppColors.secondaryText,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: liveFaculty.availableSlots.map((slot) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.mainBackground,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.borderColor),
                        ),
                        child: Text(
                          slot,
                          style: const TextStyle(
                            color: AppColors.primaryText,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Prominent Book Appointment CTA Button
            PrimaryButton(
              text: 'Book Appointment with ${liveFaculty.name.split(" ").last}',
              icon: Icons.calendar_month_rounded,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AppointmentBookingScreen(faculty: liveFaculty),
                  ),
                );
              },
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
            fontSize: 15.5,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickBadge(IconData icon, String text, {bool isGreen = false}) {
    return Column(
      children: [
        Icon(icon, size: 18, color: isGreen ? AppColors.statusApproved : AppColors.primaryRoyalBlue),
        const SizedBox(height: 4),
        Text(
          text,
          style: TextStyle(
            color: isGreen ? AppColors.statusApproved : AppColors.primaryText,
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: AppColors.secondaryText, fontSize: 13),
          ),
          const SizedBox(width: 14),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: AppColors.primaryText,
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

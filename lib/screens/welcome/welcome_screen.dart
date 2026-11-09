import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/app_state_provider.dart';
import '../student/student_main_screen.dart';
import '../faculty/faculty_main_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  void _selectRole(BuildContext context, UserRole role) {
    final provider = context.read<AppStateProvider>();
    provider.setRole(role);

    if (role == UserRole.student) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const StudentMainScreen()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const FacultyMainScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
            ),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 12),
                    // Header Brand
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.veryLightBlue,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.borderColor),
                          ),
                          child: const Icon(
                            Icons.school_rounded,
                            size: 24,
                            color: AppColors.primaryRoyalBlue,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'FacultyConnect',
                          style: TextStyle(
                            color: AppColors.deepNavyBlue,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    // Illustration / Academic Art Card
                    Container(
                      padding: const EdgeInsets.all(26),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryRoyalBlue.withValues(alpha: 0.25),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Academic Graphic Icons Grid
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildGraphicIcon(Icons.calendar_month_rounded, 'Smart Booking'),
                              _buildGraphicIcon(Icons.person_pin_rounded, 'Verified Faculty'),
                              _buildGraphicIcon(Icons.schedule_rounded, 'Live Slots'),
                            ],
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Seamless Academic Consultations',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Book one-on-one appointments with distinguished professors, get thesis mentoring, resolve doubts, and track schedules effortlessly.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.lightBlue.withValues(alpha: 0.9),
                              fontSize: 13,
                              height: 1.45,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Selection Title
                    const Text(
                      'Choose Your Role',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.primaryText,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Select how you want to interact with the system. You can switch roles anytime from your profile.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.secondaryText,
                        fontSize: 13.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Student Card Button
                    _buildRoleCard(
                      title: 'Continue as Student',
                      subtitle: 'Explore faculty, book time slots, and manage academic requests',
                      icon: Icons.school_outlined,
                      badgeText: 'Student Portal',
                      badgeColor: AppColors.primaryRoyalBlue,
                      onTap: () => _selectRole(context, UserRole.student),
                      isPrimary: true,
                    ),
                    const SizedBox(height: 14),
                    // Faculty Card Button
                    _buildRoleCard(
                      title: 'Continue as Faculty',
                      subtitle: 'Review incoming requests, manage schedule & office availability',
                      icon: Icons.co_present_rounded,
                      badgeText: 'Faculty Portal',
                      badgeColor: AppColors.secondaryBlue,
                      onTap: () => _selectRole(context, UserRole.faculty),
                      isPrimary: false,
                    ),
                    const Spacer(),
                    const SizedBox(height: 20),
                    // Footer Info
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.verified_user_outlined, size: 14, color: AppColors.secondaryText),
                        const SizedBox(width: 6),
                        Text(
                          'Front-End Academic Demonstration • Local State',
                          style: TextStyle(
                            color: AppColors.secondaryText.withValues(alpha: 0.8),
                            fontSize: 11.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGraphicIcon(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
          ),
          child: Icon(icon, size: 24, color: Colors.white),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildRoleCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required String badgeText,
    required Color badgeColor,
    required VoidCallback onTap,
    required bool isPrimary,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isPrimary ? AppColors.primaryRoyalBlue.withValues(alpha: 0.4) : AppColors.borderColor,
          width: isPrimary ? 1.6 : 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: (isPrimary ? AppColors.primaryRoyalBlue : Colors.black).withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isPrimary ? AppColors.primaryRoyalBlue : AppColors.veryLightBlue,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    icon,
                    size: 26,
                    color: isPrimary ? Colors.white : AppColors.primaryRoyalBlue,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              title,
                              style: const TextStyle(
                                color: AppColors.primaryText,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.veryLightBlue,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              badgeText,
                              style: TextStyle(
                                color: badgeColor,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: AppColors.secondaryText,
                          fontSize: 12.5,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 15,
                  color: AppColors.secondaryText,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

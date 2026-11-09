import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../providers/app_state_provider.dart';
import '../../faculty/faculty_main_screen.dart';
import '../../welcome/welcome_screen.dart';
import '../../../widgets/common/confirm_dialog.dart';
import '../../../widgets/common/secondary_button.dart';

class StudentProfileTab extends StatefulWidget {
  const StudentProfileTab({super.key});

  @override
  State<StudentProfileTab> createState() => _StudentProfileTabState();
}

class _StudentProfileTabState extends State<StudentProfileTab> {
  bool _emailAlerts = true;
  bool _appReminders = true;
  bool _statusUpdates = true;

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppStateProvider>();
    final student = appState.currentStudent;

    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      appBar: AppBar(
        title: const Text('Student Profile'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile Card Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: AppColors.borderColor, width: 1.2),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryRoyalBlue.withValues(alpha: 0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 84,
                        height: 84,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.primaryRoyalBlue, width: 2.5),
                          gradient: AppColors.primaryGradient,
                        ),
                        child: ClipOval(
                          child: Image.network(
                            student.avatarUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => const Center(
                              child: Text(
                                'BH',
                                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            color: AppColors.primaryRoyalBlue,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.school_rounded, color: Colors.white, size: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    student.name,
                    style: const TextStyle(
                      color: AppColors.primaryText,
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.veryLightBlue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Roll No: ${student.rollNumber}',
                      style: const TextStyle(
                        color: AppColors.primaryRoyalBlue,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${student.department} • ${student.year}',
                    style: const TextStyle(
                      color: AppColors.secondaryText,
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () => _showEditProfileDialog(context, appState),
                    icon: const Icon(Icons.edit_outlined, size: 16),
                    label: const Text('Edit Profile Details'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryRoyalBlue,
                      side: const BorderSide(color: AppColors.borderColor),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Role Switcher Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: AppColors.cardGradient,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.borderColor, width: 1.2),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryRoyalBlue,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.swap_horiz_rounded, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Switch to Faculty Mode',
                          style: TextStyle(
                            color: AppColors.primaryText,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Experience appointment reviews and schedule management',
                          style: TextStyle(color: AppColors.secondaryText, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      appState.setRole(UserRole.faculty);
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const FacultyMainScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryRoyalBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: const Text('Switch', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Academic & Contact Information
            _buildSectionCard(
              title: 'Academic & Contact Info',
              icon: Icons.contact_page_outlined,
              children: [
                _buildInfoRow('Full Name', student.name),
                _buildInfoRow('Roll Number', student.rollNumber),
                _buildInfoRow('Email Address', student.email),
                _buildInfoRow('Contact Number', student.phone),
                _buildInfoRow('Department', student.department),
                _buildInfoRow('Academic Year', student.year),
              ],
            ),
            const SizedBox(height: 18),

            // Preferences
            _buildSectionCard(
              title: 'Notification Preferences',
              icon: Icons.notifications_active_outlined,
              children: [
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Status Updates', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  subtitle: const Text('Instant alerts when faculty accepts or declines', style: TextStyle(fontSize: 12)),
                  value: _statusUpdates,
                  activeThumbColor: AppColors.primaryRoyalBlue,
                  onChanged: (val) => setState(() => _statusUpdates = val),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Upcoming Slot Reminders', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  subtitle: const Text('Reminders 2 hours before confirmed appointment', style: TextStyle(fontSize: 12)),
                  value: _appReminders,
                  activeThumbColor: AppColors.primaryRoyalBlue,
                  onChanged: (val) => setState(() => _appReminders = val),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Institutional Email Digest', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  subtitle: const Text('Daily summary of upcoming consultations', style: TextStyle(fontSize: 12)),
                  value: _emailAlerts,
                  activeThumbColor: AppColors.primaryRoyalBlue,
                  onChanged: (val) => setState(() => _emailAlerts = val),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Support & About options
            _buildSectionCard(
              title: 'System & Support',
              icon: Icons.settings_suggest_outlined,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.help_center_outlined, color: AppColors.primaryRoyalBlue),
                  title: const Text('Help & Support', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  subtitle: const Text('User guides, FAQ, and campus IT helpline', style: TextStyle(fontSize: 12)),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.secondaryText),
                  onTap: () => _showHelpDialog(context),
                ),
                const Divider(height: 1, color: AppColors.borderColor),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.info_outline_rounded, color: AppColors.primaryRoyalBlue),
                  title: const Text('About FacultyConnect', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  subtitle: const Text('Version 1.0.0 • Academic Demonstration', style: TextStyle(fontSize: 12)),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.secondaryText),
                  onTap: () => _showAboutDialog(context),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Logout / Sign Out
            SecondaryButton(
              text: 'Log Out / Change User',
              icon: Icons.logout_rounded,
              textColor: AppColors.statusRejected,
              onPressed: () async {
                final result = await ConfirmDialog.show(
                  context: context,
                  title: 'Log Out?',
                  message: 'Are you sure you want to log out and return to the welcome screen?',
                  confirmText: 'Log Out',
                  confirmColor: AppColors.statusRejected,
                  icon: Icons.logout_rounded,
                );
                if (result != null && result['confirmed'] == true && context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                    (route) => false,
                  );
                }
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderColor, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.secondaryText, fontSize: 13)),
          Text(
            value,
            style: const TextStyle(color: AppColors.primaryText, fontSize: 13.5, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context, AppStateProvider appState) {
    final s = appState.currentStudent;
    final nameCtrl = TextEditingController(text: s.name);
    final rollCtrl = TextEditingController(text: s.rollNumber);
    final deptCtrl = TextEditingController(text: s.department);
    final yearCtrl = TextEditingController(text: s.year);
    final emailCtrl = TextEditingController(text: s.email);
    final phoneCtrl = TextEditingController(text: s.phone);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: const Text('Edit Student Profile', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Student Name'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: rollCtrl,
                decoration: const InputDecoration(labelText: 'Roll Number'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: deptCtrl,
                decoration: const InputDecoration(labelText: 'Department'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: yearCtrl,
                decoration: const InputDecoration(labelText: 'Academic Year'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: emailCtrl,
                decoration: const InputDecoration(labelText: 'Email Address'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: phoneCtrl,
                decoration: const InputDecoration(labelText: 'Contact Phone'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryRoyalBlue,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              appState.updateStudentProfile(
                name: nameCtrl.text.trim(),
                rollNumber: rollCtrl.text.trim(),
                department: deptCtrl.text.trim(),
                year: yearCtrl.text.trim(),
                email: emailCtrl.text.trim(),
                phone: phoneCtrl.text.trim(),
              );
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Profile updated successfully!'),
                  backgroundColor: AppColors.statusApproved,
                ),
              );
            },
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: const Row(
          children: [
            Icon(Icons.help_outline_rounded, color: AppColors.primaryRoyalBlue),
            SizedBox(width: 8),
            Text('Help & Support', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17)),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'How to book an appointment?',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            ),
            SizedBox(height: 4),
            Text(
              '1. Explore faculty by department or search.\n2. Tap "Book Slot" on their profile card.\n3. Pick an active working date and time slot.\n4. Enter discussion purpose and confirm.',
              style: TextStyle(fontSize: 13, height: 1.4, color: AppColors.secondaryText),
            ),
            SizedBox(height: 12),
            Text(
              'Campus Support Helpline:',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            ),
            SizedBox(height: 4),
            Text(
              'Email: facultyconnect-support@college.edu\nPhone: Ext 4022 (Mon - Fri, 9 AM - 5 PM)',
              style: TextStyle(fontSize: 13, height: 1.4, color: AppColors.secondaryText),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryRoyalBlue,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: const Row(
          children: [
            Icon(Icons.school_rounded, color: AppColors.primaryRoyalBlue),
            SizedBox(width: 8),
            Text('About FacultyConnect', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17)),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'FacultyConnect – Faculty Appointment Booking System',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.primaryRoyalBlue),
            ),
            SizedBox(height: 6),
            Text(
              'A complete mobile frontend system designed to streamline student-faculty academic consultations, project reviews, and office hours.',
              style: TextStyle(fontSize: 13, height: 1.4, color: AppColors.secondaryText),
            ),
            SizedBox(height: 10),
            Text(
              'Technology: Flutter, Material Design 3, Provider State Management, Google Fonts.',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.primaryText),
            ),
            SizedBox(height: 6),
            Text(
              'Demonstration Mode: Front-End UI/UX with shared in-memory repository.',
              style: TextStyle(fontSize: 12, color: AppColors.secondaryText),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryRoyalBlue,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

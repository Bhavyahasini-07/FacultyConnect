import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../providers/app_state_provider.dart';
import '../../student/student_main_screen.dart';
import '../../welcome/welcome_screen.dart';
import '../../../widgets/common/confirm_dialog.dart';
import '../../../widgets/common/secondary_button.dart';

class FacultyProfileViewScreen extends StatelessWidget {
  const FacultyProfileViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppStateProvider>();
    final faculty = appState.currentFaculty;

    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      appBar: AppBar(
        title: const Text('Faculty Profile'),
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
                            faculty.avatarUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Center(
                              child: Text(
                                faculty.name.split(' ').map((n) => n.isNotEmpty ? n[0] : '').take(2).join(),
                                style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
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
                          child: const Icon(Icons.verified_rounded, color: Colors.white, size: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    faculty.name,
                    style: const TextStyle(
                      color: AppColors.primaryText,
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    faculty.designation,
                    style: const TextStyle(
                      color: AppColors.primaryRoyalBlue,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    faculty.department,
                    style: const TextStyle(
                      color: AppColors.secondaryText,
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () => _showEditFacultyDialog(context, appState),
                    icon: const Icon(Icons.edit_outlined, size: 16),
                    label: const Text('Edit Faculty Details'),
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
                          'Switch to Student Mode',
                          style: TextStyle(
                            color: AppColors.primaryText,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Experience student directory browsing and slot bookings',
                          style: TextStyle(color: AppColors.secondaryText, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      appState.setRole(UserRole.student);
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const StudentMainScreen()),
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

            // Academic & Office Information
            _buildSectionCard(
              title: 'Academic & Office Information',
              icon: Icons.meeting_room_outlined,
              children: [
                _buildInfoRow('Full Name', faculty.name),
                _buildInfoRow('Designation', faculty.designation),
                _buildInfoRow('Department', faculty.department),
                _buildInfoRow('Qualification', faculty.qualification),
                _buildInfoRow('Experience', faculty.experience),
                _buildInfoRow('Office Room', faculty.officeLocation),
                _buildInfoRow('Official Hours', faculty.officeHours),
                _buildInfoRow('Email Address', faculty.email),
                _buildInfoRow('Internal Extension', faculty.phone),
              ],
            ),
            const SizedBox(height: 18),

            // Bio Summary
            _buildSectionCard(
              title: 'Biography & Research Bio',
              icon: Icons.menu_book_outlined,
              children: [
                Text(
                  faculty.about,
                  style: const TextStyle(
                    color: AppColors.primaryText,
                    fontSize: 13.5,
                    height: 1.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Logout
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
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(color: AppColors.primaryText, fontSize: 13.5, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditFacultyDialog(BuildContext context, AppStateProvider appState) {
    final f = appState.currentFaculty;
    final nameCtrl = TextEditingController(text: f.name);
    final desigCtrl = TextEditingController(text: f.designation);
    final qualCtrl = TextEditingController(text: f.qualification);
    final roomCtrl = TextEditingController(text: f.officeLocation);
    final hoursCtrl = TextEditingController(text: f.officeHours);
    final emailCtrl = TextEditingController(text: f.email);
    final phoneCtrl = TextEditingController(text: f.phone);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: const Text('Edit Faculty Profile', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Faculty Name'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: desigCtrl,
                decoration: const InputDecoration(labelText: 'Designation'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: qualCtrl,
                decoration: const InputDecoration(labelText: 'Qualification'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: roomCtrl,
                decoration: const InputDecoration(labelText: 'Office Room'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: hoursCtrl,
                decoration: const InputDecoration(labelText: 'Office Hours'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: emailCtrl,
                decoration: const InputDecoration(labelText: 'Email Address'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: phoneCtrl,
                decoration: const InputDecoration(labelText: 'Contact Extension'),
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
              appState.updateFacultyProfile(
                facultyId: f.id,
                name: nameCtrl.text.trim(),
                designation: desigCtrl.text.trim(),
                department: f.department,
                qualification: qualCtrl.text.trim(),
                experience: f.experience,
                specialization: f.specialization,
                officeLocation: roomCtrl.text.trim(),
                officeHours: hoursCtrl.text.trim(),
                email: emailCtrl.text.trim(),
                phone: phoneCtrl.text.trim(),
                about: f.about,
                areasOfExpertise: f.areasOfExpertise,
              );
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Faculty profile updated successfully!'),
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
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/faculty.dart';
import '../../../providers/app_state_provider.dart';
import '../../../widgets/common/primary_button.dart';
import '../../../widgets/common/secondary_button.dart';
import '../appointments/appointment_details_screen.dart';
import '../student_main_screen.dart';

class BookingSuccessScreen extends StatelessWidget {
  final String appointmentId;
  final Faculty faculty;
  final DateTime date;
  final String timeSlot;
  final String appointmentType;
  final String purpose;

  const BookingSuccessScreen({
    super.key,
    required this.appointmentId,
    required this.faculty,
    required this.date,
    required this.timeSlot,
    required this.appointmentType,
    required this.purpose,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('EEEE, MMMM d, yyyy').format(date);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const StudentMainScreen()),
            (route) => false,
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.mainBackground,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                // Success Animated Graphic Container
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: AppColors.statusApprovedBg,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.statusApproved.withValues(alpha: 0.25),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.check_circle_rounded,
                      size: 58,
                      color: AppColors.statusApproved,
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                const Text(
                  'Appointment Request Submitted!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.primaryText,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.statusPendingBg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.statusPending.withValues(alpha: 0.3)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.hourglass_top_rounded, size: 14, color: AppColors.statusPending),
                      SizedBox(width: 6),
                      Text(
                        'Pending Faculty Confirmation',
                        style: TextStyle(
                          color: AppColors.statusPending,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Your booking request has been forwarded to the faculty member. You will receive an update once they review and confirm the slot.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 13.5,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 28),

                // Booking Summary Card
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
                      // Booking Reference
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'BOOKING ID',
                            style: TextStyle(
                              color: AppColors.secondaryText,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.6,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.veryLightBlue,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              appointmentId,
                              style: const TextStyle(
                                color: AppColors.primaryRoyalBlue,
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(height: 1, color: AppColors.borderColor),
                      const SizedBox(height: 16),
                      _buildRowItem('Faculty', faculty.name, isBold: true),
                      _buildRowItem('Department', faculty.department),
                      _buildRowItem('Office Room', faculty.officeLocation),
                      _buildRowItem('Scheduled Date', formattedDate),
                      _buildRowItem('Time Slot', timeSlot, isAccent: true),
                      _buildRowItem('Consultation Type', appointmentType),
                      _buildRowItem('Agenda', purpose),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Action Buttons
                PrimaryButton(
                  text: 'View Appointment Details',
                  icon: Icons.receipt_long_rounded,
                  onPressed: () {
                    final appState = context.read<AppStateProvider>();
                    final apt = appState.appointments.firstWhere((a) => a.id == appointmentId);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AppointmentDetailsScreen(appointment: apt),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                SecondaryButton(
                  text: 'Return to Dashboard',
                  icon: Icons.home_rounded,
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const StudentMainScreen()),
                      (route) => false,
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRowItem(String label, String value, {bool isBold = false, bool isAccent = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.secondaryText,
              fontSize: 13,
            ),
          ),
          const SizedBox(width: 14),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                color: isAccent ? AppColors.primaryRoyalBlue : AppColors.primaryText,
                fontSize: 13.5,
                fontWeight: isBold || isAccent ? FontWeight.w700 : FontWeight.w500,
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

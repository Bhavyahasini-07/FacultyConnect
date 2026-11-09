import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/faculty.dart';
import '../../../providers/app_state_provider.dart';
import '../../../widgets/common/custom_app_bar.dart';
import '../../../widgets/common/confirm_dialog.dart';
import '../../../widgets/common/primary_button.dart';
import 'booking_success_screen.dart';

class AppointmentBookingScreen extends StatefulWidget {
  final Faculty faculty;

  const AppointmentBookingScreen({super.key, required this.faculty});

  @override
  State<AppointmentBookingScreen> createState() => _AppointmentBookingScreenState();
}

class _AppointmentBookingScreenState extends State<AppointmentBookingScreen> {
  late DateTime _selectedDate;
  String? _selectedTimeSlot;
  String _selectedType = 'Academic Doubt';
  final TextEditingController _purposeController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final List<String> _appointmentTypes = [
    'Academic Doubt',
    'Project Discussion',
    'Career Guidance',
    'Mentorship',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    // Default to tomorrow or next working day
    final now = DateTime.now();
    _selectedDate = DateTime(now.year, now.month, now.day).add(const Duration(days: 1));
  }

  @override
  void dispose() {
    _purposeController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  // Generate the next 14 calendar dates
  List<DateTime> _getAvailableDates() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return List.generate(14, (index) => today.add(Duration(days: index + 1)));
  }

  bool _isDateAvailable(DateTime date, Faculty liveFaculty) {
    // Check if in faculty unavailableDates
    for (final unavail in liveFaculty.unavailableDates) {
      if (unavail.year == date.year && unavail.month == date.month && unavail.day == date.day) {
        return false;
      }
    }
    // Check working days
    final weekdayName = DateFormat('EEEE').format(date);
    return liveFaculty.workingDays.contains(weekdayName);
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppStateProvider>();
    // Get live updated faculty instance
    final liveFaculty = appState.facultyList.firstWhere(
      (f) => f.id == widget.faculty.id,
      orElse: () => widget.faculty,
    );

    final availableDates = _getAvailableDates();
    final isSelectedDateWorkable = _isDateAvailable(_selectedDate, liveFaculty);

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Book Appointment',
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Faculty Summary Card
                Container(
                  padding: const EdgeInsets.all(16),
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
                  child: Row(
                    children: [
                      Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: AppColors.primaryGradient,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            liveFaculty.avatarUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Center(
                              child: Text(
                                liveFaculty.name.split(' ').map((n) => n.isNotEmpty ? n[0] : '').take(2).join(),
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              liveFaculty.name,
                              style: const TextStyle(
                                color: AppColors.primaryText,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              liveFaculty.designation,
                              style: const TextStyle(
                                color: AppColors.primaryRoyalBlue,
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${liveFaculty.department} • ${liveFaculty.officeLocation}',
                              style: const TextStyle(
                                color: AppColors.secondaryText,
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 2. Date Selection Section
                _buildSectionTitle('Select Date', Icons.calendar_month_rounded),
                const SizedBox(height: 4),
                const Text(
                  'Bookings allowed up to 14 days in advance',
                  style: TextStyle(color: AppColors.secondaryText, fontSize: 12.5),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 82,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: availableDates.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final date = availableDates[index];
                      final isSelected = date.year == _selectedDate.year &&
                          date.month == _selectedDate.month &&
                          date.day == _selectedDate.day;
                      final isAvailable = _isDateAvailable(date, liveFaculty);

                      return InkWell(
                        onTap: isAvailable
                            ? () {
                                setState(() {
                                  _selectedDate = date;
                                  _selectedTimeSlot = null; // reset slot selection
                                });
                              }
                            : null,
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          width: 68,
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primaryRoyalBlue
                                : (isAvailable ? AppColors.white : AppColors.mainBackground),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primaryRoyalBlue
                                  : (isAvailable ? AppColors.borderColor : AppColors.dividerColor),
                              width: isSelected ? 2 : 1,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: AppColors.primaryRoyalBlue.withValues(alpha: 0.25),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    )
                                  ]
                                : [],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                DateFormat('E').format(date).toUpperCase(),
                                style: TextStyle(
                                  color: isSelected
                                      ? AppColors.white.withValues(alpha: 0.9)
                                      : (isAvailable ? AppColors.secondaryText : AppColors.mutedText),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                DateFormat('d').format(date),
                                style: TextStyle(
                                  color: isSelected
                                      ? AppColors.white
                                      : (isAvailable ? AppColors.primaryText : AppColors.mutedText),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                DateFormat('MMM').format(date),
                                style: TextStyle(
                                  color: isSelected
                                      ? AppColors.white.withValues(alpha: 0.9)
                                      : (isAvailable ? AppColors.secondaryText : AppColors.mutedText),
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (!isSelectedDateWorkable) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.statusRejectedBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline_rounded, size: 16, color: AppColors.statusRejected),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Faculty is not taking appointments on ${DateFormat('EEEE').format(_selectedDate)}. Please choose another date.',
                            style: const TextStyle(
                              color: AppColors.statusRejected,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 24),

                // 3. Time Slots Section
                _buildSectionTitle('Available Time Slots', Icons.schedule_rounded),
                const SizedBox(height: 4),
                Text(
                  '${liveFaculty.availableSlots.length} slots configured (${liveFaculty.slotDurationMinutes} mins each)',
                  style: const TextStyle(color: AppColors.secondaryText, fontSize: 12.5),
                ),
                const SizedBox(height: 12),
                if (!isSelectedDateWorkable)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.veryLightBlue.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.borderColor),
                    ),
                    child: const Center(
                      child: Text(
                        'Select an active working day above to view time slots.',
                        style: TextStyle(color: AppColors.secondaryText, fontSize: 13),
                      ),
                    ),
                  )
                else
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: liveFaculty.availableSlots.map((slot) {
                      final isSelected = _selectedTimeSlot == slot;
                      final isBooked = appState.isSlotAlreadyBooked(liveFaculty.id, _selectedDate, slot);

                      return InkWell(
                        onTap: isBooked
                            ? null
                            : () {
                                setState(() {
                                  _selectedTimeSlot = slot;
                                });
                              },
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primaryRoyalBlue
                                : (isBooked ? AppColors.veryLightBlue.withValues(alpha: 0.4) : AppColors.white),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primaryRoyalBlue
                                  : (isBooked ? AppColors.borderColor : AppColors.borderColor),
                              width: isSelected ? 1.8 : 1.2,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isBooked
                                    ? Icons.block_rounded
                                    : (isSelected ? Icons.check_circle_rounded : Icons.access_time_rounded),
                                size: 14,
                                color: isSelected
                                    ? Colors.white
                                    : (isBooked ? AppColors.mutedText : AppColors.primaryRoyalBlue),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                slot,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : (isBooked ? AppColors.mutedText : AppColors.primaryText),
                                  fontSize: 12.5,
                                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                                  decoration: isBooked ? TextDecoration.lineThrough : null,
                                ),
                              ),
                              if (isBooked) ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.statusCancelledBg,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    'Booked',
                                    style: TextStyle(
                                      color: AppColors.secondaryText,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                const SizedBox(height: 24),

                // 4. Appointment Type
                _buildSectionTitle('Consultation Type', Icons.category_outlined),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _appointmentTypes.map((type) {
                    final isSelected = _selectedType == type;
                    return ChoiceChip(
                      label: Text(type),
                      selected: isSelected,
                      selectedColor: AppColors.primaryRoyalBlue,
                      backgroundColor: AppColors.white,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : AppColors.primaryText,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                      side: BorderSide(
                        color: isSelected ? AppColors.primaryRoyalBlue : AppColors.borderColor,
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      onSelected: (val) {
                        if (val) {
                          setState(() {
                            _selectedType = type;
                          });
                        }
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // 5. Purpose of Appointment
                _buildSectionTitle('Purpose & Discussion Agenda *', Icons.edit_note_rounded),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _purposeController,
                  maxLines: 2,
                  style: const TextStyle(fontSize: 14, color: AppColors.primaryText),
                  decoration: const InputDecoration(
                    hintText: 'e.g. Doubts regarding CNN optimization or capstone milestone...',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter the purpose of this appointment';
                    }
                    if (value.trim().length < 6) {
                      return 'Please describe the purpose with at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // 6. Additional Message
                _buildSectionTitle('Additional Message (Optional)', Icons.chat_bubble_outline_rounded),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _messageController,
                  maxLines: 3,
                  style: const TextStyle(fontSize: 14, color: AppColors.primaryText),
                  decoration: const InputDecoration(
                    hintText: 'Any reference links, assignment numbers, or specific materials you will bring...',
                  ),
                ),
                const SizedBox(height: 32),

                // 7. Confirm Button
                PrimaryButton(
                  text: 'Confirm & Book Appointment',
                  icon: Icons.check_circle_outline_rounded,
                  onPressed: () => _handleBookingSubmit(context, liveFaculty, appState),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
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

  Future<void> _handleBookingSubmit(
    BuildContext context,
    Faculty liveFaculty,
    AppStateProvider appState,
  ) async {
    // Validate form inputs
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validate date availability
    if (!_isDateAvailable(_selectedDate, liveFaculty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selected date is not available for appointments. Please choose another date.'),
          backgroundColor: AppColors.statusRejected,
        ),
      );
      return;
    }

    // Validate slot selection
    if (_selectedTimeSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an available time slot.'),
          backgroundColor: AppColors.statusRejected,
        ),
      );
      return;
    }

    // Prevent duplicate booking of same slot
    final isClashed = appState.isSlotAlreadyBooked(liveFaculty.id, _selectedDate, _selectedTimeSlot!);
    if (isClashed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This time slot was just booked by another student. Please pick another slot.'),
          backgroundColor: AppColors.statusRejected,
        ),
      );
      return;
    }

    final formattedDate = DateFormat('EEE, MMM d, yyyy').format(_selectedDate);

    // Show confirmation dialog before booking
    final confirmation = await ConfirmDialog.show(
      context: context,
      title: 'Confirm Appointment Request',
      message:
          'Submit booking with ${liveFaculty.name} for $formattedDate during $_selectedTimeSlot for "$_selectedType"?',
      confirmText: 'Submit Request',
      confirmColor: AppColors.primaryRoyalBlue,
      icon: Icons.calendar_today_rounded,
    );

    if (confirmation != null && confirmation['confirmed'] == true) {
      // Save appointment in shared local state!
      final newAppointmentId = appState.bookAppointment(
        faculty: liveFaculty,
        date: _selectedDate,
        timeSlot: _selectedTimeSlot!,
        appointmentType: _selectedType,
        purpose: _purposeController.text.trim(),
        additionalMessage: _messageController.text.trim(),
      );

      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => BookingSuccessScreen(
              appointmentId: newAppointmentId,
              faculty: liveFaculty,
              date: _selectedDate,
              timeSlot: _selectedTimeSlot!,
              appointmentType: _selectedType,
              purpose: _purposeController.text.trim(),
            ),
          ),
        );
      }
    }
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../providers/app_state_provider.dart';
import '../../../widgets/common/primary_button.dart';

class ManageAvailabilityScreen extends StatefulWidget {
  const ManageAvailabilityScreen({super.key});

  @override
  State<ManageAvailabilityScreen> createState() => _ManageAvailabilityScreenState();
}

class _ManageAvailabilityScreenState extends State<ManageAvailabilityScreen> {
  late List<String> _workingDays;
  late String _openingTime;
  late String _closingTime;
  late int _slotDurationMinutes;
  late List<String> _availableSlots;
  late List<String> _holidays;

  final List<String> _allWeekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];

  final List<int> _durationOptions = [15, 30, 45, 60];

  final TextEditingController _newSlotController = TextEditingController();
  final TextEditingController _holidayController = TextEditingController();

  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final faculty = context.read<AppStateProvider>().currentFaculty;
      _workingDays = List.from(faculty.workingDays);
      _openingTime = faculty.openingTime;
      _closingTime = faculty.closingTime;
      _slotDurationMinutes = faculty.slotDurationMinutes;
      _availableSlots = List.from(faculty.availableSlots);
      _holidays = List.from(faculty.holidays);
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _newSlotController.dispose();
    _holidayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppStateProvider>();
    final faculty = appState.currentFaculty;

    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      appBar: AppBar(
        title: const Text('Manage Availability'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header info banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: AppColors.cardGradient,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.borderColor),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, color: AppColors.primaryRoyalBlue, size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Changes saved here immediately update the live booking options for ${faculty.name} in student portals.',
                      style: const TextStyle(
                        color: AppColors.primaryText,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            // 1. Working Days
            _buildSectionHeader('Consultation Working Days', Icons.calendar_view_week_rounded),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _allWeekdays.map((day) {
                final isSelected = _workingDays.contains(day);
                return FilterChip(
                  label: Text(day),
                  selected: isSelected,
                  selectedColor: AppColors.primaryRoyalBlue,
                  backgroundColor: AppColors.white,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : AppColors.primaryText,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 13,
                  ),
                  side: BorderSide(
                    color: isSelected ? AppColors.primaryRoyalBlue : AppColors.borderColor,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _workingDays.add(day);
                      } else {
                        if (_workingDays.length > 1) {
                          _workingDays.remove(day);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('At least one working day must be selected.'),
                              backgroundColor: AppColors.statusRejected,
                            ),
                          );
                        }
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // 2. Office Consultation Hours & Duration
            _buildSectionHeader('Office Hours & Slot Duration', Icons.schedule_rounded),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.borderColor),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Opening Time',
                              style: TextStyle(color: AppColors.secondaryText, fontSize: 12.5),
                            ),
                            const SizedBox(height: 6),
                            InkWell(
                              onTap: () => _pickTime(true),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                decoration: BoxDecoration(
                                  color: AppColors.veryLightBlue,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppColors.borderColor),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(_openingTime, style: const TextStyle(fontWeight: FontWeight.w700)),
                                    const Icon(Icons.access_time_rounded, size: 16, color: AppColors.primaryRoyalBlue),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Closing Time',
                              style: TextStyle(color: AppColors.secondaryText, fontSize: 12.5),
                            ),
                            const SizedBox(height: 6),
                            InkWell(
                              onTap: () => _pickTime(false),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                decoration: BoxDecoration(
                                  color: AppColors.veryLightBlue,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppColors.borderColor),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(_closingTime, style: const TextStyle(fontWeight: FontWeight.w700)),
                                    const Icon(Icons.access_time_rounded, size: 16, color: AppColors.primaryRoyalBlue),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1, color: AppColors.borderColor),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Slot Duration',
                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                          ),
                          Text(
                            'Per individual student consultation',
                            style: TextStyle(color: AppColors.secondaryText, fontSize: 12),
                          ),
                        ],
                      ),
                      DropdownButton<int>(
                        value: _slotDurationMinutes,
                        dropdownColor: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        items: _durationOptions.map((m) {
                          return DropdownMenuItem<int>(
                            value: m,
                            child: Text('$m mins', style: const TextStyle(fontWeight: FontWeight.w600)),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _slotDurationMinutes = val);
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 3. Available Slots Configuration
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSectionHeader('Bookable Time Slots', Icons.more_time_rounded),
                TextButton.icon(
                  onPressed: _showAddSlotDialog,
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: const Text('Add Slot'),
                  style: TextButton.styleFrom(foregroundColor: AppColors.primaryRoyalBlue),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.borderColor),
              ),
              child: Column(
                children: _availableSlots.map((slot) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.timer_outlined, size: 16, color: AppColors.primaryRoyalBlue),
                            const SizedBox(width: 8),
                            Text(
                              slot,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13.5,
                                color: AppColors.primaryText,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.statusRejected),
                          onPressed: () {
                            if (_availableSlots.length > 1) {
                              setState(() => _availableSlots.remove(slot));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('At least one appointment slot must remain active.'),
                                  backgroundColor: AppColors.statusRejected,
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),

            // 4. Institutional Holidays & Leave Note
            _buildSectionHeader('Institutional Holidays & Blackout Dates', Icons.beach_access_outlined),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _holidays.map((h) {
                      return Chip(
                        label: Text(h, style: const TextStyle(fontSize: 12)),
                        backgroundColor: AppColors.veryLightBlue,
                        deleteIcon: const Icon(Icons.close_rounded, size: 14),
                        onDeleted: () {
                          setState(() => _holidays.remove(h));
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _holidayController,
                          decoration: const InputDecoration(
                            hintText: 'Add leave date or holiday note...',
                            contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          if (_holidayController.text.trim().isNotEmpty) {
                            setState(() {
                              _holidays.add(_holidayController.text.trim());
                              _holidayController.clear();
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryRoyalBlue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Add'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Save Availability Button
            PrimaryButton(
              text: 'Save Availability Settings',
              icon: Icons.save_rounded,
              onPressed: () {
                appState.updateFacultyAvailability(
                  facultyId: faculty.id,
                  workingDays: _workingDays,
                  openingTime: _openingTime,
                  closingTime: _closingTime,
                  slotDurationMinutes: _slotDurationMinutes,
                  availableSlots: _availableSlots,
                  unavailableDates: faculty.unavailableDates,
                  holidays: _holidays,
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Faculty availability saved & synchronized!'),
                    backgroundColor: AppColors.statusApproved,
                    behavior: SnackBarBehavior.floating,
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

  void _pickTime(bool isOpening) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isOpening ? const TimeOfDay(hour: 9, minute: 0) : const TimeOfDay(hour: 17, minute: 0),
    );
    if (picked != null) {
      final period = picked.period == DayPeriod.am ? 'AM' : 'PM';
      final hour = picked.hourOfPeriod == 0 ? 12 : picked.hourOfPeriod;
      final minute = picked.minute.toString().padLeft(2, '0');
      final formatted = '${hour.toString().padLeft(2, '0')}:$minute $period';
      setState(() {
        if (isOpening) {
          _openingTime = formatted;
        } else {
          _closingTime = formatted;
        }
      });
    }
  }

  void _showAddSlotDialog() {
    _newSlotController.text = '12:00 PM - 12:30 PM';
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Add Time Slot', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _newSlotController,
              decoration: const InputDecoration(
                labelText: 'Slot Window (e.g. 03:00 PM - 03:30 PM)',
              ),
            ),
          ],
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
              final text = _newSlotController.text.trim();
              if (text.isNotEmpty && !_availableSlots.contains(text)) {
                setState(() => _availableSlots.add(text));
                Navigator.pop(context);
              }
            },
            child: const Text('Add Slot'),
          ),
        ],
      ),
    );
  }
}

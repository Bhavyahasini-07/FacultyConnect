import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../providers/app_state_provider.dart';
import '../../../widgets/common/search_input_bar.dart';
import '../../../widgets/common/empty_state_view.dart';
import '../../../widgets/faculty/faculty_card.dart';
import '../faculty_profile/faculty_profile_screen.dart';
import '../booking/appointment_booking_screen.dart';

class FacultyDirectoryTab extends StatelessWidget {
  const FacultyDirectoryTab({super.key});

  final List<String> _departments = const [
    'All',
    'Computer Science and Engineering',
    'Information Technology',
    'Electronics and Communication Engineering',
    'Electrical and Electronics Engineering',
    'Mechanical Engineering',
    'Civil Engineering',
  ];

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppStateProvider>();
    final facultyList = appState.filteredFacultyList;

    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      appBar: AppBar(
        title: const Text('Faculty Directory'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: AppColors.veryLightBlue,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.borderColor),
              ),
              child: const Icon(Icons.sort_rounded, color: AppColors.primaryRoyalBlue, size: 20),
            ),
            onPressed: () => _showSortModal(context, appState),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Search & Filter header
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            color: AppColors.white,
            child: Column(
              children: [
                SearchInputBar(
                  hintText: 'Search by professor, domain, subject...',
                  initialValue: appState.searchQuery,
                  onChanged: (val) => appState.setSearchQuery(val),
                  onFilterTap: () => _showSortModal(context, appState),
                ),
                const SizedBox(height: 12),
                // Horizontal Department Filter Chips
                SizedBox(
                  height: 38,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _departments.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final dept = _departments[index];
                      final isSelected = appState.selectedDepartment == dept;
                      final shortLabel = _getShortDeptName(dept);

                      return FilterChip(
                        label: Text(shortLabel),
                        selected: isSelected,
                        onSelected: (_) => appState.setDepartmentFilter(dept),
                        selectedColor: AppColors.primaryRoyalBlue,
                        backgroundColor: AppColors.veryLightBlue,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : AppColors.primaryText,
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        ),
                        side: BorderSide(
                          color: isSelected ? AppColors.primaryRoyalBlue : AppColors.borderColor,
                        ),
                        showCheckmark: false,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                // Quick Availability filter toggle
                Row(
                  children: [
                    Text(
                      'Showing ${facultyList.length} Faculty Members',
                      style: const TextStyle(
                        color: AppColors.secondaryText,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        if (appState.selectedAvailabilityFilter == 'All') {
                          appState.setAvailabilityFilter('Available Now');
                        } else {
                          appState.setAvailabilityFilter('All');
                        }
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: appState.selectedAvailabilityFilter == 'Available Now'
                              ? AppColors.statusApprovedBg
                              : AppColors.veryLightBlue,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: appState.selectedAvailabilityFilter == 'Available Now'
                                ? AppColors.statusApproved
                                : AppColors.borderColor,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: appState.selectedAvailabilityFilter == 'Available Now'
                                    ? AppColors.statusApproved
                                    : AppColors.secondaryText,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Available Now',
                              style: TextStyle(
                                color: appState.selectedAvailabilityFilter == 'Available Now'
                                    ? AppColors.statusApproved
                                    : AppColors.secondaryText,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Faculty List View
          Expanded(
            child: facultyList.isEmpty
                ? EmptyStateView(
                    icon: Icons.person_search_rounded,
                    title: 'No Faculty Found',
                    message: 'No faculty profiles matched your search or filter. Try clearing filters.',
                    buttonText: 'Reset Filters',
                    onButtonPressed: () {
                      appState.setSearchQuery('');
                      appState.setDepartmentFilter('All');
                      appState.setAvailabilityFilter('All');
                    },
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: facultyList.length,
                    itemBuilder: (context, index) {
                      final faculty = facultyList[index];
                      return FacultyCard(
                        faculty: faculty,
                        onViewProfile: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FacultyProfileScreen(faculty: faculty),
                            ),
                          );
                        },
                        onBookAppointment: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AppointmentBookingScreen(faculty: faculty),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showSortModal(BuildContext context, AppStateProvider appState) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: AppColors.white,
      builder: (_) {
        final options = ['Recommended', 'Rating', 'Experience', 'Name'];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Sort Directory By',
                    style: TextStyle(
                      color: AppColors.primaryText,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: AppColors.secondaryText),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...options.map((opt) {
                final isSelected = appState.sortBy == opt;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    opt,
                    style: TextStyle(
                      color: isSelected ? AppColors.primaryRoyalBlue : AppColors.primaryText,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle_rounded, color: AppColors.primaryRoyalBlue)
                      : null,
                  onTap: () {
                    appState.setSortBy(opt);
                    Navigator.pop(context);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  String _getShortDeptName(String fullDept) {
    switch (fullDept) {
      case 'Computer Science and Engineering':
        return 'CSE';
      case 'Information Technology':
        return 'IT';
      case 'Electronics and Communication Engineering':
        return 'ECE';
      case 'Electrical and Electronics Engineering':
        return 'EEE';
      case 'Mechanical Engineering':
        return 'Mechanical';
      case 'Civil Engineering':
        return 'Civil';
      default:
        return fullDept;
    }
  }
}

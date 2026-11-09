import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:faculty_connect/main.dart';
import 'package:faculty_connect/models/appointment.dart';
import 'package:faculty_connect/providers/app_state_provider.dart';
import 'package:faculty_connect/screens/welcome/welcome_screen.dart';
import 'package:faculty_connect/screens/student/student_main_screen.dart';
import 'package:faculty_connect/screens/faculty/faculty_main_screen.dart';

void main() {
  group('AppStateProvider Logic Tests', () {
    late AppStateProvider provider;

    setUp(() {
      provider = AppStateProvider();
    });

    test('Initial student and faculty profiles are populated correctly', () {
      expect(provider.currentStudent.name, 'Bhavya Hasini');
      expect(provider.currentStudent.rollNumber, '24PA1A05I1');
      expect(provider.facultyList.length, greaterThanOrEqualTo(10));
      expect(provider.appointments.length, greaterThanOrEqualTo(12));
    });

    test('Booking an appointment creates a pending request and notifications', () {
      final initialCount = provider.appointments.length;
      final faculty = provider.facultyList.first;
      final bookingDate = DateTime.now().add(const Duration(days: 4));
      const slot = '10:30 AM - 11:00 AM';

      final newId = provider.bookAppointment(
        faculty: faculty,
        date: bookingDate,
        timeSlot: slot,
        appointmentType: 'Academic Doubt',
        purpose: 'Transformer self-attention test inquiry',
        additionalMessage: 'Reviewing attention weights',
      );

      expect(newId, startsWith('APT-2026-'));
      expect(provider.appointments.length, initialCount + 1);

      final booked = provider.appointments.firstWhere((a) => a.id == newId);
      expect(booked.status, AppointmentStatus.pending);
      expect(booked.purpose, 'Transformer self-attention test inquiry');

      // Slot clash check must now report true
      expect(provider.isSlotAlreadyBooked(faculty.id, bookingDate, slot), isTrue);
    });

    test('Faculty approving an appointment updates status to approved', () {
      final faculty = provider.facultyList.first;
      final bookingDate = DateTime.now().add(const Duration(days: 6));
      final aptId = provider.bookAppointment(
        faculty: faculty,
        date: bookingDate,
        timeSlot: '02:00 PM - 02:30 PM',
        appointmentType: 'Mentorship',
        purpose: 'Career discussion',
        additionalMessage: '',
      );

      expect(provider.appointments.firstWhere((a) => a.id == aptId).status, AppointmentStatus.pending);

      provider.approveAppointment(aptId);
      expect(provider.appointments.firstWhere((a) => a.id == aptId).status, AppointmentStatus.approved);
    });

    test('Faculty rejecting an appointment records reason and updates status', () {
      final faculty = provider.facultyList.first;
      final bookingDate = DateTime.now().add(const Duration(days: 5));
      final aptId = provider.bookAppointment(
        faculty: faculty,
        date: bookingDate,
        timeSlot: '03:30 PM - 04:00 PM',
        appointmentType: 'Other',
        purpose: 'Form attestation',
        additionalMessage: '',
      );

      provider.rejectAppointment(aptId, 'Faculty is on conference duty.');

      final updated = provider.appointments.firstWhere((a) => a.id == aptId);
      expect(updated.status, AppointmentStatus.rejected);
      expect(updated.rejectionReason, 'Faculty is on conference duty.');
    });

    test('Cancelling an appointment updates status to cancelled', () {
      final faculty = provider.facultyList.first;
      final aptId = provider.bookAppointment(
        faculty: faculty,
        date: DateTime.now().add(const Duration(days: 3)),
        timeSlot: '04:00 PM - 04:30 PM',
        appointmentType: 'Project Discussion',
        purpose: 'Capstone prep',
        additionalMessage: '',
      );

      provider.cancelAppointment(aptId, 'Clash with midterm lab test.');

      final updated = provider.appointments.firstWhere((a) => a.id == aptId);
      expect(updated.status, AppointmentStatus.cancelled);
      expect(updated.cancellationReason, 'Clash with midterm lab test.');
    });

    test('Updating faculty availability synchronizes live slots', () {
      final faculty = provider.facultyList.first;
      final newSlots = ['08:30 AM - 09:00 AM', '11:00 AM - 11:30 AM'];
      final newWorkingDays = ['Monday', 'Wednesday'];

      provider.updateFacultyAvailability(
        facultyId: faculty.id,
        workingDays: newWorkingDays,
        openingTime: '08:30 AM',
        closingTime: '04:00 PM',
        slotDurationMinutes: 30,
        availableSlots: newSlots,
        unavailableDates: [],
        holidays: ['National Day'],
      );

      final updatedFaculty = provider.facultyList.firstWhere((f) => f.id == faculty.id);
      expect(updatedFaculty.availableSlots, newSlots);
      expect(updatedFaculty.workingDays, newWorkingDays);
    });

    test('Student profile updates reflect across application and appointments', () {
      provider.updateStudentProfile(
        name: 'Bhavya H. Rao',
        rollNumber: '24PA1A05I1',
        department: 'Artificial Intelligence & Data Science',
        year: '3rd Year',
        email: 'bhavya.rao@college.edu',
        phone: '+91 99999 00000',
      );

      expect(provider.currentStudent.name, 'Bhavya H. Rao');
      expect(provider.currentStudent.department, 'Artificial Intelligence & Data Science');
      expect(provider.currentStudent.year, '3rd Year');
    });

    test('Filtering faculty by search query and department', () {
      provider.setSearchQuery('Sharma');
      expect(provider.filteredFacultyList.length, 1);
      expect(provider.filteredFacultyList.first.name, contains('Sharma'));

      provider.setSearchQuery('');
      provider.setDepartmentFilter('Civil Engineering');
      expect(provider.filteredFacultyList.every((f) => f.department == 'Civil Engineering'), isTrue);
    });

    test('Notification unread counts and actions work properly', () {
      final initialUnread = provider.unreadNotificationsCount(UserRole.student);
      expect(initialUnread, greaterThan(0));

      provider.markAllNotificationsAsRead(UserRole.student);
      expect(provider.unreadNotificationsCount(UserRole.student), 0);
    });
  });

  group('UI & Widget Tests', () {
    testWidgets('FacultyConnectApp renders successfully and navigates to welcome screen', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AppStateProvider()),
          ],
          child: const FacultyConnectApp(),
        ),
      );

      expect(find.text('FacultyConnect'), findsWidgets);
      expect(find.text('Connect. Schedule. Meet.'), findsOneWidget);

      // Advance timer for splash transition
      await tester.pump(const Duration(milliseconds: 2300));
      await tester.pumpAndSettle();

      expect(find.text('Choose Your Role'), findsOneWidget);
    });

    testWidgets('WelcomeScreen renders dual role selection cards', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AppStateProvider()),
          ],
          child: const MaterialApp(
            home: WelcomeScreen(),
          ),
        ),
      );

      expect(find.text('Choose Your Role'), findsOneWidget);
      expect(find.text('Continue as Student'), findsOneWidget);
      expect(find.text('Continue as Faculty'), findsOneWidget);
    });

    testWidgets('StudentMainScreen renders greeting, stats, and navigation', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AppStateProvider()),
          ],
          child: const MaterialApp(
            home: StudentMainScreen(),
          ),
        ),
      );

      expect(find.textContaining('Hello, Bhavya'), findsOneWidget);
      expect(find.text('Consultation Summary'), findsOneWidget);
      expect(find.text('Total Booked'), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);

      // Tap Explore tab icon
      await tester.tap(find.byIcon(Icons.explore_outlined));
      await tester.pumpAndSettle();

      expect(find.text('Explore'), findsOneWidget);
      expect(find.text('Faculty Directory'), findsOneWidget);
    });

    testWidgets('FacultyMainScreen renders faculty dashboard with pending badges', (WidgetTester tester) async {
      final provider = AppStateProvider()..setRole(UserRole.faculty);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: provider),
          ],
          child: const MaterialApp(
            home: FacultyMainScreen(),
          ),
        ),
      );

      expect(find.textContaining('Dr. Rajesh Kumar'), findsOneWidget);
      expect(find.text('Request Statistics'), findsOneWidget);
      expect(find.text('Total Requests'), findsOneWidget);
      expect(find.text('Pending Action'), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);

      // Tap Requests tab
      await tester.tap(find.byIcon(Icons.assignment_outlined));
      await tester.pumpAndSettle();

      expect(find.text('Appointment Requests'), findsOneWidget);
    });
  });
}

# FacultyConnect – Faculty Appointment Booking System

[![Flutter](https://img.shields.io/badge/Flutter-3.41.4-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.11.1-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Material Design 3](https://img.shields.io/badge/Material%20Design-3-blue)](https://m3.material.io/)
[![Architecture](https://img.shields.io/badge/Architecture-Clean%20%2B%20Provider-1D4ED8)](#application-architecture)
[![License](https://img.shields.io/badge/License-Academic%20Demo-102A56)](#)

A modern, polished, and interactive academic appointment booking system developed in Flutter with a **Premium Blue Design System**. Designed to bridge communication gaps and streamline consultations between students and faculty members in engineering colleges.

> **IMPORTANT ARCHITECTURAL NOTE:**  
> This project is strictly **FRONTEND / UI / UX ONLY**. It functions autonomously using local mock data and a unified shared in-memory repository with `Provider`. Real-time workflows—such as student booking, faculty approval/rejection, cancellation, availability reconfiguration, and local notifications—reactively synchronize across both portals without requiring an external backend or database.

---

## 📖 Table of Contents
1. [Problem Statement](#problem-statement)
2. [Project Objectives](#project-objectives)
3. [Key Features](#key-features)
   - [Student Module](#student-module)
   - [Faculty Module](#faculty-module)
   - [Shared Reactive State & Notification System](#shared-reactive-state--notification-system)
4. [Technology Stack](#technology-stack)
5. [Premium Blue Design System](#premium-blue-design-system)
6. [Demo Profiles & Credentials](#demo-profiles--credentials)
7. [Application Architecture & Folder Structure](#application-architecture--folder-structure)
8. [Installation & Setup](#installation--setup)
9. [Automated Testing & Analysis](#automated-testing--analysis)
10. [Future Enhancements](#future-enhancements)

---

## 🎯 Problem Statement
In academic institutions, scheduling meetings between students and professors often suffers from:
- Cluttered office hours with unpredictable walk-in lines.
- Uncoordinated student queues outside faculty cabins.
- Lack of visibility into faculty availability, leaves, or academic duties.
- Manual email back-and-forths that lead to scheduling conflicts and double bookings.

**FacultyConnect** solves this by providing a unified, transparent, and responsive interface where students can browse verified faculty, check live slot availability, book structured consultations, and track requests in real time.

---

## 🎯 Project Objectives
- Enable seamless discovery of faculty across multiple departments (CSE, IT, ECE, EEE, ME, CE).
- Facilitate intuitive appointment booking with slot-clash prevention and purpose categorization.
- Empower faculty to manage their availability windows, approve/reject requests with feedback, and review schedules in daily, weekly, or monthly views.
- Provide synchronized local reactive state management so actions taken by either role update immediately across the app.

---

## ✨ Key Features

### 🎓 Student Module
- **Personalized Dashboard:** Personalized greeting for *Bhavya Hasini*, quick search shortcut, statistics summary cards (Total Booked, Pending, Approved, Completed), upcoming appointment highlight card, and recently viewed faculty carousel.
- **Faculty Directory:** 11 realistic faculty members across CSE, IT, ECE, EEE, ME, and CE.
  - Multi-criteria search (by faculty name, subject specialization, department, and keywords).
  - Dynamic department filter chips with short badge codes.
  - Quick availability toggle (*Available Now* vs *All*).
  - Multi-mode sorting (Recommended, Rating, Experience, Name).
- **Faculty Profile Details:** Comprehensive view with qualifications (Ph.D. institutes), experience, research bio, room location, official hours, expertise tags, weekly schedule breakdown, and direct booking CTA.
- **Appointment Booking Flow:**
  - Dynamic 14-day future calendar picker (validates against faculty working days and holidays).
  - Live time slot selector with visual clash indicators (booked slots show as disabled).
  - Consultation types: *Academic Doubt*, *Project Discussion*, *Career Guidance*, *Mentorship*, *Other*.
  - Form validation with mandatory discussion agenda.
  - Interactive Confirmation Dialog before booking.
- **Booking Success Screen:** Celebratory UI, generated Booking ID (e.g., `APT-2026-1014`), summary card, pending approval indicator, and navigation shortcuts.
- **My Appointments Management:** Tabbed views (*All*, *Upcoming*, *Pending*, *Completed*, *Cancelled*), with instant cancellation actions and detailed audit trails.
- **Student Profile & Settings:** Profile details for *Bhavya Hasini*, editable local profile dialog, notification preferences toggles, help guide, and instant role switching.

### 👨‍🏫 Faculty Module
- **Faculty Dashboard:** Navy-to-royal-blue gradient header, statistics cards, visual analytics (acceptance rate progress bar and breakdown), today's scheduled consultations, and quick action shortcuts.
- **Appointment Requests:** Dedicated portal for pending student requests with detailed student roll numbers, departments, and consultation purposes.
  - **Approve Workflow:** Instant status confirmation dialog, updates student screen to *Approved*, and fires local notifications.
  - **Reject Workflow:** Modal with mandatory reason input (e.g., examination duty, conference conflict), notifying the student instantly.
- **Faculty Schedule:** Calendar-based schedule offering **Daily**, **Weekly**, and **Monthly** views with color-coded appointment statuses.
- **Manage Availability:**
  - Working days selector (Monday to Saturday).
  - Opening and closing office hours time pickers.
  - Slot duration selector (15, 30, 45, 60 minutes).
  - Add and remove bookable time slots.
  - Blackout dates and institutional holiday manager.
  - **Live Synchronization:** Changes immediately alter the available slots in the student booking screen!
- **Faculty Profile & Settings:** Comprehensive faculty credentials view, local editing modal, and role switcher.

### 🔔 Shared Reactive State & Notification System
- Unified `AppStateProvider` powering shared data across student and faculty views.
- Reactive local notifications for:
  - New booking request received
  - Appointment approval confirmation
  - Appointment rejection with stated faculty reason
  - Student cancellation notice
  - Upcoming consultation reminders
- Unread count badge on the custom AppBar with "Mark all read" and "Clear all" options.

---

## 🛠 Technology Stack
- **Framework:** Flutter 3.41.4 (Channel stable)
- **Language:** Dart 3.11.1
- **Design System:** Material Design 3 (M3)
- **Typography:** Google Fonts (`Poppins`)
- **State Management:** Provider (`ChangeNotifierProvider`, `MultiProvider`)
- **Date & Time Formatting:** `intl`
- **Testing:** `flutter_test` (Unit and Widget testing)

---

## 🎨 Premium Blue Design System

The application strictly implements the specified blue color palette across all components:

| Color Name | Hex Code | Visual Preview / Usage |
|:---|:---:|:---|
| **Deep Navy Blue** | `#102A56` | Main headers, splash screen, and accent sections |
| **Primary Royal Blue** | `#1D4ED8` | Primary CTA buttons, active tabs, and branding icons |
| **Secondary Blue** | `#2563EB` | Secondary accents, status highlights, and links |
| **Accent Blue** | `#3B82F6` | Gradients, chips, and active indicators |
| **Sky Blue** | `#60A5FA` | Badges, borders, and visual decorative circles |
| **Light Blue** | `#DBEAFE` | Container backgrounds, inactive borders, and active pill backgrounds |
| **Very Light Blue** | `#F0F7FF` | Subdued card fills and input fields |
| **Main Background** | `#F8FAFC` | Scaffold and screen background |
| **White** | `#FFFFFF` | Card surfaces, dialog backgrounds, and light typography |
| **Primary Text** | `#172554` | Headings, titles, and body emphasis |
| **Secondary Text** | `#64748B` | Subtitles, labels, and secondary metadata |
| **Border Color** | `#DBEAFE` | Card outlines, dividers, and input borders |

### Status Colors
- **Approved / Success:** `#16A34A` (Background: `#DCFCE7`)
- **Pending:** `#F59E0B` (Background: `#FEF3C7`)
- **Rejected:** `#DC2626` (Background: `#FEE2E2`)
- **Cancelled:** `#64748B` (Background: `#F1F5F9`)

---

## 👤 Demo Profiles & Credentials

### Default Student Profile
- **Name:** Bhavya Hasini
- **Roll Number:** `24PA1A05I1`
- **Department:** Computer Science and Engineering
- **Year of Study:** 2nd Year
- **Email:** `bhavya.hasini@college.edu`
- **Phone:** `+91 98480 22338`

### Featured Faculty Profiles (11 Sample Profiles Across 6 Departments)
1. **Dr. Rajesh Kumar** – Professor & HoD, Computer Science & Engineering (IIT Madras)
2. **Dr. Ananya Sharma** – Associate Professor, Computer Science & Engineering (NIT Warangal)
3. **Prof. Vikram Aditya** – Assistant Professor, Information Technology (IIIT Hyderabad)
4. **Dr. Meenakshi Sundaram** – Associate Professor, Information Technology (IIT Delhi)
5. **Dr. Suresh Varma** – Professor & Dean of Academics, Electronics & Communication (IISc Bangalore)
6. **Dr. Harini Reddy** – Associate Professor, Electronics & Communication (IIT Kharagpur)
7. **Dr. Arvind Swaminathan** – Professor, Electrical & Electronics (IIT Bombay)
8. **Dr. Ramesh Chandra** – Professor, Mechanical Engineering (IIT Roorkee)
9. **Prof. Sneha Kulkarni** – Assistant Professor, Mechanical Engineering (NIT Surathkal)
10. **Dr. Murali Mohan Rao** – Professor & HoD, Civil Engineering (IIT Kanpur)
11. **Dr. Kavitha Nambiar** – Associate Professor, Civil Engineering (IIT Madras)

---

## 📂 Application Architecture & Folder Structure

```
lib/
├── main.dart                               # Application entrypoint & MultiProvider setup
├── core/
│   ├── constants/
│   │   └── app_colors.dart                 # Centralized blue palette constants & gradients
│   └── theme/
│       └── app_theme.dart                  # Material 3 ThemeData with Poppins typography
├── models/
│   ├── student.dart                        # Student data model
│   ├── faculty.dart                        # Faculty data model with availability specs
│   ├── appointment.dart                    # Appointment model & AppointmentStatus enum
│   └── notification.dart                   # Notification model & NotificationType enum
├── data/
│   ├── mock_students.dart                  # Initial mock student (Bhavya Hasini)
│   ├── mock_faculty.dart                   # 11 realistic faculty members across departments
│   ├── mock_appointments.dart              # 13 sample appointments across all 5 statuses
│   └── mock_notifications.dart             # Initial notification stream
├── providers/
│   └── app_state_provider.dart             # Central in-memory repository & shared state
├── widgets/
│   ├── common/
│   │   ├── custom_app_bar.dart             # AppBar with notification badge & back actions
│   │   ├── primary_button.dart             # Royal blue styled button with loading state
│   │   ├── secondary_button.dart           # Light blue styled button
│   │   ├── status_badge.dart               # Color-coded pill badge for appointment statuses
│   │   ├── stat_card.dart                  # Summary metric cards with circular icons
│   │   ├── search_input_bar.dart           # Functional search field with clear & filter triggers
│   │   ├── confirm_dialog.dart             # Modal dialog with optional rejection reason input
│   │   └── empty_state_view.dart           # Reusable empty placeholder widget
│   ├── faculty/
│   │   └── faculty_card.dart               # Detailed card with avatar, rating & actions
│   └── appointments/
│       └── appointment_card.dart           # Multi-perspective appointment card with actions
└── screens/
    ├── splash/
    │   └── splash_screen.dart              # Animated splash with brand pulse & tagline
    ├── welcome/
    │   └── welcome_screen.dart             # Dual-role entrypoint (Student / Faculty)
    ├── notifications/
    │   └── notifications_screen.dart       # Notification center with mark read & clear
    ├── student/
    │   ├── student_main_screen.dart        # 4-tab bottom navigation shell
    │   ├── dashboard/
    │   │   └── student_dashboard_tab.dart  # Student Home with statistics & preview cards
    │   ├── directory/
    │   │   └── faculty_directory_tab.dart  # Faculty directory with search, filter, and sort
    │   ├── faculty_profile/
    │   │   └── faculty_profile_screen.dart # Faculty details, office hours, and booking CTA
    │   ├── booking/
    │   │   ├── appointment_booking_screen.dart # 14-day picker, slot checks, and purpose form
    │   │   └── booking_success_screen.dart     # Confirmation screen with booking ID
    │   ├── appointments/
    │   │   ├── student_appointments_tab.dart   # 5 filter tabs with cancellation actions
    │   │   └── appointment_details_screen.dart # Full appointment audit view
    │   └── profile/
    │       └── student_profile_tab.dart    # Bhavya Hasini profile, edits, and role switch
    └── faculty/
        ├── faculty_main_screen.dart        # 5-tab bottom navigation shell with badges
        ├── dashboard/
        │   └── faculty_dashboard_screen.dart # Gradient header, analytics bar & schedule
        ├── requests/
        │   └── appointment_requests_screen.dart # Approve/Reject requests workflow
        ├── schedule/
        │   └── faculty_schedule_screen.dart # Daily, Weekly, and Monthly visual schedule
        ├── availability/
        │   └── manage_availability_screen.dart # Working days, hours, slots & holiday manager
        └── profile/
            └── faculty_profile_screen.dart # Faculty profile, credentials, and edits
```

---

## 🚀 Installation & Setup

### Prerequisites
- Flutter SDK 3.19.0 or higher (Installed: Flutter 3.41.4)
- Dart SDK 3.3.0 or higher (Installed: Dart 3.11.1)
- Android Studio / VS Code with Flutter extension
- Windows, macOS, Linux, or Web browser for testing

### Step-by-Step Instructions
1. **Clone the repository:**
   ```bash
   git clone <repository_url>
   cd FacultyConnect
   ```
2. **Fetch dependencies:**
   ```bash
   flutter pub get
   ```
3. **Verify code quality:**
   ```bash
   flutter analyze
   ```
4. **Run automated tests:**
   ```bash
   flutter test
   ```
5. **Launch the application:**
   - On Chrome / Edge (Web):
     ```bash
     flutter run -d chrome
     ```
   - On Windows Desktop:
     ```bash
     flutter run -d windows
     ```
   - On Android Device / Emulator:
     ```bash
     flutter run -d android
     ```

---

## 🧪 Automated Testing & Analysis

The project includes unit and widget tests covering all essential state workflows and UI interactions:

```bash
$ flutter analyze
Analyzing Flutter...
No issues found! (ran in 5.2s)

$ flutter test
00:00 +0: AppStateProvider Logic Tests Initial student and faculty profiles are populated correctly
00:00 +1: AppStateProvider Logic Tests Booking an appointment creates a pending request and notifications
00:00 +2: AppStateProvider Logic Tests Faculty approving an appointment updates status to approved
00:00 +3: AppStateProvider Logic Tests Faculty rejecting an appointment records reason and updates status
00:00 +4: AppStateProvider Logic Tests Cancelling an appointment updates status to cancelled
00:00 +5: AppStateProvider Logic Tests Updating faculty availability synchronizes live slots
00:00 +6: AppStateProvider Logic Tests Student profile updates reflect across application and appointments
00:00 +7: AppStateProvider Logic Tests Filtering faculty by search query and department
00:00 +8: AppStateProvider Logic Tests Notification unread counts and actions work properly
00:00 +9: UI & Widget Tests FacultyConnectApp renders successfully and navigates to welcome screen
00:01 +10: UI & Widget Tests WelcomeScreen renders dual role selection cards
00:01 +11: UI & Widget Tests StudentMainScreen renders greeting, stats, and navigation
00:02 +12: UI & Widget Tests FacultyMainScreen renders faculty dashboard with pending badges
00:03 +13: All tests passed!
```

---

## 🔮 Future Enhancements
- **Backend & Cloud Persistence:** Integrate Firebase Firestore or REST APIs for persistent cloud storage and live multi-device syncing.
- **Push Notifications:** Firebase Cloud Messaging (FCM) integration for real-time mobile push notifications.
- **Calendar Synchronization:** Direct export of confirmed appointments to Google Calendar and Outlook Calendar via `.ics` file generation.
- **Video Consultation Link:** In-app video room creation (e.g., Google Meet / Zoom API) for remote office hours.
- **Document Attachments:** Ability for students to upload lab drafts, resumes, or code snippets during booking.

---

*Developed for academic demonstration with modern Flutter UI/UX standards.*

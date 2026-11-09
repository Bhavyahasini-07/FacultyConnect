import 'package:flutter/material.dart';

/// Centralized Blue Design System Color Palette for FacultyConnect
class AppColors {
  // Brand Blue Palette
  static const Color deepNavyBlue = Color(0xFF102A56);
  static const Color primaryRoyalBlue = Color(0xFF1D4ED8);
  static const Color secondaryBlue = Color(0xFF2563EB);
  static const Color accentBlue = Color(0xFF3B82F6);
  static const Color skyBlue = Color(0xFF60A5FA);
  static const Color lightBlue = Color(0xFFDBEAFE);
  static const Color veryLightBlue = Color(0xFFF0F7FF);

  // Backgrounds & Neutrals
  static const Color mainBackground = Color(0xFFF8FAFC);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color white = Color(0xFFFFFFFF);

  // Typography
  static const Color primaryText = Color(0xFF172554);
  static const Color secondaryText = Color(0xFF64748B);
  static const Color mutedText = Color(0xFF94A3B8);

  // Borders & Dividers
  static const Color borderColor = Color(0xFFDBEAFE);
  static const Color dividerColor = Color(0xFFE2E8F0);

  // Status Colors
  static const Color statusApproved = Color(0xFF16A34A);
  static const Color statusApprovedBg = Color(0xFFDCFCE7);
  static const Color statusPending = Color(0xFFF59E0B);
  static const Color statusPendingBg = Color(0xFFFEF3C7);
  static const Color statusRejected = Color(0xFFDC2626);
  static const Color statusRejectedBg = Color(0xFFFEE2E2);
  static const Color statusCancelled = Color(0xFF64748B);
  static const Color statusCancelledBg = Color(0xFFF1F5F9);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [deepNavyBlue, primaryRoyalBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient headerGradient = LinearGradient(
    colors: [Color(0xFF0F172A), deepNavyBlue, primaryRoyalBlue],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [veryLightBlue, white],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [secondaryBlue, skyBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

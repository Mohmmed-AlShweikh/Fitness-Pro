import 'package:flutter/material.dart';

abstract class AppColors {
  // Primary brand colors
  static const primary = Color(0xFF6C5CE7);
  static const primaryLight = Color(0xFFA29BFE);
  static const secondary = Color(0xFFFD79A8);
  static const accent = Color(0xFF00B894);
  static const warning = Color(0xFFFDCB6E);
  static const error = Color(0xFFE17055);

  // Light theme
  static const lightBackground = Color(0xFFF8F9FE);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightCard = Color(0xFFFFFFFF);
  static const lightText = Color(0xFF2D3436);
  static const lightTextSecondary = Color(0xFF636E72);
  static const lightDivider = Color(0xFFDFE6E9);

  // Dark theme
  static const darkBackground = Color(0xFF0D0D1A);
  static const darkSurface = Color(0xFF1A1A2E);
  static const darkCard = Color(0xFF16213E);
  static const darkText = Color(0xFFF5F6FA);
  static const darkTextSecondary = Color(0xFFB2BEC3);
  static const darkDivider = Color(0xFF2D3436);

  // Gradients
  static const gradientPrimary = [Color(0xFF6C5CE7), Color(0xFFA29BFE)];
  static const gradientSecondary = [Color(0xFFFD79A8), Color(0xFFFDCB6E)];
  static const gradientSuccess = [Color(0xFF00B894), Color(0xFF55EFC4)];
  static const gradientDark = [Color(0xFF1A1A2E), Color(0xFF0F3460)];

  // Category colors
  static const chest = Color(0xFFFF7675);
  static const back = Color(0xFF74B9FF);
  static const legs = Color(0xFF55EFC4);
  static const arms = Color(0xFFFDCB6E);
  static const cardio = Color(0xFFFD79A8);
  static const fullBody = Color(0xFFA29BFE);
}

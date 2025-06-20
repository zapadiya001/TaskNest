// constants/color_constants.dart
import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primaryBlue = Colors.blue;
  static const Color white = Colors.white;

  // Background Colors
  static final Color backgroundColor = Colors.grey[50]!;
  static final Color completedTaskBackground = Colors.blue.shade50;
  static const Color cardBackground = Colors.white;

  // Text Colors
  static final Color primaryText = Colors.grey[800]!;
  static final Color secondaryText = Colors.grey[500]!;
  static final Color tertiaryText = Colors.grey[600]!;
  static final Color hintText = Colors.grey[500]!;
  static final Color completedTaskText = Colors.black;
  static final Color appBarCounter = Colors.white;

  // Border Colors
  static final Color borderColor = Colors.grey[300]!;
  static final Color focusedBorderColor = Colors.blue;

  // Icon Colors
  static final Color iconColor = Colors.grey[400]!;
  static final Color completedTaskIcon = Colors.black;

  // Button Colors
  static const Color  elevatedButtonBackground = Colors.blue;
  static const Color elevatedButtonForeground = Colors.white;
  static final Color outlinedButtonBorder = Colors.grey[300]!;
  static final Color outlinedButtonText = Colors.grey[600]!;

  // Snackbar Colors
  static final Color errorSnackbarBackground = Colors.red.withOpacity(0.3);
  static final Color successSnackbarBackground = Colors.blue.withOpacity(0.3);
  static final Color errorSnackbarText = Colors.red[700]!;
  static final Color successSnackbarText = Colors.blue[700]!;

  // Shadow Colors
  static final Color shadowColor = Colors.black.withOpacity(0.05);
  static final Color completedTaskShadow = Colors.white.withOpacity(0.9);

  // AppBar Colors
  static const Color appBarBackground = Colors.blue;
    static const Color appBarForeground = Colors.white;
  static final Color appBarDropdownBackground = Colors.blue;
  static final Color appBarDropdownBorder = Colors.white.withOpacity(0.2);
  static final Color appBarCounterBackground = Colors.white.withOpacity(0.2);

  // Empty State Colors
  static final Color emptyStateIcon = Colors.grey[300]!;
  static final Color emptyStateTitle = Colors.grey[600]!;
  static final Color emptyStateSubtitle = Colors.grey[500]!;

  // Category Colors (for category icons/selection)
  static const Color categoryPersonal = Colors.green;
  static const Color categoryWishlist = Colors.pink;
  static const Color categoryWork = Colors.purple;
  static const Color categoryShopping = Colors.orange;
  static const Color categoryDefault = Colors.blue;

  // Refresh Indicator
  static const Color refreshIndicatorColor = Colors.blue;
}
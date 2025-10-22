import 'package:flutter/material.dart';

/// Responsive utility class for handling different screen sizes
class ResponsiveUtils {
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1024;
  static const double desktopBreakpoint = 1440;

  /// Get current screen size category
  static ScreenSize getScreenSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < mobileBreakpoint) {
      return ScreenSize.mobile;
    } else if (width < tabletBreakpoint) {
      return ScreenSize.tablet;
    } else if (width < desktopBreakpoint) {
      return ScreenSize.desktop;
    } else {
      return ScreenSize.largeDesktop;
    }
  }

  /// Get responsive padding based on screen size
  static EdgeInsets getResponsivePadding(BuildContext context) {
    final screenSize = getScreenSize(context);

    switch (screenSize) {
      case ScreenSize.mobile:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 16);
      case ScreenSize.tablet:
        return const EdgeInsets.symmetric(horizontal: 32, vertical: 24);
      case ScreenSize.desktop:
        return const EdgeInsets.symmetric(horizontal: 64, vertical: 32);
      case ScreenSize.largeDesktop:
        return const EdgeInsets.symmetric(horizontal: 128, vertical: 48);
    }
  }

  /// Get responsive margin based on screen size
  static EdgeInsets getResponsiveMargin(BuildContext context) {
    final screenSize = getScreenSize(context);

    switch (screenSize) {
      case ScreenSize.mobile:
        return const EdgeInsets.symmetric(horizontal: 16);
      case ScreenSize.tablet:
        return const EdgeInsets.symmetric(horizontal: 24);
      case ScreenSize.desktop:
        return const EdgeInsets.symmetric(horizontal: 48);
      case ScreenSize.largeDesktop:
        return const EdgeInsets.symmetric(horizontal: 96);
    }
  }

  /// Get responsive font size based on screen size
  static double getResponsiveFontSize(BuildContext context, double baseSize) {
    final screenSize = getScreenSize(context);

    switch (screenSize) {
      case ScreenSize.mobile:
        return baseSize;
      case ScreenSize.tablet:
        return baseSize * 1.1;
      case ScreenSize.desktop:
        return baseSize * 1.2;
      case ScreenSize.largeDesktop:
        return baseSize * 1.3;
    }
  }

  /// Get responsive icon size based on screen size
  static double getResponsiveIconSize(BuildContext context, double baseSize) {
    final screenSize = getScreenSize(context);

    switch (screenSize) {
      case ScreenSize.mobile:
        return baseSize;
      case ScreenSize.tablet:
        return baseSize * 1.1;
      case ScreenSize.desktop:
        return baseSize * 1.2;
      case ScreenSize.largeDesktop:
        return baseSize * 1.3;
    }
  }

  /// Get responsive avatar radius based on screen size
  static double getResponsiveAvatarRadius(BuildContext context, double baseRadius) {
    final screenSize = getScreenSize(context);

    switch (screenSize) {
      case ScreenSize.mobile:
        return baseRadius;
      case ScreenSize.tablet:
        return baseRadius * 1.1;
      case ScreenSize.desktop:
        return baseRadius * 1.2;
      case ScreenSize.largeDesktop:
        return baseRadius * 1.3;
    }
  }

  /// Get responsive card padding based on screen size
  static EdgeInsets getResponsiveCardPadding(BuildContext context) {
    final screenSize = getScreenSize(context);

    switch (screenSize) {
      case ScreenSize.mobile:
        return const EdgeInsets.all(16);
      case ScreenSize.tablet:
        return const EdgeInsets.all(20);
      case ScreenSize.desktop:
        return const EdgeInsets.all(24);
      case ScreenSize.largeDesktop:
        return const EdgeInsets.all(32);
    }
  }

  /// Get responsive app bar height based on screen size
  static double getResponsiveAppBarHeight(BuildContext context, double baseHeight) {
    final screenSize = getScreenSize(context);

    switch (screenSize) {
      case ScreenSize.mobile:
        return baseHeight;
      case ScreenSize.tablet:
        return baseHeight * 1.1;
      case ScreenSize.desktop:
        return baseHeight * 1.2;
      case ScreenSize.largeDesktop:
        return baseHeight * 1.3;
    }
  }

  /// Check if current screen is mobile
  static bool isMobile(BuildContext context) => getScreenSize(context) == ScreenSize.mobile;

  /// Check if current screen is tablet
  static bool isTablet(BuildContext context) => getScreenSize(context) == ScreenSize.tablet;

  /// Check if current screen is desktop
  static bool isDesktop(BuildContext context) =>
      getScreenSize(context) == ScreenSize.desktop || getScreenSize(context) == ScreenSize.largeDesktop;

  /// Check if current screen is large desktop
  static bool isLargeDesktop(BuildContext context) => getScreenSize(context) == ScreenSize.largeDesktop;
}

enum ScreenSize {
  mobile,
  tablet,
  desktop,
  largeDesktop,
}
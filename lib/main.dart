import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/profile_provider.dart';
import 'providers/settings_provider.dart';
import 'screens/settings_screen.dart';
import 'screens/edit_profile_screen.dart';
import 'screens/qr_code_screen.dart';
import 'screens/achievements_screen.dart';
import 'screens/testimonials_screen.dart';
import 'screens/search_screen.dart';
import 'screens/onboarding_screen.dart';
import 'services/profile_service.dart';
import 'shared/utils/responsive_utils.dart';
import 'device/mobile/screens/profile_screen.dart' as mobile;
import 'device/tablet/screens/profile_screen.dart' as tablet;
import 'device/desktop/screens/profile_screen.dart' as desktop;

/// Responsive layout widget that chooses the appropriate screen based on device type
class ResponsiveLayout extends StatelessWidget {
  final Widget mobileLayout;
  final Widget tabletLayout;
  final Widget desktopLayout;

  const ResponsiveLayout({
    super.key,
    required this.mobileLayout,
    required this.tabletLayout,
    required this.desktopLayout,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenSize = ResponsiveUtils.getScreenSize(context);

        switch (screenSize) {
          case ScreenSize.mobile:
            return mobileLayout;
          case ScreenSize.tablet:
            return tabletLayout;
          case ScreenSize.desktop:
          case ScreenSize.largeDesktop:
            return desktopLayout;
          default:
            return mobileLayout; // Fallback to mobile
        }
      },
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final isFirstTime = await ProfileService.isFirstTime();
  runApp(MyApp(isFirstTime: isFirstTime));
}

class MyApp extends StatelessWidget {
  final bool isFirstTime;

  const MyApp({super.key, required this.isFirstTime});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProfileProvider()),
        ChangeNotifierProvider(create: (context) => SettingsProvider()),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) {
          return MaterialApp(
            title: 'ProfilePro - Modern Portfolio',
            debugShowCheckedModeBanner: false,
            theme: settingsProvider.getLightTheme(),
            darkTheme: settingsProvider.getDarkTheme(),
            themeMode: settingsProvider.themeMode,
            home: isFirstTime
                ? const OnboardingScreen()
                : ResponsiveLayout(
                    mobileLayout: const mobile.MobileProfileScreen(),
                    tabletLayout: const tablet.TabletProfileScreen(),
                    desktopLayout: const desktop.DesktopProfileScreen(),
                  ),
            routes: {
              '/profile': (context) => ResponsiveLayout(
                mobileLayout: const mobile.MobileProfileScreen(),
                tabletLayout: const tablet.TabletProfileScreen(),
                desktopLayout: const desktop.DesktopProfileScreen(),
              ),
              '/settings': (context) => const SettingsScreen(),
              '/edit-profile': (context) => const EditProfileScreen(),
              '/qr-code': (context) => const QrCodeScreen(),
              '/achievements': (context) => const AchievementsScreen(),
              '/testimonials': (context) => const TestimonialsScreen(),
              '/search': (context) => const SearchScreen(),
              '/onboarding': (context) => const OnboardingScreen(),
            },
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  padding: ResponsiveUtils.getResponsivePadding(context),
                ),
                child: child!,
              );
            },
          );
        },
      ),
    );
  }
}


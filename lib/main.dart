import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/profile_provider.dart';
import 'providers/settings_provider.dart';
import 'screens/profile_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/edit_profile_screen.dart';
import 'screens/qr_code_screen.dart';
import 'screens/achievements_screen.dart';
import 'screens/testimonials_screen.dart';
import 'screens/search_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
            home: const ProfileScreen(),
            routes: {
              '/settings': (context) => const SettingsScreen(),
              '/edit-profile': (context) => const EditProfileScreen(),
              '/qr-code': (context) => const QrCodeScreen(),
              '/achievements': (context) => const AchievementsScreen(),
              '/testimonials': (context) => const TestimonialsScreen(),
              '/search': (context) => const SearchScreen(),
            },
          );
        },
      ),
    );
  }
}


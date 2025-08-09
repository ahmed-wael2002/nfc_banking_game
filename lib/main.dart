import 'package:flutter/material.dart';
import 'package:nfc/service_locator.dart';
import 'package:nfc/features/home/presentation/pages/home_page.dart';
import 'package:nfc/core/theme/app_colors.dart';
import 'package:nfc/core/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setUpServices();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ultimate Banking Game',
      theme: _buildBlackRedTheme(),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

ThemeData _buildBlackRedTheme() {
  const Color primaryRed = AppColors.brightRed; // Accent red
  const Color darkBackground = Colors.black;
  const Color darkSurface = Color(0xFF101010);

  final ColorScheme colorScheme = const ColorScheme(
    brightness: Brightness.dark,
    primary: primaryRed,
    onPrimary: Colors.white,
    secondary: primaryRed,
    onSecondary: Colors.white,
    error: AppColors.red,
    onError: Colors.white,
    background: darkBackground,
    onBackground: Colors.white,
    surface: darkSurface,
    onSurface: Colors.white,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: darkBackground,
    textTheme: AppTextTheme.appTextTheme.apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: darkBackground,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: AppTextStyles.titleMediumTextStyle40.copyWith(
        color: Colors.white,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryRed,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryRed,
        side: const BorderSide(color: primaryRed, width: 1.5),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white10,
      hintStyle: const TextStyle(color: Colors.white70),
      labelStyle: const TextStyle(color: Colors.white70),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryRed, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryRed, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.red, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.red, width: 2),
      ),
    ),
    iconTheme: const IconThemeData(color: primaryRed),
    dividerColor: Colors.white12,
  );
}

import './features/splash/splash_screen.dart';
import './provider/theme_provider.dart';
import './service/notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/home/home_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // await initializeNotifications();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget  {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final themeMode = ref.watch(themeModeProvider);


    return MaterialApp(
      title: 'Precious Metals Tracker',
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      themeMode: themeMode,// Automatically switches based on system preference
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }

  ThemeData _buildLightTheme() {
    final colorScheme = ColorScheme.light(
      primary: const Color(0xFF634106),
      secondary: const Color(0xFFFFB300),
      tertiary: const Color(0xFFC0C0C0),
      surface: Colors.white,
      surfaceContainerHighest: const Color(0xFFF5F5F5),
      onPrimary: Colors.white,
      onSecondary: Colors.black87,
      onSurface: const Color(0xFF212121),
      error: const Color(0xFFD32F2F),
      onError: Colors.white,
    );
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,




      // Color Scheme - Professional Financial Theme
      colorScheme: ColorScheme.light(
        primary: const Color(0xFF634106), // Deep blue - trust and stability
        secondary: const Color(0xFFFFB300), // Gold accent
        tertiary: const Color(0xFFC0C0C0), // Silver accent
        surface: Colors.white,
        surfaceContainerHighest: const Color(0xFFF5F5F5),
        onPrimary: Colors.white,
        onSecondary: Colors.black87,
        onSurface: const Color(0xFF212121),
        error: const Color(0xFFD32F2F),
        onError: Colors.white,
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurface.withOpacity(0.6),
        type: BottomNavigationBarType.fixed,
      ),

      // AppBar Theme
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color(0xFF634106),
        foregroundColor: Colors.white,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: Colors.white,
      ),

      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Color(0xFF634106),
          letterSpacing: -0.5,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Color(0xFF212121),
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xFF424242),
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: Color(0xFF212121),
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: Color(0xFF616161),
        ),
        labelSmall: TextStyle(
          fontSize: 12,
          color: Color(0xFF9E9E9E),
          letterSpacing: 0.4,
        ),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF634106), width: 2),
        ),
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: Color(0xFFE0E0E0),
        thickness: 1,
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Premium Dark Color Scheme - Charcoal/Slate base with warm accents
      colorScheme: ColorScheme.dark(
        primary: const Color(0xFFD4A76A), // Warm gold - main accent
        secondary: const Color(0xFF6AB7D4), // Cool blue - secondary accent
        tertiary: const Color(0xFFA6D4A7), // Muted green - tertiary accent
        surface: const Color(0xFF1A1F2E), // Deep navy/charcoal
        surfaceContainer: const Color(0xFF252B3C), // Lighter container
        surfaceContainerHighest: const Color(0xFF2F364A), // Highest surface
        surfaceVariant: const Color(0xFF2A3142), // Variant for cards
        inverseSurface: const Color(0xFFF0F2F5), // For contrast elements
        outline: const Color(0xFF4A5568), // Borders and dividers
        outlineVariant: const Color(0xFF3A4255), // Subtle borders
        shadow: Colors.black.withOpacity(0.4),
        scrim: Colors.black.withOpacity(0.6),
        primaryContainer: const Color(0xFF3A2C1A), // Primary container
        onPrimaryContainer: const Color(0xFFF0D7B2),
        secondaryContainer: const Color(0xFF1A2C3A), // Secondary container
        onSecondaryContainer: const Color(0xFFB3E0F2),
        tertiaryContainer: const Color(0xFF1A2C1A), // Tertiary container
        onTertiaryContainer: const Color(0xFFC3E8C3),
        onPrimary: Colors.black87,
        onSecondary: Colors.black87,
        onSurface: const Color(0xFFE2E6EF), // Text on surfaces
        onSurfaceVariant: const Color(0xFFC1C6D3), // Secondary text
        error: const Color(0xFFFF6B6B), // Soft red
        onError: Colors.black,
        background: const Color(0xFF121826), // App background (darker than surface)
        onBackground: const Color(0xFFE2E6EF),
      ),

      // Scaffold Background
      scaffoldBackgroundColor: const Color(0xFF121826),

      // AppBar Theme
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 2,
        backgroundColor: const Color(0xFF1A1F2E),
        foregroundColor: const Color(0xFFE2E6EF),
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black.withOpacity(0.3),
        titleTextStyle: const TextStyle(
          color: Color(0xFFE2E6EF),
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: const Color(0xFF1A1F2E),
        selectedItemColor: const Color(0xFFD4A76A),
        unselectedItemColor: const Color(0xFF8A95A7),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        enableFeedback: true,
      ),

      // Card Theme
      cardTheme: CardThemeData(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: const Color(0xFF252B3C),
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black.withOpacity(0.3),
        margin: const EdgeInsets.all(8),
      ),

      // Text Theme
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: const Color(0xFFD4A76A),
          letterSpacing: -0.5,
          shadows: [
            Shadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 2,
            ),
          ],
        ),
        displayMedium: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Color(0xFFE2E6EF),
        ),
        displaySmall: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Color(0xFFE2E6EF),
        ),
        titleLarge: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Color(0xFFE2E6EF),
          letterSpacing: 0.15,
        ),
        titleMedium: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xFFC1C6D3),
          letterSpacing: 0.1,
        ),
        titleSmall: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFFC1C6D3),
          letterSpacing: 0.1,
        ),
        bodyLarge: const TextStyle(
          fontSize: 16,
          color: Color(0xFFE2E6EF),
          height: 1.5,
        ),
        bodyMedium: const TextStyle(
          fontSize: 14,
          color: Color(0xFFC1C6D3),
          height: 1.5,
        ),
        bodySmall: const TextStyle(
          fontSize: 12,
          color: Color(0xFF8A95A7),
          height: 1.4,
        ),
        labelLarge: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFFE2E6EF),
          letterSpacing: 0.5,
        ),
        labelMedium: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Color(0xFF8A95A7),
          letterSpacing: 0.4,
        ),
        labelSmall: const TextStyle(
          fontSize: 11,
          color: Color(0xFF6B7B95),
          letterSpacing: 0.4,
        ),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2D3748),
          foregroundColor: const Color(0xFFE2E6EF),
          surfaceTintColor: Colors.transparent,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
          shadowColor: Colors.black.withOpacity(0.3),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF252B3C),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF3A4255), width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF3A4255), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFD4A76A), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFFF6B6B), width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFFF6B6B), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: const TextStyle(
          color: Color(0xFF8A95A7),
          fontSize: 14,
        ),
        labelStyle: const TextStyle(
          color: Color(0xFFC1C6D3),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        floatingLabelStyle: const TextStyle(
          color: Color(0xFFD4A76A),
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        errorStyle: const TextStyle(
          color: Color(0xFFFF6B6B),
          fontSize: 12,
        ),
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: Color(0xFF3A4255),
        thickness: 1,
        space: 0,
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: const Color(0xFF252B3C),
        surfaceTintColor: Colors.transparent,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        titleTextStyle: const TextStyle(
          color: Color(0xFFE2E6EF),
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        contentTextStyle: const TextStyle(
          color: Color(0xFFC1C6D3),
          fontSize: 14,
        ),
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFF2F364A),
        selectedColor: const Color(0xFFD4A76A).withOpacity(0.2),
        disabledColor: const Color(0xFF3A4255),
        labelStyle: const TextStyle(color: Color(0xFFC1C6D3)),
        secondaryLabelStyle: const TextStyle(color: Colors.black),
        brightness: Brightness.dark,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        side: BorderSide.none,
      ),

      // List Tile Theme
      listTileTheme: ListTileThemeData(
        tileColor: const Color(0xFF252B3C),
        textColor: const Color(0xFFE2E6EF),
        iconColor: const Color(0xFFC1C6D3),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        selectedTileColor: const Color(0xFF2D3748),
        selectedColor: const Color(0xFFD4A76A),
      ),

      // Progress Indicator Theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: Color(0xFFD4A76A),
        linearTrackColor: Color(0xFF3A4255),
        circularTrackColor: Color(0xFF3A4255),
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: const Color(0xFFD4A76A),
        foregroundColor: Colors.black,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // Bottom Sheet Theme
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Color(0xFF252B3C),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        elevation: 8,
        modalElevation: 8,
      ),
    );
  }
}
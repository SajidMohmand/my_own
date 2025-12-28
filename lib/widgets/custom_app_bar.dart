import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../provider/theme_provider.dart';

class CustomAppBar extends ConsumerWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final timeFormat = DateFormat('hh:mm a');
    final dateFormat = DateFormat('dd MMM yyyy');
    final screenHeight = MediaQuery.of(context).size.height;
    final dayFormat = DateFormat('EEE');

    final isDark = themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 8,
        vertical: screenHeight * 0.01,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: screenHeight * 0.015, // Slightly reduced for better fit
      ),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.05)
            : Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.1)
              : Colors.black.withOpacity(0.05),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// TIME + DATE
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                timeFormat.format(DateTime.now()),
                style: TextStyle(
                  fontSize: screenHeight * 0.015,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              SizedBox(height: screenHeight * 0.003),
              Text(
    '${dateFormat.format(DateTime.now())}\n${dayFormat.format(DateTime.now())}',// Mon, 26 Dec 2025
                style: TextStyle(
                  fontSize: screenHeight * 0.015,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withOpacity(0.6),
                ),
              ),
            ],
          ),

          /// LOGO WITH TEXT
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "assets/icon/splash_only.png",
                height: screenHeight * 0.05, // slightly smaller
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
              ),
              SizedBox(height: screenHeight * 0.003),
              Text(
                "AMBER ZAHRAT",
                style: TextStyle(
                  fontSize: screenHeight * 0.016,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                  color: Theme.of(context).colorScheme.primary,
                  height: 0.95, // slightly tighter
                ),
              ),
              SizedBox(height: screenHeight * 0.004),
              Text(
                "JEWELLERS",
                style: TextStyle(
                  fontSize: screenHeight * 0.012,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2.5,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  height: 0.95, // slightly tighter
                ),
              ),
            ],
          ),


          /// THEME TOGGLE
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(
                isDark ? Icons.light_mode : Icons.dark_mode,
                size: screenHeight * 0.024,
              ),
              tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              onPressed: () {
                ref.read(themeModeProvider.notifier).toggleTheme();
              },
            ),
          ),
        ],
      ),
    );
  }
}
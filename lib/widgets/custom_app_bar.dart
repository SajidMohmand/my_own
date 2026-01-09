import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:url_launcher/url_launcher.dart';

import '../provider/theme_provider.dart';

class CustomAppBar extends ConsumerWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final screenHeight = MediaQuery.of(context).size.height;

    final isDark = themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    final timeFormat = DateFormat('hh:mm a');

    final uaeTime = tz.TZDateTime.now(tz.getLocation('Asia/Dubai'));
    final bdTime = tz.TZDateTime.now(tz.getLocation('Asia/Dhaka'));
    final dateFormat = DateFormat('dd MMM yyyy');
    final dayFormat = DateFormat('EEE');

    return Container(
      height: screenHeight * 0.1,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xff020300) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.1)
              : Colors.black.withOpacity(0.05),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          /// 🌍 LEFT — TIMES
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _timeRow(context, 'AE', uaeTime),
                const SizedBox(height: 4),
                _timeRow(context, 'BD', bdTime),
              ],
            ),
          ),

          /// 🖼 CENTER — LOGO
          Image.asset(
            'assets/icon/splash.png',
            height: screenHeight * 0.25,
            fit: BoxFit.contain,
          ),

          /// ⚙ RIGHT — ACTIONS
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _iconButton(
                    context,
                    icon: Icons.person,
                    isFa: true,
                    size: 50,
                    circular: true,
                    removeBg: true,
                    onTap: () async {
                      // your action here
                    },
                  ),

                  _iconButton(
                    context,
                    icon: isDark ? Icons.light_mode : Icons.dark_mode,
                    size: 30,
                    onTap: () {
                      ref.read(themeModeProvider.notifier).toggleTheme();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _timeRow(
      BuildContext context,
      String code,
      DateTime dateTime,
      ) {
    final dateFormat = DateFormat('dd, MMM yyyy');
    final timeFormat = DateFormat('hh:mma');

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipOval(
          child: SizedBox(
            height: 30, // Make height = width for perfect circle
            width: 30,
            child: CountryFlag.fromCountryCode(code),
          ),
        ),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dateFormat.format(dateTime),
              style: TextStyle(
                fontSize: 11,
                color: isDark
                    ? Colors.white
                    : Colors.black,
              ),
            ),
            Text(
              timeFormat.format(dateTime),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? Colors.white
                    : Colors.black,
              ),
            ),
          ],
        ),
      ],
    );
  }


  Widget _iconButton(
      BuildContext context, {
        required IconData icon,
        required VoidCallback onTap,
        Color? color, // background color
        bool isFa = false,
        double size = 30, // total tap area
        bool circular = false, // make it circular
        bool removeBg = false, // remove background
      }) {
    return SizedBox(
      width: removeBg ? size-15 : size,
      height: size,
      child: Material(
        color: removeBg ? Colors.transparent : (color ?? Theme.of(context).colorScheme.primaryContainer),
        shape: circular ? const CircleBorder() : RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          onTap: onTap,
          borderRadius: circular ? null : BorderRadius.circular(12),
          customBorder: circular ? const CircleBorder() : null,
          child: Center(
            child: isFa
                ? FaIcon(icon, size: size * 0.6, color: removeBg ? Theme.of(context).iconTheme.color : Colors.white)
                : Icon(icon, size: size * 0.6, color: removeBg ? Theme.of(context).iconTheme.color : Colors.white),
          ),
        ),
      ),
    );
  }

}

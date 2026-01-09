import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';


class TopAppBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabChanged;

  const TopAppBar({
    super.key,
    required this.selectedIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isSmall = constraints.maxWidth < 360;

          Widget tab({
            required String title,
            required bool active,
            required VoidCallback onTap,
            BorderRadius? radius,
          }) {
            return GestureDetector(
              onTap: onTap,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmall ? 8 : 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: active
                      ? const Color(0xFF967B2E)
                      : isDark
                      ? Colors.white
                      : Colors.transparent,
                  borderRadius: radius,
                ),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: isSmall ? 12 : 14,
                    fontWeight: FontWeight.bold,
                    color: active
                        ? Colors.white
                        : isDark
                        ? const Color(0xFF967B2E)
                        : Colors.white,
                  ),
                ),
              ),
            );
          }

          return Row(
            children: [
              const SizedBox(width: 30),

              // Phone
              GestureDetector(
                onTap: () async {
                  final uri = Uri(scheme: 'tel', path: '+971123456789');
                  await launchUrl(uri);
                },
                child: Icon(
                  Icons.phone_in_talk,
                  color: Colors.white,
                  size: isSmall ? 20 : 24,
                ),
              ),

              // Center Tabs
              Expanded(
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      tab(
                        title: "LIVE RATES",
                        active: selectedIndex == 0,
                        onTap: () => onTabChanged(0),
                        radius: const BorderRadius.only(
                          topLeft: Radius.circular(6),
                          bottomLeft: Radius.circular(6),
                        ),
                      ),
                      tab(
                        title: "PRODUCTS",
                        active: selectedIndex == 1,
                        onTap: () => onTabChanged(1),
                        radius: const BorderRadius.only(
                          topRight: Radius.circular(6),
                          bottomRight: Radius.circular(6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // WhatsApp
              InkWell(
                onTap: openWhatsapp,
                child: const Icon(
                  FontAwesomeIcons.whatsapp,
                  color: Colors.green,
                  size: 26,
                ),
              ),

              const SizedBox(width: 30),
            ],
          );
        },
      ),
    );
  }

  Future<void> openWhatsapp() async {
    final phone = "971566923208";
    final message = "Hello, I want more information";

    final appUri = Uri.parse(
      "whatsapp://send?phone=$phone&text=${Uri.encodeComponent(message)}",
    );
    final webUri = Uri.parse(
      "https://wa.me/$phone?text=${Uri.encodeComponent(message)}",
    );

    try {
      await launchUrl(appUri, mode: LaunchMode.externalApplication);
    } catch (_) {
      await launchUrl(webUri, mode: LaunchMode.externalApplication);
    }
  }
}

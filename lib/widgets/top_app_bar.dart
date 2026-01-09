import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';



class TopAppBar extends StatelessWidget {
  const TopAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;


    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isSmall = constraints.maxWidth < 360;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left icon
              SizedBox(width: 30),
              GestureDetector(
                onTap: () async {
                  final Uri phoneUri = Uri(scheme: 'tel', path: '+971123456789'); // Replace with your phone number
                  if (await canLaunchUrl(phoneUri)) {
                    await launchUrl(phoneUri);
                  } else {
                    // Handle error, maybe show a snackbar
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Cannot make a call')),
                    );
                  }
                },
                child: Icon(
                  Icons.phone_in_talk,
                  color: Colors.white,
                  size: isSmall ? 20 : 24,
                ),
              ),

              // Center content
              Expanded(
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isSmall ? 8 : 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white
                              : Colors.transparent,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(6),
                            bottomLeft: Radius.circular(6),
                          ),
                        ),
                        child: Text(
                          "LIVE RATES",
                          style: TextStyle(
                            fontSize: isSmall ? 12 : 14,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? const Color(0xFF967B2E)
                                : Colors.white,
                          ),
                        ),
                      ),

                      // PRODUCTS
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isSmall ? 8 : 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF967B2E)
                              : Colors.transparent,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(6),
                            bottomRight: Radius.circular(6),
                          ),
                        ),
                        child: Text(
                          "PRODUCTS",
                          style: TextStyle(
                            fontSize: isSmall ? 12 : 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Right icon
              InkWell(
                onTap: () {
                  openWhatsapp();
                },
                child: Icon(
                  FontAwesomeIcons.whatsapp,
                  color: Colors.green,
                  size: isSmall ? 22 : 26,
                ),
              ),

              SizedBox(width: 30),
            ],
          );
        },
      ),
    );
  }

  Future<void> openWhatsapp() async {
    final phone = "971566923208";
    final message = "Hello, I want more information";

    final Uri appUri = Uri.parse(
      "whatsapp://send?phone=$phone&text=${Uri.encodeComponent(message)}",
    );

    final Uri webUri = Uri.parse(
      "https://wa.me/$phone?text=${Uri.encodeComponent(message)}",
    );

    try {
      await launchUrl(appUri, mode: LaunchMode.externalApplication);
    } catch (_) {
      await launchUrl(webUri, mode: LaunchMode.externalApplication);
    }
  }

}

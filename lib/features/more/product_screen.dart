import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widgets/custom_app_bar.dart';
import '../../widgets/top_app_bar.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(

      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10,top: 5),
              child: Align(
                alignment: Alignment.topLeft,
                child: InkWell(
                    onTap: () =>{
                      Navigator.pop(context)
                    },
                    child: Icon(Icons.arrow_back)),
              ),
            ),
            // App Bar Section (More compact)
            SizedBox(
              height: screenHeight * 0.15,
              child: CustomAppBar(), // Assuming CustomAppBar is defined elsewhere
            ),

            SizedBox(height: 5),
            TopAppBar(),

            SizedBox(height: 12),

            // Gold Items List (More compact)
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ListView(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildGoldItem(
                      "assets/images/gold_trent_images/5.jpg",
                      "Kilo Bar",
                      purity: "995, 999.9",
                      shape: "Rectangle",
                      itemHeight: 80,
                    ),
                    const SizedBox(height: 2),
                    _buildGoldItem(
                      "assets/images/gold_trent_images/4.jpg",
                      "Investment Bar",
                      purity: "999.9",
                      shape: "Rectangle",
                      itemHeight: 80,
                    ),
                    const SizedBox(height: 2),
                    _buildGoldItem(
                      "assets/images/gold_trent_images/1.jpg",
                      "TT Bar",
                      purity: "999",
                      shape: "Rectangle",
                      itemHeight: 80,
                    ),
                    const SizedBox(height: 2),
                    _buildGoldItem(
                      "assets/images/gold_trent_images/3.jpg",
                      "Jewellery",
                      purity: "18k, 21k, 22k",
                      itemHeight: 80,
                    ),
                    const SizedBox(height: 2),
                    _buildGoldItem(
                      "assets/images/gold_trent_images/2.jpg",
                      "Coin",
                      purity: "995, 999.9",
                      shape: "Round",
                      itemHeight: 80,
                    ),

                    // Bottom Info Bar (Contact/Footer)
                    Container(
                      margin: const EdgeInsets.only(top: 16, bottom: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: isDark ? Color(0xffCFAA40) : Colors.grey.shade200,
                      ),
                      child: Center(child: Text("For more information please click \"Shop\" Button", style: TextStyle(color: isDark ? Colors.white : Colors.black),)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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

  Widget _buildGoldItem(
      String imagePath,
      String title, {
        String purity = "24K",
        String? shape = "",
        double itemHeight = 85,
      }) {
    return InkWell(
      onTap: _openShop,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: itemHeight,
        decoration: BoxDecoration(
          color: const Color(0xff3D3214),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // IMAGE SECTION - Better fitted
            Container(
              width: itemHeight, // Square container matching height
              decoration: const BoxDecoration(
                color: Color(0xFFFFD54F),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover, // Changed to cover for better filling
                  width: itemHeight,
                  height: itemHeight,
                ),
              ),
            ),

            const SizedBox(width: 10),

            // TEXT SECTION - More compact
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 2),

                    Text(
                      "Purity: $purity",
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.white70,
                      ),
                    ),

                    if (shape != null && shape!.isNotEmpty)
                      Text(
                        "Shape: $shape",
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.white70,
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // SHOP BUTTON - More compact
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: const Color(0xFFFFD54F),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: const Text(
                  "SHOP",
                  style: TextStyle(
                    color: Color(0xffFFFFFF),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openShop() async {
    const url = "https://your-deployed-site.com";

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }
}

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductsTab extends StatelessWidget {
  const ProductsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        const SizedBox(height: 12),

        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            physics: const BouncingScrollPhysics(),
            children: [
              _buildGoldItem(
                "assets/images/gold_trent_images/5.jpg",
                "Kilo Bar",
                purity: "995, 999.9",
                shape: "Rectangle",
              ),
              _buildGoldItem(
                "assets/images/gold_trent_images/4.jpg",
                "Investment Bar",
                purity: "999.9",
                shape: "Rectangle",
              ),
              _buildGoldItem(
                "assets/images/gold_trent_images/1.jpg",
                "TT Bar",
                purity: "999",
                shape: "Rectangle",
              ),
              _buildGoldItem(
                "assets/images/gold_trent_images/3.jpg",
                "Jewellery",
                purity: "18k, 21k, 22k",
              ),
              _buildGoldItem(
                "assets/images/gold_trent_images/2.jpg",
                "Coin",
                purity: "995, 999.9",
                shape: "Round",
              ),

              Container(
                margin: const EdgeInsets.only(top: 8, bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                color: isDark ? const Color(0xffCFAA40) : Colors.grey.shade200,
                child: Center(
                  child: Text(
                    'For more information please click "SHOP" button',
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGoldItem(
      String imagePath,
      String title, {
        String purity = "24K",
        String? shape,
      }) {
    return InkWell(
      onTap: _openShop,
      child: Container(
        height: 70,
        margin: const EdgeInsets.only(bottom: 2),
        decoration: BoxDecoration(
          color: const Color(0xff3D3214),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Image.asset(imagePath, width: 80, fit: BoxFit.cover),

            const SizedBox(width: 10),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Purity: $purity",
                    style: const TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                  if (shape != null)
                    Text(
                      "Shape: $shape",
                      style:
                      const TextStyle(color: Colors.white70, fontSize: 11),
                    ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD54F),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  "SHOP",
                  style: TextStyle(
                    color: Colors.white,
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
    await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
  }
}

import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'About Us',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Company Name
            Center(
              child: Text(
                'Amber Zahrat Jewellers',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber[800],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Subtitle
            Center(
              child: Text(
                'Dubai Gold Souq • Established 1985',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Section Title
            Text(
              'Who We Are',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.amber[900],
              ),
            ),
            const SizedBox(height: 12),

            // Description
            Text(
              'Amber Zahrat Jewellers is a trusted bullion gold wholesaler based in the heart of the Dubai Gold Souq. '
                  'We specialize in the wholesale buying and selling of high-quality gold bullion, offering transparent pricing, reliability, and professional service to traders and businesses. '
                  'With a strong presence in Dubai’s gold market, we are committed to integrity, accuracy, and long-term partnerships.',
              style: const TextStyle(
                fontSize: 16,
                height: 1.6,
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 24),

            // Mission Statement
            Text(
              'Our Mission',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.amber[900],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'To be the most trusted partner in precious metals by delivering unparalleled value, security, and expertise to our global clientele.',
              style: const TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                height: 1.6,
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 24),

            // Contact Info
            Text(
              'Contact Us',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.amber[900],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '📍 Gold Souq - Al Khor St - Al Daghaya - Deira - Dubai\n'
                  '📞 +971566923208\n'
                  '✉️ amberjewellers2@gmail.com',
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

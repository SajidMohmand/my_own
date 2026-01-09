import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BookingDeskScreen extends StatelessWidget {
  const BookingDeskScreen({super.key});

  // Contact info
  final String shopName = "Amber Zahrat Jewellers L.L.C";
  final String building = "MAJD ALKHATIB BUILDING";
  final String shopNo = "R-3";
  final String address = "Gold Souq - Al Khor St - Al Daghaya - Deira - Dubai";
  final String googleMapUrl = "https://maps.app.goo.gl/AFQNHHhk5KUfa2Jb7?g_st=ipc";
  final String phone = "+971566923208";
  final String email = "amberjewellers2@gmail.com";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Booking Desk"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(shopName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Building: $building"),
            Text("Shop No: $shopNo"),
            Text("Address: $address"),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.red),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () async {
                    if (await canLaunchUrl(Uri.parse(googleMapUrl))) {
                      await launchUrl(Uri.parse(googleMapUrl));
                    }
                  },
                  child: const Text(
                    "View on Google Maps",
                    style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.phone, color: Colors.green),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () async {
                    final Uri phoneUri = Uri(scheme: 'tel', path: phone);
                    if (await canLaunchUrl(phoneUri)) {
                      await launchUrl(phoneUri);
                    }
                  },
                  child: Text(
                    phone,
                    style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.email, color: Colors.orange),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () async {
                    final Uri emailUri = Uri(
                      scheme: 'mailto',
                      path: email,
                    );
                    if (await canLaunchUrl(emailUri)) {
                      await launchUrl(emailUri);
                    }
                  },
                  child: Text(
                    email,
                    style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

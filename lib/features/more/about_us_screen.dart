import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leadingWidth: 120,
        leading: SizedBox(
          width: 120, // give Row enough space
          child: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.ice_skating_outlined),
              ],
            ),
          ),
        ),

        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                'About Us',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'This app provides metal prices, alerts, and market updates.\n\n'
              'Version: 1.0.0',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

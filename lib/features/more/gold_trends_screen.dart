import 'package:flutter/material.dart';

class GoldTrendsScreen extends StatelessWidget {
  const GoldTrendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gold Trends")),
      body: const Center(child: Text("Gold price trend chart coming soon")),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/metal_rate.dart';
import '../live_rates/providers/live_rates_provider.dart';

class GoldAnalysisCard extends ConsumerWidget {
  const GoldAnalysisCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(liveRatesProvider);

    // Find GOLD SPOT (1 OZ)
    final gold = state.metals.firstWhere(
          (m) => m.name == "GOLD SPOT OZ",
      orElse: () => MetalRateHelper.empty(),
    );

    if (state.isLoading || gold.price == 0) {
      return _loading();
    }

    final high = gold.high;
    final low = gold.low;
    final close = gold.price;
    final current = gold.price;

    // 🧮 Pivot math
    final pivot = (high + low + close) / 3;
    final r1 = (2 * pivot) - low;
    final s1 = (2 * pivot) - high;
    final r2 = pivot + (high - low);
    final s2 = pivot - (high - low);

    final bullish = current > pivot;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _header(),
          const SizedBox(height: 12),

          _row("Resistance 2", r2, Colors.redAccent),
          _row("Resistance 1", r1, Colors.red),
          _row("Pivot Point", pivot, Colors.amber),
          _row("Support 1", s1, Colors.green),
          _row("Support 2", s2, Colors.greenAccent),

          const Divider(color: Colors.white24, height: 28),

          _trendRow(bullish),
        ],
      ),
    );
  }

  Widget _header() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        "GOLD MARKET ANALYSIS",
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _row(String label, double value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          Text(
            value.toStringAsFixed(2),
            style: TextStyle(color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _trendRow(bool bullish) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Trend", style: TextStyle(color: Colors.white70)),
        Row(
          children: [
            Icon(
              bullish ? Icons.trending_up : Icons.trending_down,
              color: bullish ? Colors.green : Colors.red,
            ),
            const SizedBox(width: 6),
            Text(
              bullish ? "BULLISH" : "BEARISH",
              style: TextStyle(
                color: bullish ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _loading() {
    return Container(
      height: 220,
      alignment: Alignment.center,
      child: const CircularProgressIndicator(),
    );
  }
}


import 'package:flutter/material.dart';

class LiveRatesScreen extends StatelessWidget {
  const LiveRatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Live Rates"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _rateCard(
              context,
              title: "Gold",
              price: "Rs. 214,500",
              change: "+1,250",
              isUp: true,
              unit: "per tola",
              icon: Icons.trending_up,
              color: Colors.amber,
            ),

            const SizedBox(height: 16),

            _rateCard(
              context,
              title: "Silver",
              price: "Rs. 2,650",
              change: "-30",
              isUp: false,
              unit: "per tola",
              icon: Icons.trending_down,
              color: Colors.grey,
            ),

            const Spacer(),

            Text(
              "Last updated: 2 minutes ago",
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _rateCard(
      BuildContext context, {
        required String title,
        required String price,
        required String change,
        required bool isUp,
        required String unit,
        required IconData icon,
        required Color color,
      }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: color.withOpacity(0.15),
            child: Icon(icon, color: color, size: 30),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),

                const SizedBox(height: 4),

                Text(unit, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                price,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 6),

              Row(
                children: [
                  Icon(
                    isUp ? Icons.arrow_upward : Icons.arrow_downward,
                    size: 16,
                    color: isUp ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    change,
                    style: TextStyle(
                      color: isUp ? Colors.green : Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

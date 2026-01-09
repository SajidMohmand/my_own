import 'package:flutter/material.dart';

import '../models/economic_event.dart';

class EconomicEventCard extends StatelessWidget {
  final EconomicEvent event;

  const EconomicEventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      color: colors.surface,
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: CircleAvatar(
          backgroundColor: _impactColor(event.impact),
          child: Text(event.country.substring(0, 2).toUpperCase()),
        ),
        title: Text(
          event.event,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(event.date),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Actual: ${event.actual}", style: const TextStyle(fontSize: 12)),
            Text("Forecast: ${event.forecast}", style: const TextStyle(fontSize: 12)),
            Text("Previous: ${event.previous}", style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Color _impactColor(String impact) {
    switch (impact.toLowerCase()) {
      case 'high':
        return Colors.redAccent;
      case 'medium':
        return Colors.orangeAccent;
      default:
        return Colors.greenAccent;
    }
  }
}

import 'package:banglatiger2/features/live_rates/providers/gold_price_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GoldPriceWidget extends ConsumerWidget {
  const GoldPriceWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gold = ref.watch(goldPriceProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Gold Price Live')),
      body: Center(
        child: gold == null
            ? const Text(
          'Connecting...',
          style: TextStyle(fontSize: 18),
        )
            : Padding(
          padding: const EdgeInsets.all(16),
          child: Table(
            border: TableBorder.all(color: Colors.grey.shade400),
            defaultVerticalAlignment:
            TableCellVerticalAlignment.middle,
            columnWidths: const {
              0: FlexColumnWidth(1.5),
              1: FlexColumnWidth(1),
              2: FlexColumnWidth(1),
              3: FlexColumnWidth(1),
              4: FlexColumnWidth(1),
            },
            children: [
              _headerRow(),
              _dataRow(gold),
            ],
          ),
        ),
      ),
    );
  }

  TableRow _headerRow() {
    return const TableRow(
      decoration: BoxDecoration(color: Color(0xFFEFEFEF)),
      children: [
        _Cell('Symbol', bold: true),
        _Cell('Bid', bold: true),
        _Cell('Ask', bold: true),
        _Cell('High', bold: true),
        _Cell('Low', bold: true),
      ],
    );
  }

  TableRow _dataRow(gold) {
    return TableRow(
      children: [
        _Cell(gold.symbol),
        _Cell(gold.bid.toStringAsFixed(2)),
        _Cell(gold.ask.toStringAsFixed(2)),
        _Cell(gold.high.toStringAsFixed(2)),
        _Cell(gold.low.toStringAsFixed(2)),
      ],
    );
  }
}

class _Cell extends StatelessWidget {
  final String text;
  final bool bold;

  const _Cell(this.text, {this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

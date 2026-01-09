import 'package:banglatiger2/features/live_rates/providers/gold_price_provider.dart';
import 'package:banglatiger2/features/live_rates/service/web_socket_gold_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/constant_color.dart';
import '../../widgets/custom_app_bar.dart';
import './widgets/moving_welcome_bar.dart';

class WebSocketLiveRatesScreen extends ConsumerWidget {
  const WebSocketLiveRatesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gold = ref.watch(goldPriceProvider); // <-- Watch goldPriceProvider
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.surfaceContainerHighest,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.15, child: CustomAppBar()),
              MovingWelcomeBar(height: screenHeight * 0.06),

              Expanded(
                child: gold == null
                    ? const _LiveRatesShimmer()
                    : _buildBody(context, gold, screenHeight),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(
      BuildContext context,
      GoldPrice gold,
      double screenHeight,
      ) {
    // Wrap the single GoldPrice into a list for UI
    final goldPrices = [
      GoldPriceData(
        symbol: gold.symbol,
        bid: gold.bid,
        ask: gold.ask,
        high: gold.high,
        low: gold.low,
        close: gold.close ?? gold.bid,
        time: gold.time?.toIso8601String() ?? DateTime.now().toIso8601String(),
      )
    ];


    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),

          // Connection status banner (consider connected if gold != null)
          _buildConnectionBanner(context, true, screenHeight),

          const SizedBox(height: 12),

          // Live gold rates
          _buildLiveGoldRates(context, goldPrices, screenHeight),

          const SizedBox(height: 8),

          // All symbols table
          Expanded(
            child: _buildAllSymbolsTable(
              context,
              goldPrices,
              screenHeight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionBanner(
      BuildContext context,
      bool isConnected,
      double screenHeight,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isConnected
            ? Colors.green.withOpacity(0.1)
            : Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isConnected ? Colors.green : Colors.orange,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isConnected ? Icons.check_circle : Icons.cloud_off,
            color: isConnected ? Colors.green : Colors.orange,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            isConnected ? 'Live WebSocket Connected' : 'Reconnecting...',
            style: TextStyle(
              color: isConnected ? Colors.green[700] : Colors.orange[700],
              fontWeight: FontWeight.w600,
              fontSize: screenHeight * 0.016,
            ),
          ),
          const Spacer(),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: isConnected ? Colors.green : Colors.orange,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveGoldRates(
      BuildContext context,
      List<GoldPriceData> goldPrices,
      double screenHeight,
      ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    TextStyle headerStyle = TextStyle(
      fontSize: screenHeight * 0.02,
      fontWeight: FontWeight.w900,
      color: Colors.brown,
    );

    TextStyle labelStyle = TextStyle(
      fontSize: screenHeight * 0.02,
      fontWeight: FontWeight.bold,
    );

    Widget valueWithSymbol(String symbol, double value, double screenHeight) {
      return SizedBox(
        height: screenHeight * 0.085,
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Center(
                child: Text(
                  value.toStringAsFixed(2),
                  style: TextStyle(
                    fontSize: screenHeight * 0.021,
                    fontWeight: FontWeight.w800,
                    color: Colors.green,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Colors.black.withOpacity(0.25),
                      width: 1,
                    ),
                  ),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(12),
                  ),
                  // gradient: isDark
                  //     ? LinearGradient(
                  //   begin: Alignment.bottomRight,
                  //   end: Alignment.topLeft,
                  //   colors: ConstantColor.gold_gradient,
                  // )
                  //     : null,
                ),
                child: Text(
                  symbol,
                  style: TextStyle(
                    fontSize: screenHeight * 0.014,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.brown[700],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget metalRow({
      required String name,
      required GoldPriceData price,
    }) {
      return Container(
        padding: EdgeInsets.symmetric(
          vertical: screenHeight * 0.014,
          horizontal: screenHeight * 0.01,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(flex: 1, child: Text(name, style: labelStyle)),
            Expanded(
              flex: 2,
              child: _borderedValue(
                valueWithSymbol(price.symbol, price.bid, screenHeight),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              flex: 2,
              child: _borderedValue(
                valueWithSymbol(price.symbol, price.ask, screenHeight),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            // gradient: isDark
            //     ? LinearGradient(
            //   begin: Alignment.bottomRight,
            //   end: Alignment.topLeft,
            //   colors: ConstantColor.gold_gradient,
            // )
            //     : null,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: screenHeight * 0.008,
              horizontal: screenHeight * 0.012,
            ),
            child: Row(
              children: [
                Text('Rate', textAlign: TextAlign.center, style: headerStyle),
                Expanded(
                  flex: 2,
                  child: Text(
                    '\$BID (SELL)',
                    textAlign: TextAlign.center,
                    style: headerStyle,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    '\$ASK (BUY)',
                    textAlign: TextAlign.center,
                    style: headerStyle,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.008),
        ...goldPrices.asMap().entries.map((entry) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: entry.key < goldPrices.length - 1
                  ? screenHeight * 0.008
                  : 0,
            ),
            child: metalRow(
              name: 'GOLD\n${entry.value.symbol}',
              price: entry.value,
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _borderedValue(Widget child) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFFF9DF7B),
          width: 0.7,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }

  Widget _buildAllSymbolsTable(
      BuildContext context,
      List<GoldPriceData> prices,
      double screenHeight,
      ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              vertical: screenHeight * 0.02,
              horizontal: screenHeight * 0.01,
            ),
            decoration: BoxDecoration(
              // gradient: isDark
              //     ? LinearGradient(
              //   begin: Alignment.bottomRight,
              //   end: Alignment.topLeft,
              //   colors: ConstantColor.gold_gradient,
              // )
              //     : null,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'SYMBOL',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? Colors.white
                          : Theme.of(context).colorScheme.primary,
                      letterSpacing: 1,
                      fontSize: screenHeight * 0.018,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'BID',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? Colors.white
                          : Theme.of(context).colorScheme.primary,
                      letterSpacing: 1,
                      fontSize: screenHeight * 0.018,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    'ASK',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? Colors.white
                          : Theme.of(context).colorScheme.primary,
                      letterSpacing: 1,
                      fontSize: screenHeight * 0.018,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    'HIGH',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? Colors.white
                          : Theme.of(context).colorScheme.primary,
                      letterSpacing: 1,
                      fontSize: screenHeight * 0.018,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    'LOW',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? Colors.white
                          : Theme.of(context).colorScheme.primary,
                      letterSpacing: 1,
                      fontSize: screenHeight * 0.018,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: prices.isEmpty
                ? Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'No price data available',
                  style: TextStyle(
                    color: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.color
                        ?.withOpacity(0.6),
                  ),
                ),
              ),
            )
                : ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: prices.length,
              itemBuilder: (context, index) {
                return _buildPriceRow(
                  context,
                  prices[index],
                  index,
                  screenHeight,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(
      BuildContext context,
      GoldPriceData price,
      int index,
      double screenHeight,
      ) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: screenHeight * 0.015,
        horizontal: screenHeight * 0.01,
      ),
      decoration: BoxDecoration(
        color: index.isEven
            ? Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withOpacity(0.3)
            : Colors.transparent,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor.withOpacity(0.5),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              price.symbol,
              style: TextStyle(
                fontSize: screenHeight * 0.018,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              price.bid.toStringAsFixed(2),
              style: TextStyle(
                fontSize: screenHeight * 0.016,
                fontWeight: FontWeight.w600,
                color: Colors.green,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              price.ask.toStringAsFixed(2),
              style: TextStyle(
                fontSize: screenHeight * 0.016,
                fontWeight: FontWeight.w600,
                color: Colors.blue,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              price.high.toStringAsFixed(2),
              style: TextStyle(
                fontSize: screenHeight * 0.016,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              price.low.toStringAsFixed(2),
              style: TextStyle(
                fontSize: screenHeight * 0.016,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class _LiveRatesShimmer extends StatelessWidget {
  const _LiveRatesShimmer();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(color: Colors.white.withOpacity(0.6)),
      ),
    );
  }
}

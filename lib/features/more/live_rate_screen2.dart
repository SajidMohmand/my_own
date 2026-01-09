import 'package:flutter/material.dart';



import '../../widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/constant_color.dart';
import '../../models/metal_rate.dart';
import '../../provider/theme_provider.dart';
import '../live_rates/providers/live_rates_provider.dart';
import '../live_rates/providers/live_rates_state.dart';
import '../live_rates/widgets/moving_welcome_bar.dart';

class LiveRatesScreen2 extends ConsumerWidget {
  const LiveRatesScreen2({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(liveRatesProvider);
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text("Live Rates"),
      ),
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

              // In your LiveRatesScreen2 build method:
              Expanded(
                child: state.metals.isEmpty
                    ? _LiveRatesShimmer()
                    : state.error != null
                    ? Center(child: Text(state.error!))
                    : _buildBody(context, state, screenHeight),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MovingWelcomeBar(height: screenHeight * 0.06),

        ],
      ),
    );
  }

  Widget _buildBody(
      BuildContext context,
      LiveRatesState state,
      double screenHeight,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),

          _buildLiveRates(
            context,
            state.metals[0],
            state.metals[1],
            screenHeight,
          ),

          const SizedBox(height: 8),

          Expanded(
            child: _buildScrollableMetaDataTable(
              context,
              state.metals,
              screenHeight,
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildLiveRates(
    BuildContext context,
    MetalRate gold,
    MetalRate silver,
    double screenHeight,
    ) {
  TextStyle headerStyle = TextStyle(
    fontSize: screenHeight * 0.02,
    fontWeight: FontWeight.w900,
    color: Colors.brown,
  );

  TextStyle labelStyle = TextStyle(
    fontSize: screenHeight * 0.02,
    fontWeight: FontWeight.bold,
  );

  Widget valueWithChange(
      double value,
      double change,
      String low_high,
      bool isPositive,
      double screenHeight,
      ) {
    final color = isPositive ? Colors.green : Colors.red;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      height: screenHeight * 0.085,

      child: Column(
        children: [
          /// TOP 50% — VALUE
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                value.toStringAsFixed(2),
                style: TextStyle(
                  fontSize: screenHeight * 0.021,
                  fontWeight: FontWeight.w800,
                  color: color,
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
                // color: const Color(0xFFF9DF7B),
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
                low_high,
                style: TextStyle(
                  fontSize: screenHeight * 0.016,
                  fontWeight: FontWeight.w600,
                  color: color,
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
    required MetalRate rate,
    required bool isEven,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark
        ? Colors.white.withOpacity(0.04)
        : Colors.black.withOpacity(0.04);

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: screenHeight * 0.014,
        horizontal: screenHeight * 0.01,
      ),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Metal name (narrower now)
          Expanded(flex: 1, child: Text(name, style: labelStyle)),

          // BID
          Expanded(
            flex: 2,
            child: borderedValue(
              valueWithChange(
                rate.bid,
                rate.change,
                "High:${rate.high.toStringAsFixed(2)}",
                rate.isPositive,
                screenHeight,
              ),
            ),
          ),
          SizedBox(width: 20),

          // ASK
          Expanded(
            flex: 2,
            child: borderedValue(
              valueWithChange(
                rate.ask,
                rate.change,
                "Low:${rate.low.toStringAsFixed(2)}",
                rate.isPositive,
                screenHeight,
              ),
            ),
          ),
        ],
      ),
    );
  }

  final isDark = Theme.of(context).brightness == Brightness.dark;


  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      // Header
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
              Text('Product', textAlign: TextAlign.center, style: headerStyle),
              Expanded(
                flex: 2,
                child: Text(
                  'BID (SELL)',
                  textAlign: TextAlign.center,
                  style: headerStyle,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'ASK (BUY)',
                  textAlign: TextAlign.center,
                  style: headerStyle,
                ),
              ),
            ],
          ),
        ),
      ),

      SizedBox(height: screenHeight * 0.008),

      metalRow(name: 'GOLD \n OZ', rate: gold, isEven: true),

      SizedBox(height: screenHeight * 0.008),

      metalRow(name: 'SILVER \n OZ', rate: silver, isEven: false),
    ],
  );
}

Widget borderedValue(Widget child) {
  return Container(
    decoration: BoxDecoration(
      border: Border.all(
        color: const Color(0xFFF9DF7B), // gold border
        width: 0.7,
      ),
      borderRadius: BorderRadius.circular(12),
    ),
    child: child,
  );
}

Widget _buildScrollableMetaDataTable(
    BuildContext context,
    List<MetalRate> metals,
    double screenHeight,
    ) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final width = MediaQuery.of(context).size.width;
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
        // Fixed Header
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
                  'Metals',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Theme.of(context).colorScheme.primary,

                    letterSpacing: 1,
                    fontSize: width * 0.04,

                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,

                ),
              ),
              Expanded(
                child: Text(
                  'Weight',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Theme.of(context).colorScheme.primary,

                    letterSpacing: 1,
                    fontSize: width * 0.04,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,

                ),
              ),
              Expanded(
                child: Text(
                  'Price(AED)',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Theme.of(context).colorScheme.primary,

                    letterSpacing: 1,
                    fontSize: width * 0.04,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,

                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: metals.length - 2,
            itemBuilder: (context, index) {
              return _buildMetalRow(
                context,
                metals[index + 2], // start from index 2
                index + 2,
                screenHeight,
              );
            },
          ),
        ),

      ],
    ),
  );
}

Widget _buildMetalRow(
    BuildContext context,
    MetalRate metal,
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
          ? Theme.of(
        context,
      ).colorScheme.surfaceContainerHighest.withOpacity(0.3)
          : Colors.transparent,
      border: Border(
        top: BorderSide(color: Theme.of(context).dividerColor.withOpacity(0.5)),
      ),
    ),
    child: Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            metal.name,
            style: TextStyle(
              fontSize: screenHeight * 0.018,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              metal.weight.toString(),
              style: TextStyle(
                fontSize: screenHeight * 0.016,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Expanded(
          child: Text(
            metal.price.toStringAsFixed(2).toString(),
            style: TextStyle(
              fontSize: screenHeight * 0.018,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ),
  );
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

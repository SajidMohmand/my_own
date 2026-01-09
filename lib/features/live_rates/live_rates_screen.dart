import 'package:banglatiger2/features/live_rates/tab_product_screen.dart';
import 'package:banglatiger2/widgets/top_app_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../more/product_screen.dart';
import './providers/live_rates_provider.dart';
import './providers/live_rates_state.dart';
import './widgets/moving_welcome_bar.dart';
import '../../widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/constant_color.dart';
import '../../models/metal_rate.dart';

class LiveRatesScreen extends ConsumerStatefulWidget {
  const LiveRatesScreen({super.key});

  @override
  ConsumerState<LiveRatesScreen> createState() => _LiveRatesScreenState();
}

class _LiveRatesScreenState extends ConsumerState<LiveRatesScreen>
    with SingleTickerProviderStateMixin {

  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final state = ref.watch(liveRatesProvider);
    final screenHeight = MediaQuery.of(context).size.height;
    final isDark = Theme.of(context).brightness == Brightness.dark;
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

              SizedBox(height: 5),
              TopAppBar(
                selectedIndex: _tabController.index,
                onTabChanged: (index) {
                  _tabController.animateTo(index);
                  setState(() {});
                },
              ),
              // In your LiveRatesScreen build method:
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    /// Live Rates Screen
                    state.isLoading
                        ? _LiveRatesShimmer()
                        : _buildBody(context, state, screenHeight),

                    /// Products Screen
                    ProductsTab(), // ← your products UI
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Container(
          //   width: double.infinity,
          //   color: Color(0xff3E3F43),
          //   child: Center(child: Text("Welcome to Amber Zahrat Jewellers")),
          // ),
          // MovingWelcomeBar(height: 2,)
          MovingWelcomeBar(height: screenHeight * 0.045),
        ],
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    LiveRatesState state,
    double screenHeight,
  ) {
    // Safety check: if metals list is empty or has fewer than 2 items, show loading
    if (state.metals.isEmpty || state.metals.length < 2) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 6),

          _buildLiveRates(
            context,
            state.metals[0],
            state.metals[1],
            screenHeight,
          ),

          const SizedBox(height: 2),

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
  final isDark = Theme.of(context).brightness == Brightness.dark;

  TextStyle headerStyle = TextStyle(fontSize: screenHeight * 0.019);

  return Column(
    children: [
      Container(
        padding: EdgeInsets.only(left: 10, right: 10, top: 4, bottom: 2),
        decoration: BoxDecoration(
          color: isDark ? ConstantColor.live_screen_card_color : Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(
                8,
              ), // 👈 radius for whole table
              child: Table(
                border: TableBorder.all(
                  color: ConstantColor.live_screen_card_color,
                  width: 1,
                ),
                columnWidths: const {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(2),
                  2: FlexColumnWidth(2),
                },
                children: [
                  // Header
                  TableRow(
                    decoration: const BoxDecoration(color: Colors.black),
                    children: [
                      _tableHeaderCell('PRODUCT', headerStyle),
                      _tableHeaderCell('BID (SELL)', headerStyle),
                      _tableHeaderCell('ASK (BUY)', headerStyle),
                    ],
                  ),
                ],
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(
                8,
              ), // 👈 radius for whole table
              child: Table(
                border: TableBorder.all(
                  color: ConstantColor.live_screen_card_color,
                  width: 1,
                ),
                columnWidths: const {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(2),
                  2: FlexColumnWidth(2),
                },
                children: [
                  // Header
                  metalTableRow(
                    metal: gold,
                    isEven: true,
                    isDark: isDark,
                    context: context,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: 2),
      Container(
        padding: EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 2),
        decoration: BoxDecoration(
          color: isDark ? ConstantColor.live_screen_card_color : Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(
                8,
              ), // 👈 radius for whole table
              child: Table(
                border: TableBorder.all(
                  color: ConstantColor.live_screen_card_color,
                  width: 1,
                ),
                columnWidths: const {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(2),
                  2: FlexColumnWidth(2),
                },
                children: [
                  // Header
                  TableRow(
                    decoration: const BoxDecoration(color: Colors.black),
                    children: [
                      _tableHeaderCell('PRODUCT', headerStyle),
                      _tableHeaderCell('BID (SELL)', headerStyle),
                      _tableHeaderCell('ASK (BUY)', headerStyle),
                    ],
                  ),

                  // Data row
                ],
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(
                8,
              ), // 👈 radius for whole table
              child: Table(
                border: TableBorder.all(
                  color: ConstantColor.live_screen_card_color,
                  width: 1,
                ),
                columnWidths: const {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(2),
                  2: FlexColumnWidth(2),
                },
                children: [
                  // Header
                  metalTableRow(
                    metal: silver,
                    isEven: true,
                    isDark: isDark,
                    context: context,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget _tableHeaderCell(String text, TextStyle headerStyle) {
  return Padding(
    padding: const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
    child: Text(text, textAlign: TextAlign.center, style: headerStyle),
  );
}

TableRow metalTableRow({
  required MetalRate metal,
  required bool isEven,
  required bool isDark,
  required BuildContext context,
}) {
  return TableRow(
    decoration: BoxDecoration(color: isDark ? Colors.black : Colors.white),
    children: [
      _tableCell(metal.name, true, context, isDark),
      _tableCell(
        metal.bid.toStringAsFixed(2),
        false,
        context,
        isDark,
        low: metal.low,
        high: metal.high,
        change: metal.change,
      ),
      _tableCell(
        metal.ask.toStringAsFixed(2),
        false,
        context,
        isDark,
        low: metal.low,
        high: metal.high,
        isBid: false,
        change: metal.change,
      ),
    ],
  );
}

Widget _tableCell(
  String text,
  bool isText,
  BuildContext context,
  bool isDark, {
  double low = 0,
  double high = 0,
  bool isBid = true,
  double change = 0,
}) {
  final displayText = text.contains('OZ')
      ? text.replaceAll('OZ', '\nOZ')
      : text;

  Color valueColor;
  if (change == 0) {
    valueColor = Theme.of(context).colorScheme.onSurface;
  } else {
    valueColor = change > 0 ? Colors.green : Colors.red;
  }

  return isText
      ? Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            displayText,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      : Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: valueColor,
              ),
            ),

            const SizedBox(height: 4),

            Container(
              height: 1.5,
              width: double.infinity,
              color: ConstantColor.live_screen_card_color,
            ),

            const SizedBox(height: 4),

            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isBid ? "LOW" : "HIGH",
                      style: const TextStyle(fontSize: 10),
                    ),
                    const SizedBox(width: 2),
                    Icon(
                      isBid ? Icons.arrow_drop_down : Icons.arrow_drop_up,
                      color: isBid ? Colors.red : Colors.green,
                      size: 18,
                    ),
                  ],
                ),
                Text(
                  isBid ? low.toStringAsFixed(2) : high.toStringAsFixed(2),
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
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

  TextStyle headerStyle = TextStyle(
    fontSize: screenHeight * 0.015,
    fontWeight: FontWeight.w900,
    color: Colors.white,
  );

  return Column(
    children: [
      // Fixed Header
      ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Table(
          border: TableBorder.all(
            color: isDark ? Colors.black : Colors.white,
            width: 1,
          ),
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(2),
            2: FlexColumnWidth(2),
          },
          children: [
            // Header
            TableRow(
              decoration: BoxDecoration(color: ConstantColor.gold_color),
              children: [
                _tableHeaderCell('METALS', headerStyle),
                _tableHeaderCell('WEIGHT', headerStyle),
                _tableHeaderCell('PRICE', headerStyle),
              ],
            ),
          ],
        ),
      ),

      Expanded(
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? Colors.black : Colors.white,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              children: [
                // Main scrollable content
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      // Your metal table
                      Container(
                        color: isDark
                            ? ConstantColor.live_screen_card_color
                            : null,
                        child: Table(
                          border: TableBorder.all(
                            color: Colors.black,
                            width: 1.5,
                          ),
                          columnWidths: const {
                            0: FlexColumnWidth(2),
                            1: FlexColumnWidth(2),
                            2: FlexColumnWidth(2),
                          },
                          children: _buildMetalRows(
                            metals,
                            context,
                            screenHeight,
                          ),
                        ),
                      ),

                      // Add your image at the bottom of the scrollable content
                      Container(
                        margin: const EdgeInsets.only(top: 16),
                        height: screenHeight * 0.14, // 👈 smaller banner height
                        width: double.infinity,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              // Background Image
                              Image.asset(
                                'assets/images/banner.jpg',
                                fit: BoxFit.cover,
                              ),

                              // Dark overlay
                              Container(color: Colors.black.withOpacity(0.5)),

                              // Text
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    RichText(
                                      text: const TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'PRECIOUS ', // normal part
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 1.1,
                                            ),
                                          ),
                                          TextSpan(
                                            text: 'METALS', // golden part
                                            style: TextStyle(
                                              color: Color(
                                                0xFFD4AF37,
                                              ), // gold color
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 1.1,
                                            ),
                                          ),
                                          TextSpan(
                                            text: ' DEALER', // normal part
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 1.1,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    const Text(
                                      'We Buy & Sell',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18, // 👈 reduced
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    RichText(
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      text: const TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'GOLD & SILVER BARS ',
                                            style: TextStyle(
                                              color: Color(
                                                0xFFFFD700,
                                              ), // ⭐ Gold color
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          TextSpan(
                                            text: 'at Best Prices',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Optional: Add a subtle gradient overlay at the bottom to hint there's more content
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: 50,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.5),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}

Color getPriceColor(double current, double previous) {
  if (current > previous) {
    return Colors.green;
  } else if (current < previous) {
    return Colors.red;
  }
  return Colors.white; // no change
}

List<TableRow> _buildMetalRows(
  List<MetalRate> metals,
  BuildContext context,
  double screenHeight,
) {
  // Safety check: if metals list has fewer than 2 items, return empty list
  if (metals.length < 2) {
    return [];
  }
  
  return List.generate(metals.length - 2, (index) {
    final metal = metals[index + 2];
    return TableRow(
      decoration: BoxDecoration(
        color: index.isEven
            ? Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest.withOpacity(0.3)
            : Colors.transparent,
      ),
      children: [
        // Metal Name - Reduced vertical padding
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.008, // Reduced from 0.015
            horizontal: screenHeight * 0.008, // Reduced from 0.01
          ),
          child: _buildMetalName(metal, screenHeight),
        ),

        // Weight - Reduced vertical padding
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.008, // Reduced from 0.015
            horizontal: screenHeight * 0.008, // Reduced from 0.01
          ),
          child: Text(
            metal.weight.toString(),
            style: TextStyle(
              fontSize: screenHeight * 0.013, // Reduced from 0.016
              fontWeight: FontWeight.w900,
            ),
            textAlign: TextAlign.center,
          ),
        ),

        // Price - Reduced vertical padding
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.008, // Reduced from 0.015
            horizontal: screenHeight * 0.008, // Reduced from 0.01
          ),
          child: Text(
            metal.price.toStringAsFixed(2),
            style: TextStyle(
              fontSize: screenHeight * 0.014,
              fontWeight: FontWeight.w900,
              color: metal.change == 0
                  ? Theme.of(context).colorScheme.onSurface
                  : metal.isPositive
                  ? Colors.green
                  : Colors.red,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  });
}

Widget _buildMetalName(MetalRate metal, double screenHeight) {
  if (!_isSpecialMetal(metal.name)) {
    return Text(
      metal.name,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: screenHeight * 0.014, // Reduced from 0.018
        fontWeight: FontWeight.w900,
      ),
    );
  }

  // Split name
  final parts = metal.name.split(' ');
  final main = parts.first; // GOLD / SILVER
  final rest = metal.name.replaceFirst(main, '').trim();

  return RichText(
    textAlign: TextAlign.center,
    text: TextSpan(
      children: [
        TextSpan(
          text: '$main\n',
          style: TextStyle(
            fontSize: screenHeight * 0.014, // Reduced from 0.018
            fontWeight: FontWeight.w900,
          ),
        ),
        TextSpan(
          text: rest,
          style: TextStyle(
            fontSize: screenHeight * 0.011, // Reduced from 0.014
            fontWeight: FontWeight.w600,
            color: Color(0xff987B2F),
          ),
        ),
      ],
    ),
  );
}

bool _isSpecialMetal(String name) {
  const keywords = [
    'KILO BAR 99',
    'KILO BAR 999',
    'KILO BAR 995',
    'TEN TOLA',
    'KILO',
  ];

  return keywords.any((k) => name.contains(k));
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

import '../../widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../service/notification.dart';
import '../live_rates/providers/live_rates_provider.dart';
import '../live_rates/providers/live_rates_state.dart';

// Mock metals provider
final metalsProvider = Provider<List<String>>((ref) {
  return ['GOLD', 'SILVER', 'PLATINUM', 'PALLADIUM', 'COPPER'];
});

class RateAlertScreen extends ConsumerStatefulWidget {
  const RateAlertScreen({super.key});

  @override
  ConsumerState<RateAlertScreen> createState() => _RateAlertScreenState();
}

class _RateAlertScreenState extends ConsumerState<RateAlertScreen>
    with TickerProviderStateMixin {



  List<String> selectedMetals = [];

  double alertValue = 2400;

  // Map<String, double> currentPrices = {
  //   'GOLD': 2345.67,
  //   'SILVER': 28.45,
  //   'PLATINUM': 987.65,
  //   'PALLADIUM': 1234.56,
  //   'COPPER': 3.78,
  // };

  Map<String, IconData> metalIcons = {
    'GOLD 9999': Icons.star,
    'JEWELLERY 22K': Icons.auto_awesome,
    'KILO BAR': Icons.circle,
    'TEN TOLA': Icons.star_border,
    'SILVER KILO': Icons.diamond,
    'SILVER 1GM': Icons.diamond_outlined,
  };

  TextEditingController? alertController;

  late final AnimationController _fadeController;
  late final AnimationController _slideController;
  late final AnimationController _pulseController;

  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _scaleAnimation;

  late Color iconColor;

  @override
  void initState() {
    super.initState();

    alertController = TextEditingController(text: alertValue.toStringAsFixed(2));

    // Initialize metals after first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final liveRatesState = ref.read(liveRatesProvider);

      if (mounted && selectedMetals.isEmpty && liveRatesState.metals.isNotEmpty) {
        setState(() {
          selectedMetals = [liveRatesState.metals.first.name.toUpperCase()];
        });
      }
    });


    // Animations
    _fadeController = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);
    _slideController = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    _pulseController = AnimationController(duration: const Duration(milliseconds: 1200), vsync: this)..repeat(reverse: true);

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.03)
        .animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    alertController?.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _pulseController.dispose();
    super.dispose();
  }


  void _checkRateAlert(LiveRatesState state) {
    if (state.metals.isEmpty) return;

    final selectedMetal = selectedMetals.first;

    // Find the metal object from liveRates
    final metal = state.metals.firstWhere(
          (m) => m.name.toUpperCase() == selectedMetal,
      orElse: () => state.metals.first,
    );

    final currentPrice = metal.bid; // or metal.ask based on your alert logic

    if (alertValue <= currentPrice) {
      // showNotification(
      //   'Rate Alert: $selectedMetal',
      //   '$selectedMetal has reached \$${currentPrice.toStringAsFixed(2)}',
      // );
    }
  }



  @override
  Widget build(BuildContext context) {
    final liveRatesState = ref.watch(liveRatesProvider);
    final metals = liveRatesState.metals.map((m) => m.name.toUpperCase()).toList();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;





    final backgroundGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: isDark
          ? [Colors.grey.shade900, Colors.grey.shade800]
          : [Colors.brown.shade50, Colors.orange.shade50, Colors.amber.shade50],
    );

    final cardColor = isDark ? Colors.grey.shade800 : Colors.white;
    final borderColor = isDark ? Colors.grey.shade700 : Colors.brown.shade300;
    final textColor = isDark ? Colors.white : Colors.brown.shade700;
    final iconColor = isDark ? Colors.white : Colors.brown.shade700;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: backgroundGradient,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: isDark
                                      ? [Colors.blueGrey.shade700, Colors.blueGrey.shade900]
                                      : [Colors.brown.shade400, Colors.brown.shade600],
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.notifications_active, color: Colors.white, size: 20),
                            ),
                            const SizedBox(width: 8),
                            Text('Rate Alert', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: textColor)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Select Metal
                        Text('Select Metal', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textColor)),
                        const SizedBox(height: 6),
                        GestureDetector(
                          onTap: () async {
                            final result = await showDialog<String>(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  title: Text('Select Metal', style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: metals.map((metal) {
                                      return ListTile(
                                        leading: Icon(metalIcons[metal], color: iconColor),
                                        title: Text(metal, style: TextStyle(color: textColor)),
                                        onTap: () {
                                          Navigator.pop(context, metal); // Close dialog immediately
                                        },
                                      );
                                    }).toList(),
                                  ),
                                );
                              },
                            );

                            if (result != null) {
                              setState(() => selectedMetals = [result]); // Update selected metal
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: borderColor),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (selectedMetals.isEmpty)
                                  const SizedBox.shrink()
                                else
                                  Icon(
                                   metalIcons[selectedMetals.first],
                                   color: iconColor,
                                   size: 16,
                                  ),
                                const SizedBox(width: 6),
                                Text(
                                  selectedMetals.isNotEmpty ? selectedMetals.first : '',
                                  style: TextStyle(
                                    color: textColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: iconColor,
                                ),
                              ],
                            ),


                          ),
                        ),

                        const SizedBox(height: 12),
                        // Current Price
                        Text('Current Price', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textColor)),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: selectedMetals.map((metal) {
                            final metalData = liveRatesState.metals.firstWhere(
                                  (m) => m.name.toUpperCase().contains(metal),
                              orElse: () => liveRatesState.metals.first,
                            );
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    cardColor.withOpacity(0.95),
                                    cardColor.withOpacity(0.80),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: borderColor.withOpacity(0.6)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    metalIcons[metal] ?? Icons.circle,
                                    size: 22,
                                    color: iconColor,
                                  ),


                                  const SizedBox(height: 6),

                                  Text(
                                    metal.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 11,
                                      letterSpacing: 0.8,
                                      color: iconColor.withOpacity(0.7),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

                                  const SizedBox(height: 4),

                                  Text(
                                    "\$${metalData.bid.toStringAsFixed(2)}", // live price
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 12),
                        // Set Rate Alert
                        Text('Set Rate Alert', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textColor)),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: borderColor.withOpacity(0.6)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center, // Center the children
                            children: [
                              // ➖ Minus Button
                              _controlButton(
                                icon: Icons.remove,
                                iconColor: iconColor,
                                onTap: () {
                                  setState(() {
                                    alertValue = (alertValue - 1).clamp(0, double.infinity);
                                    alertController?.text = alertValue.toStringAsFixed(2);
                                  });
                                },
                              ),

                              // 🔢 Value Field
                              SizedBox(
                                width: 80,
                                child: TextField(
                                  controller: alertController,
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: textColor,
                                  ),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                                  ),
                                ),
                              ),

                              // ➕ Plus Button
                              _controlButton(
                                icon: Icons.add,
                                iconColor: iconColor,
                                onTap: () {
                                  setState(() {
                                    alertValue += 1;
                                    alertController?.text = alertValue.toStringAsFixed(2);
                                  });
                                },
                              ),
                            ],
                          ),
                        ),


                        const SizedBox(height: 12),
                        ScaleTransition(
                          scale: _scaleAnimation,
                          child: ElevatedButton(
                            onPressed: () {
                              // Save alert (optional: persist in local storage)
                              _checkRateAlert(liveRatesState); // check immediately

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Alert Set Successfully!'),
                                  backgroundColor: isDark ? Colors.white : Colors.green,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isDark ? Colors.blueGrey.shade700 : Colors.brown,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text(
                              'Set Alert',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),


                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],



        ),
      ),
    );
  }

  Widget _controlButton({required IconData icon, required VoidCallback onTap, required Color iconColor, }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 18, color: iconColor),
      ),
    );
  }

}

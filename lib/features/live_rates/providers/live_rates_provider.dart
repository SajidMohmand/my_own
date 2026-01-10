import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/metal_rate.dart';
import 'live_rates_state.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

const double usdToAed = 3.675;
const double ozToGram = 31.10348;
const double gramFromOz = 1 / ozToGram;
const double ttbInOz = 3.75;
const double kiloInGram = 1000;
const Duration marketTimeout = Duration(seconds: 10);


final liveRatesProvider =
NotifierProvider<LiveRatesNotifier, LiveRatesState>(
  LiveRatesNotifier.new,
);

double _jitter(double value) {
  final delta = (value * 0.00005); // 0.005% movement
  return value + (DateTime.now().millisecond.isEven ? delta : -delta);
}


class LiveRatesNotifier extends Notifier<LiveRatesState> {
  Timer? _updateTimer;
  WebSocketChannel? _channel;
  bool _initialized = false;
  bool _isReconnecting = false;

  bool _marketWasActive = true;


  double _xauUsd = 0;
  double _xagUsd = 0;
  double goldHigh = 0;
  double goldLow = 0;
  double silverHigh = 0;
  double silverLow = 0;
  DateTime? _lastDataReceivedTime;

  @override
  LiveRatesState build() {
    ref.onDispose(_dispose);

    _updateTimer ??= Timer.periodic(
      const Duration(seconds: 1),
          (_) => _recalculateRates(),
    );

    // Delay side effects
    Future.microtask(_connectWebSocket);

    return LiveRatesState(
      metals: const [],
      lastUpdated: DateTime.now(),
      isLoading: true,
      error: 'Connecting to live prices...',
    );
  }

  void _dispose() {

    _updateTimer?.cancel();
    _channel?.sink.close();
    _channel = null;
    _isReconnecting = false;
  }
  bool get _isWeekend {
    final now = DateTime.now();
    return now.weekday == DateTime.saturday ||
        now.weekday == DateTime.sunday;
  }

  bool get _isMarketActive {
    if (_isWeekend) return false;

    if (_lastDataReceivedTime == null) return false;

    return DateTime.now()
        .difference(_lastDataReceivedTime!) <
        const Duration(seconds: 10);
  }



  void _connectWebSocket() {
    try {
      if (_isReconnecting) {
        return;
      }

      // Clear any previous connection error
      if (ref.mounted) {
        state = state.copyWith(error: null);
      }


      // _channel = WebSocketChannel.connect(
      //   Uri.parse('ws://10.0.2.2:3294'),
      // );

      _channel = WebSocketChannel.connect(
        Uri.parse('ws://94.136.187.60:3294'),
      );

      _channel!.stream.listen(
            (message) {
              if (!ref.mounted) return;

              print(message);
          try {
            final data = json.decode(message);

            print("khan $data");
            if (data['type'] == 'price' && data['prices'] is Map) {
              _lastDataReceivedTime = DateTime.now();

              final priceItem = data['prices'];
              final symbol = priceItem['symbol']?.toString() ?? '';
              final bid = priceItem['bid'];
              final high = priceItem['high'];
              final low = priceItem['low'];

              if (symbol.contains('XAU')) {
                if (bid != null && bid is num && bid > 0) {
                  _xauUsd = bid.toDouble();
                } else if (_xauUsd == 0 && high != null && high is num && high > 0) {
                  _xauUsd = high.toDouble(); // initialize only once
                }

                if (high != null && high is num && high > 0) {
                  goldHigh = high.toDouble();
                }
                if (low != null && low is num && low > 0) {
                  goldLow = low.toDouble();
                }
              }

              if (symbol.contains('SILVER')) {
                if (bid != null && bid is num && bid > 0) {
                  _xagUsd = bid.toDouble();
                } else if (_xagUsd == 0 && high != null && high is num && high > 0) {
                  _xagUsd = high.toDouble();
                }

                if (high != null && high is num && high > 0) {
                  silverHigh = high.toDouble();
                }
                if (low != null && low is num && low > 0) {
                  silverLow = low.toDouble();
                }
              }


              // Only initialize data if metals list is empty AND we have gold price
              if (state.metals.isEmpty && _xauUsd > 0) {
                _initializeData();
              } else if (state.metals.isNotEmpty) {

                // Update existing data
                _updateHighLow(goldHigh, goldLow, silverHigh, silverLow);
              }
              // Note: Don't clear loading state here - let _initializeData() handle it

              _recalculateRates();
            }
          } catch (e, stackTrace) {
            print("hi");
            // Only show error if we don't have data yet
            if (state.metals.isEmpty) {
              state = state.copyWith(
                error: 'Error processing data',
                isLoading: false,
              );
            }
          }
        },
        onDone: () {
          if (!ref.mounted) return;
          // Only show reconnection message if we don't have data
          if (state.metals.isEmpty) {
            state = state.copyWith(
              error: 'Connection lost. Reconnecting...',
              isLoading: true,
            );
          }

          if (!_isReconnecting) {
            _reconnect();
          }
        },
        onError: (error) {
          if (!ref.mounted) return;
          // Only show error if we don't have data yet
          if (state.metals.isEmpty) {
            state = state.copyWith(
              error: 'Connection error',
              isLoading: true,
            );
          }

          if (!_isReconnecting) {
            _reconnect();
          }
        },
      );
    } catch (e, stackTrace) {
      // Only show error on initial connection if we don't have data
      if (state.metals.isEmpty) {
        state = state.copyWith(
          error: 'Failed to connect to server',
          isLoading: false,
        );
      }

      if (!_isReconnecting) {
        _reconnect();
      }
    }
  }

  void _reconnect() {
    if (_isReconnecting) return;

    _isReconnecting = true;

    Future.delayed(const Duration(seconds: 5), () {
      _isReconnecting = false;
      // Close previous connection if any
      try {
        _channel?.sink.close();
      } catch (_) {}
      _connectWebSocket();
    });
  }


  void _updateHighLow(double? goldHigh, double? goldLow, double? silverHigh, double? silverLow) {
    if (state.metals.isEmpty) return;

    final updated = <MetalRate>[];

    for (final metal in state.metals) {
      MetalRate updatedMetal = metal;

      // Update GOLD OZ (USD)
      if (metal.weight == "1 OZ" && metal.name.contains("GOLD")) {
        if (goldHigh != null) {
          updatedMetal = updatedMetal.copyWith(high: goldHigh);
        }
        if (goldLow != null) {
          updatedMetal = updatedMetal.copyWith(low: goldLow);
        }
      }
      // Update SILVER OZ (USD)
      else if (metal.weight == "1 OZ" && metal.name.contains("SILVER")) {
        if (silverHigh != null) {
          updatedMetal = updatedMetal.copyWith(high: silverHigh);
        }
        if (silverLow != null) {
          updatedMetal = updatedMetal.copyWith(low: silverLow);
        }
      }

      updated.add(updatedMetal);
    }

    state = state.copyWith(metals: updated);
  }



  void _recalculateRates() {
    // Only recalculate if we have data
    if (state.metals.isEmpty) {
      return;
    }

    if (!_isMarketActive) {
      return;
    }

    if (!_isMarketActive) {
      if (_marketWasActive) {
        _marketWasActive = false;
        state = state.copyWith(
          error: _isWeekend
              ? 'Market closed (Weekend)'
              : 'Market closed',
        );
      }
      return;
    }

// Market reopened
    _marketWasActive = true;

    double r(double v) => double.parse(v.toStringAsFixed(2));

    final goldBase = _xauUsd > 0
        ? _xauUsd
        : state.metals.firstWhere((m) => m.weight == "1 OZ" && m.name.contains("GOLD")).price;

    final silverBase = _xagUsd > 0 ? _xagUsd : 30.0;

    final goldOzUsd =
    _isMarketActive ? _jitter(goldBase) : goldBase;

    final silverOzUsd =
    _isMarketActive ? _jitter(silverBase) : silverBase;


    final updated = <MetalRate>[];

    for (final m in state.metals) {
      double newBid;
      double newAsk;
      double newPrice;
      double newHigh;
      double newLow;

      // --- GOLD OZ (USD) --- Keep as is
      if (m.weight == "1 OZ" && m.name.contains("GOLD")) {
        final double goldAsk = goldOzUsd + 1.32;
        final double goldBid2 = (goldOzUsd + 1.32) - 1.0;
        newBid = r(goldBid2);
        newAsk = r(goldAsk);
        newPrice = r(goldOzUsd);
        newHigh = _calculateHigh(m.high, newBid);
        newLow = _calculateLow(m.low, newBid);
      }
      // --- SILVER OZ (USD) --- Keep as is
      else if (m.weight == "1 OZ" && m.name.contains("SILVER")) {
        newBid = r(silverOzUsd - 0.5);
        newAsk = r(silverOzUsd);
        newPrice = r(silverOzUsd);
        newHigh = _calculateHigh(m.high, newBid);
        newLow = _calculateLow(m.low, newBid);
      }
      // --- GOLD 999 1GM (AED) --- RENAMED: Changed from "GOLD 999" to "GOLD 999"
      else if (m.name == "GOLD 999" && m.weight == "1 GM") {
        final gold1gAed = r((goldOzUsd * gramFromOz) * usdToAed);
        newBid = r(gold1gAed);
        newAsk = r(gold1gAed + 1.5);
        newPrice = r(gold1gAed);
        newHigh = _calculateHigh(m.high, newBid);
        newLow = _calculateLow(m.low, newBid);
      }
      // --- GOLD 995 1GM (AED) --- CHANGED: Name from "JEWELLERY 22k" to "GOLD 995"
      else if (m.name == "GOLD 995" && m.weight == "1 GM") {
        final gold1gAed = r((goldOzUsd * gramFromOz) * usdToAed);
        final gold995Price = r(gold1gAed * 0.9167);
        newBid = r(gold995Price);
        newAsk = r(gold995Price + 1.2);
        newPrice = r(gold995Price);
        newHigh = _calculateHigh(m.high, newBid);
        newLow = _calculateLow(m.low, newBid);
      }
      // --- GOLD TEN TOLA (AED) --- Keep name "GOLD TEN TOLA"
      else if (m.name == "GOLD TEN TOLA" && m.weight == "1 TTB") {
        newBid = r((goldOzUsd * ttbInOz) * usdToAed);
        newAsk = r(newBid + 50);
        newPrice = r(newBid);
        newHigh = _calculateHigh(m.high, newBid);
        newLow = _calculateLow(m.low, newBid);
      }
      // --- GOLD KILO BAR 999 (AED) --- UPDATED: Name changed to "GOLD KILO BAR 999"
      else if (m.name == "GOLD KILO BAR 999" && m.weight == "1 KG") {
        final gold1gAed = r((goldOzUsd * gramFromOz) * usdToAed);
        final goldKilo999 = r(gold1gAed * kiloInGram);
        newBid = r(goldKilo999);
        newAsk = r(goldKilo999 + 500);
        newPrice = r(goldKilo999);
        newHigh = _calculateHigh(m.high, newBid);
        newLow = _calculateLow(m.low, newBid);
      }
      // --- GOLD KILO BAR 995 (AED) --- UPDATED: Name changed to "GOLD KILO BAR 995"
      else if (m.name == "GOLD KILO BAR 995" && m.weight == "1 KG") {
        final gold1gAed = r((goldOzUsd * gramFromOz) * usdToAed);
        final gold995Price = r(gold1gAed * 0.9167);
        final goldKilo995 = r(gold995Price * kiloInGram);
        newBid = r(goldKilo995);
        newAsk = r(goldKilo995 + 450);
        newPrice = r(goldKilo995);
        newHigh = _calculateHigh(m.high, newBid);
        newLow = _calculateLow(m.low, newBid);
      }
      // --- SILVER 1GM (AED) --- Keep name "SILVER"
      else if (m.name == "SILVER" && m.weight == "1 GM") {
        final silver1gAed = r((silverOzUsd * gramFromOz) * usdToAed);
        newBid = r(silver1gAed);
        newAsk = r(silver1gAed + 0.2);
        newPrice = r(silver1gAed);
        newHigh = _calculateHigh(m.high, newBid);
        newLow = _calculateLow(m.low, newBid);
      }
      // --- SILVER KILO (AED) --- UPDATED: Name changed to "SILVER KILO"
      else if (m.name == "SILVER KILO" && m.weight == "1 KG") {
        final silver1gAed = r((silverOzUsd * gramFromOz) * usdToAed);
        final silverKiloAed = r(silver1gAed * kiloInGram);
        newBid = r(silverKiloAed);
        newAsk = r(silverKiloAed + 20);
        newPrice = r(silverKiloAed);
        newHigh = _calculateHigh(m.high, newBid);
        newLow = _calculateLow(m.low, newBid);
      }
      // Keep other metals unchanged
      else {
        updated.add(m);
        continue;
      }

      // ✅ Calculate change from previous bid
      final diff = r(newBid - m.bid);
      final changePercent = m.bid != 0 ? r((diff / m.bid) * 100) : 0.0;
      final isPositive = diff >= 0;

      updated.add(
        m.copyWith(
          bid: newBid,
          ask: newAsk,
          high: newHigh,
          low: newLow,
          change: diff,
          changePercent: changePercent,
          isPositive: isPositive,
          price: newPrice,
        ),
      );
    }

    state = LiveRatesState(
      metals: updated,
      lastUpdated: DateTime.now(),
      isLoading: false,
      error: null,
    );

  }

  double _calculateHigh(double currentHigh, double newBid) {
    return newBid > currentHigh ? newBid : currentHigh;
  }

  double _calculateLow(double currentLow, double newBid) {
    // For initial value, set it to newBid
    if (currentLow == 0) return newBid;
    return newBid < currentLow ? newBid : currentLow;
  }

  void _initializeData() {
    try {

      double r(double v) => double.parse(v.toStringAsFixed(2));

      final goldOzUsd = r(_xauUsd);
      final silverOzUsd = _xagUsd > 0 ? r(_xagUsd) : 30.0;
      final goldBid = r(goldOzUsd - 1.0);
      final silverBid = r(silverOzUsd - 0.50);
      final actualGoldHigh = goldHigh ?? goldBid;
      final actualGoldLow = goldLow ?? goldBid;
      final actualSilverHigh = silverHigh ?? silverBid;
      final actualSilverLow = silverLow ?? silverBid;

      // Calculate base prices
      final gold1gAed = r((goldOzUsd * gramFromOz) * usdToAed); // GOLD 999 1GM
      final gold995Price = r(gold1gAed * 0.9167); // GOLD 995 (22K)
      final gold992Price = r(gold1gAed * 0.992); // GOLD 992 (99.2%)
      final goldTtbAed = r((goldOzUsd * ttbInOz) * usdToAed); // GOLD TEN TOLA
      final goldKilo999 = r(gold1gAed * kiloInGram); // GOLD KILO BAR 999
      final goldKilo995 = r(gold995Price * kiloInGram); // GOLD KILO BAR 995
      final silver1gAed = r((silverOzUsd * gramFromOz) * usdToAed); // SILVER 1GM
      final silverKiloAed = r(silver1gAed * kiloInGram); // SILVER KILO

      final double goldAsk = goldOzUsd + 1.32;
      final double goldBid2 = (goldOzUsd + 1.32) - 1.0;

      final double silverBid2 = silverOzUsd - 0.50;



      final metals = <MetalRate>[
        // ================= GOLD OZ (USD) - Keep as is
        MetalRate(
          name: "GOLD SPOT OZ",
          code: "XAUUSD",
          ask: r(goldAsk),
          bid: r(goldBid2),
          high: r(actualGoldHigh),
          low: r(actualGoldLow),
          change: 0,
          changePercent: 0,
          isPositive: true,
          weight: "1 OZ",
          price: goldOzUsd,
        ),

        // ================= SILVER OZ (USD) - Keep as is
        MetalRate(
          name: "SILVER SPOT OZ",
          code: "XAGUSD",
          ask: r(silverOzUsd),
          bid: r(silverBid2),
          high: r(actualSilverHigh),
          low: r(actualSilverLow),
          change: 0,
          changePercent: 0,
          isPositive: true,
          weight: "1 OZ",
          price: silverOzUsd,
        ),

// ================= GOLD 999 1GM (AED) - As per table
        MetalRate(
          name: "GOLD 999",
          code: "XAU999",
          bid: gold1gAed,
          ask: r(gold1gAed + 1.5),
          high: gold1gAed,
          low: gold1gAed,
          change: 0,
          changePercent: 0,
          isPositive: true,
          weight: "1 GM",
          price: gold1gAed,
        ),

        // ================= GOLD 995 1GM (AED) - Changed from JEWELLERY 22k
        MetalRate(
          name: "GOLD 995",
          code: "XAU995",
          bid: gold995Price,
          ask: r(gold995Price + 1.2),
          high: gold995Price,
          low: gold995Price,
          change: 0,
          changePercent: 0,
          isPositive: true,
          weight: "1 GM",
          price: gold995Price,
        ),
// ================= GOLD 992 1GM (AED)
        MetalRate(
          name: "GOLD 992",
          code: "XAU992",
          bid: gold992Price,
          ask: r(gold992Price + 1.3), // slight spread
          high: gold992Price,
          low: gold992Price,
          change: 0,
          changePercent: 0,
          isPositive: true,
          weight: "1 GM",
          price: gold992Price,
        ),




        // ================= GOLD KILO BAR 999 (AED) - Updated name
        MetalRate(
          name: "GOLD KILO BAR 999",
          code: "XAU999K",
          bid: goldKilo999,
          ask: r(goldKilo999 + 500),
          high: goldKilo999,
          low: goldKilo999,
          change: 0,
          changePercent: 0,
          isPositive: true,
          weight: "1 KG",
          price: goldKilo999,
        ),

        // ================= GOLD KILO BAR 995 (AED) - Updated name
        MetalRate(
          name: "GOLD KILO BAR 995",
          code: "XAU995K",
          bid: goldKilo995,
          ask: r(goldKilo995 + 450),
          high: goldKilo995,
          low: goldKilo995,
          change: 0,
          changePercent: 0,
          isPositive: true,
          weight: "1 KG",
          price: goldKilo995,
        ),

        // ================= GOLD TEN TOLA (AED) - As per table
        MetalRate(
          name: "GOLD TEN TOLA",
          code: "GTT",
          bid: goldTtbAed,
          ask: r(goldTtbAed + 50),
          high: goldTtbAed,
          low: goldTtbAed,
          change: 0,
          changePercent: 0,
          isPositive: true,
          weight: "1 TTB",
          price: goldTtbAed,
        ),

        // ================= SILVER KILO (AED) - Updated name
        MetalRate(
          name: "SILVER KILO",
          code: "XAGK",
          bid: silverKiloAed,
          ask: r(silverKiloAed + 20),
          high: silverKiloAed,
          low: silverKiloAed,
          change: 0,
          changePercent: 0,
          isPositive: true,
          weight: "1 KG",
          price: silverKiloAed,
        ),






      ];


      state = state.copyWith(
        metals: metals,
        lastUpdated: DateTime.now(),
        isLoading: false,
        error: null,
      );


    } catch (e, stackTrace) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load live prices: $e',
      );
    }
  }

  // Public method to manually reconnect
  void reconnect() {
    _dispose();
    _isReconnecting = false;
    Future.delayed(Duration.zero, _connectWebSocket);
  }
}
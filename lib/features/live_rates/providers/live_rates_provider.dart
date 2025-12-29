import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/metal_rate.dart';
import 'live_rates_state.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

const double usdToAed = 3.6725;

const double ozToGram = 31.10348;
const double gramFromOz = 1 / ozToGram; // 1 gm = 1 oz / 31.10348
const double ttbInOz = 3.75;
const double kiloInGram = 1000;

const String apiKey = 'R9mUW0po3fMLgQKNPeRzTm1Fco';


final liveRatesProvider =
NotifierProvider<LiveRatesNotifier, LiveRatesState>(
  LiveRatesNotifier.new,
);
class LiveRatesNotifier extends Notifier<LiveRatesState> {
  Timer? _updateTimer;
  bool _initialized = false;

  double _xauUsd = 0;
  double _xagUsd = 0;


  @override
  LiveRatesState build() {
    if (!_initialized) {
      _initialized = true;

      final initial = LiveRatesState(
        metals: const [],
        lastUpdated: DateTime.now(),
        isLoading: true,
      );

      Future.microtask(() async {
        await _fetchBasePrices();   // 🔥 FIRST
        await _initializeData();    // 🔥 THEN
        _startUpdates();
      });


      ref.onDispose(() {
        _updateTimer?.cancel();
      });

      return initial;
    }

    return state; // 🧠 DO NOT RESET STATE
  }

  Future<double> _fetchMetalUsd(String symbol) async {
    final url = Uri.parse(
      'https://fcsapi.com/api-v3/forex/latest?symbol=$symbol&access_key=$apiKey',
    );

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('API error');
    }

    final data = json.decode(response.body);
    return double.parse(data['response'][0]['c']);
  }

  Future<void> _fetchBasePrices() async {
    _xauUsd = await _fetchMetalUsd('XAU/USD'); // USD per OZ
    _xagUsd = await _fetchMetalUsd('XAG/USD');
  }

  void _recalculateRates() {
    if (state.metals.isEmpty) return;

    double r(double v) => double.parse(v.toStringAsFixed(2));

    // --- Get OZ prices ---
    final goldOzUsd =
        state.metals.firstWhere((m) => m.name == "GOLD OZ").bid;

    final silverOzUsd =
        state.metals.firstWhere((m) => m.name == "SILVER OZ").bid;

    final updated = <MetalRate>[];

    for (final m in state.metals) {
      // Keep OZ unchanged
      if (m.weight == "1 OZ") {
        updated.add(m);
        continue;
      }

      double newBid;

      // --- GOLD ---
      if (m.name.contains("GOLD")) {
        if (m.weight == "1GM") {
          newBid = r((goldOzUsd / ozToGram) * usdToAed);
        } else if (m.weight == "1KG") {
          newBid = r((goldOzUsd / ozToGram) * usdToAed * kiloInGram);
        } else if (m.weight == "TTB") {
          newBid = r(goldOzUsd * ttbInOz * usdToAed);
        } else {
          updated.add(m);
          continue;
        }
      }

      // --- SILVER ---
      else {
        if (m.weight == "1GM") {
          newBid = r((silverOzUsd / ozToGram) * usdToAed);
        } else if (m.weight == "1KG") {
          newBid = r((silverOzUsd / ozToGram) * usdToAed * kiloInGram);
        } else {
          updated.add(m);
          continue;
        }
      }

      final diff = r(newBid - m.bid);

      updated.add(
        m.copyWith(
          bid: newBid,
          ask: r(newBid + (m.ask - m.bid)),
          change: diff,
          changePercent: m.bid == 0 ? 0 : r((diff / m.bid) * 100),
          isPositive: diff >= 0,
        ),
      );
    }

    state = state.copyWith(
      metals: updated,
      lastUpdated: DateTime.now(),
    );
  }



  Future<void> _initializeData([List<MetalRate>? previousMetals]) async {
    try {
      final old = previousMetals ?? [];

      state = state.copyWith(isLoading: old.isEmpty);

      // --- Fetch prices ---
      final xauUsd = _xauUsd;
      final xagUsd = _xagUsd;






      // --- Helpers ---
      double r(double v) => double.parse(v.toStringAsFixed(2));

      double prevBid(int i, double fallback) =>
          old.length > i ? old[i].bid : fallback;

      // --- Base prices ---
      // final gold9999 = r((xauUsd * usdToAed) / troyOunceInGrams);
      // final silver1g = r((xagUsd * usdToAed) / troyOunceInGrams);

      final goldOzUsd = r(_xauUsd); // GOLD OZ → USD
      final silverOzUsd = r(_xagUsd); // SILVER OZ → USD

      final gold1gAed = r((goldOzUsd * gramFromOz) * usdToAed);
      final silver1gAed = r((silverOzUsd * gramFromOz) * usdToAed);

      final goldKiloAed = r(gold1gAed * kiloInGram);
      final silverKiloAed = r(silver1gAed * kiloInGram);

      final goldTtbAed = r((goldOzUsd * ttbInOz) * usdToAed);


      final metals = <MetalRate>[
        // ================= GOLD OZ (USD)
        MetalRate(
          name: "GOLD OZ",
          code: "XAUUSD",
          bid: goldOzUsd,
          ask: r(goldOzUsd + 1),
          change: 0,
          changePercent: 0,
          isPositive: true,
          weight: "1 OZ",
          price: goldOzUsd,
        ),

        // ================= SILVER OZ (USD)
        MetalRate(
          name: "SILVER OZ",
          code: "XAGUSD",
          bid: silverOzUsd,
          ask: r(silverOzUsd + 0.05),
          change: 0,
          changePercent: 0,
          isPositive: true,
          weight: "1 OZ",
          price: silverOzUsd,
        ),

        // ================= GOLD 1GM (AED)
        MetalRate(
          name: "GOLD 1GM",
          code: "XAU",
          bid: gold1gAed,
          ask: r(gold1gAed + 1.5),
          change: 0,
          changePercent: 0,
          isPositive: true,
          weight: "1GM",
          price: gold1gAed,
        ),

        // ================= GOLD KILO (AED)
        MetalRate(
          name: "GOLD KILO",
          code: "XAU",
          bid: goldKiloAed,
          ask: r(goldKiloAed + 500),
          change: 0,
          changePercent: 0,
          isPositive: true,
          weight: "1KG",
          price: goldKiloAed,
        ),

        // ================= GOLD TTB (AED)
        MetalRate(
          name: "TEN TOLA",
          code: "TTB",
          bid: goldTtbAed,
          ask: r(goldTtbAed + 50),
          change: 0,
          changePercent: 0,
          isPositive: true,
          weight: "TTB",
          price: goldTtbAed,
        ),

        // ================= SILVER 1GM (AED)
        MetalRate(
          name: "SILVER 1GM",
          code: "XAG",
          bid: silver1gAed,
          ask: r(silver1gAed + 0.2),
          change: 0,
          changePercent: 0,
          isPositive: true,
          weight: "1GM",
          price: silver1gAed,
        ),

        // ================= SILVER KILO (AED)
        MetalRate(
          name: "SILVER KILO",
          code: "XAG",
          bid: silverKiloAed,
          ask: r(silverKiloAed + 20),
          change: 0,
          changePercent: 0,
          isPositive: true,
          weight: "1KG",
          price: silverKiloAed,
        ),
      ];


      state = state.copyWith(
        metals: metals,
        lastUpdated: DateTime.now(),
        isLoading: false,
        isRefreshing: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isRefreshing: false,
        error: e.toString(),
      );
    }
  }


  void _startUpdates() {

    // Fetch API every 60 seconds
    Timer.periodic(const Duration(seconds: 60), (_) async {
      await _fetchBasePrices();
      await _updateRates(); // rebuild prices from API
    });

    // UI tick every second
    _updateTimer = Timer.periodic(
      const Duration(seconds: 1),
          (_) => _recalculateRates(),
    );

  }


  Future<void> _updateRates() async {
    try {
      final previousMetals = List<MetalRate>.from(state.metals); // 🧠 freeze old snapshot

      state = state.copyWith(isRefreshing: true);

      await _initializeData(previousMetals);

      state = state.copyWith(isRefreshing: false);
    } catch (e) {
      state = state.copyWith(isRefreshing: false, error: e.toString());
    }
  }



}

import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Model for price data
class GoldPriceData {
  final String symbol;
  final double bid;
  final double ask;
  final double high;
  final double low;
  final double close;
  final String time;

  GoldPriceData({
    required this.symbol,
    required this.bid,
    required this.ask,
    required this.high,
    required this.low,
    required this.close,
    required this.time,
  });

  factory GoldPriceData.fromJson(Map<String, dynamic> json) {
    return GoldPriceData(
      symbol: json['symbol'] ?? '',
      bid: (json['bid'] ?? 0).toDouble(),
      ask: (json['ask'] ?? 0).toDouble(),
      high: (json['high'] ?? 0).toDouble(),
      low: (json['low'] ?? 0).toDouble(),
      close: (json['close'] ?? 0).toDouble(),
      time: json['time']?.toString() ?? '',
    );
  }

  GoldPriceData copyWith({
    String? symbol,
    double? bid,
    double? ask,
    double? high,
    double? low,
    double? close,
    String? time,
  }) {
    return GoldPriceData(
      symbol: symbol ?? this.symbol,
      bid: bid ?? this.bid,
      ask: ask ?? this.ask,
      high: high ?? this.high,
      low: low ?? this.low,
      close: close ?? this.close,
      time: time ?? this.time,
    );
  }

  @override
  String toString() {
    return 'GoldPrice(symbol: $symbol, bid: $bid, ask: $ask)';
  }
}

// State class
class WebSocketGoldState {
  final Map<String, GoldPriceData> prices;
  final bool isConnected;
  final String? error;

  WebSocketGoldState({
    this.prices = const {},
    this.isConnected = false,
    this.error,
  });

  WebSocketGoldState copyWith({
    Map<String, GoldPriceData>? prices,
    bool? isConnected,
    String? error,
  }) {
    return WebSocketGoldState(
      prices: prices ?? this.prices,
      isConnected: isConnected ?? this.isConnected,
      error: error,
    );
  }
}

// WebSocket Service (Updated for Riverpod 3.x with Notifier)
class WebSocketGoldNotifier extends Notifier<WebSocketGoldState> {
  WebSocketChannel? _channel;
  Timer? _reconnectTimer;
  bool _manualDisconnect = false;

  // 🔥 CHANGE THIS TO YOUR SERVER IP
  String get wsUrl => 'ws://94.136.187.60:3294';

  @override
  WebSocketGoldState build() {
    // Initialize connection
    Future.microtask(() => connect());

    // Cleanup on dispose
    ref.onDispose(() {
      disconnect();
    });

    return WebSocketGoldState();
  }

  void connect() {
    if (_manualDisconnect) return;

    try {
      print('🔌 Attempting to connect to: $wsUrl');
      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));

      state = state.copyWith(isConnected: true, error: null);
      print('✅ WebSocket connection established');

      _channel!.stream.listen(
            (message) {
          print('📩 RAW MESSAGE RECEIVED: $message');
          _handleMessage(message);
        },
        onError: (error) {
          print('❌ Stream error: $error');
          _handleError(error);
        },
        onDone: () {
          print('🔌 Stream closed');
          _handleDisconnect();
        },
        cancelOnError: false,
      );
    } catch (e, stackTrace) {
      print('❌ Connection error: $e');
      print('Stack trace: $stackTrace');
      state = state.copyWith(
        isConnected: false,
        error: 'Connection failed: $e',
      );
      _scheduleReconnect();
    }
  }

  void _handleMessage(dynamic message) {
    try {
      print('🔍 Parsing message...');
      final data = json.decode(message);
      print('📦 Parsed JSON: $data');

      if (data['type'] == 'prices' && data['prices'] != null) {
        final pricesList = data['prices'] as List;
        print('💰 Number of prices received: ${pricesList.length}');

        final Map<String, GoldPriceData> updatedPrices = {};

        for (var priceJson in pricesList) {
          print('🔧 Processing price: $priceJson');
          final priceData = GoldPriceData.fromJson(priceJson);
          updatedPrices[priceData.symbol] = priceData;
          print('✅ Added price for ${priceData.symbol}: ${priceData.bid}');
        }

        state = state.copyWith(prices: updatedPrices);
        print('📊 Total prices in state: ${state.prices.length}');
        print('📊 Symbols: ${state.prices.keys.join(", ")}');
      } else {
        print('⚠️ Message type is not "prices" or prices is null');
        print('Message type: ${data['type']}');
      }
    } catch (e, stackTrace) {
      print('❌ Error parsing message: $e');
      print('Stack trace: $stackTrace');
      print('Raw message was: $message');
    }
  }

  void _handleError(error) {
    print('WebSocket error: $error');
    state = state.copyWith(
      isConnected: false,
      error: 'WebSocket error: $error',
    );
  }

  void _handleDisconnect() {
    print('❌ WebSocket disconnected');
    state = state.copyWith(isConnected: false);

    if (!_manualDisconnect) {
      _scheduleReconnect();
    }
  }

  void _scheduleReconnect() {
    _reconnectTimer?.cancel();
    print('🔄 Reconnecting in 5 seconds...');

    _reconnectTimer = Timer(const Duration(seconds: 5), () {
      if (!_manualDisconnect) {
        connect();
      }
    });
  }

  void disconnect() {
    _manualDisconnect = true;
    _reconnectTimer?.cancel();
    _channel?.sink.close();
    state = state.copyWith(isConnected: false);
    print('Disconnected manually');
  }
}

// Provider (Updated for Riverpod 3.x)
final webSocketGoldProvider =
NotifierProvider<WebSocketGoldNotifier, WebSocketGoldState>(
  WebSocketGoldNotifier.new,
);
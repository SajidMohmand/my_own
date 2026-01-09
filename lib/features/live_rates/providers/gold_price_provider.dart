import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class GoldPrice {
  final String symbol;
  final double bid;
  final double ask;
  final double high;
  final double low;
  final double? close;
  final DateTime? time;

  GoldPrice({
    required this.symbol,
    required this.bid,
    required this.ask,
    required this.high,
    required this.low,
    this.close,
    this.time,
  });

  factory GoldPrice.fromJson(Map<String, dynamic> json) {
    return GoldPrice(
      symbol: json['symbol'] ?? 'XAUUSD',
      bid: (json['bid'] ?? 0).toDouble(),
      ask: (json['ask'] ?? 0).toDouble(),
      high: (json['high'] ?? 0).toDouble(),
      low: (json['low'] ?? 0).toDouble(),
      close: (json['close'] ?? 0).toDouble(),
      time: json['time'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['time'] * 1000)
          : DateTime.now(),
    );
  }

}


final goldPriceProvider =
NotifierProvider<GoldPriceNotifier, GoldPrice?>(
  GoldPriceNotifier.new,
);

class GoldPriceNotifier extends Notifier<GoldPrice?> {
  WebSocketChannel? _channel;

  @override
  GoldPrice? build() {
    _connect();
    ref.onDispose(_disposeSocket);
    return null;
  }

  void _connect() {
    _channel = WebSocketChannel.connect(
      Uri.parse('ws://10.0.2.2:3294'),
    );

    _channel!.stream.listen(
          (message) {
            print("Received WS message: $message");
        try {
          final data = json.decode(message);
          if (data['type'] == 'prices' && data['prices'].isNotEmpty) {
            state = GoldPrice.fromJson(data['prices'][0]);
          }
        } catch (e) {
          print("Error parsing message: $e");
          // ignore invalid messages
        }
      },
      onDone: _reconnect,
      onError: (err) {
        print("WebSocket error: $err");
        _reconnect();
      },
    );
  }

  void _reconnect() {
    Future.delayed(const Duration(seconds: 5), _connect);
  }

  void _disposeSocket() {
    _channel?.sink.close();
    _channel = null;
  }
}

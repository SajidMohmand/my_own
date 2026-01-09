class MetalRate {
  final String name;
  final String code;
  final double bid;
  final double ask;
  final double high;      // Add this
  final double low;
  final double change;
  final double changePercent;
  final bool isPositive;
  final String weight; // e.g., "1GM", "1KG", "TTB"
  final double price;  // price in AED

  MetalRate({
    required this.name,
    required this.code,
    required this.bid,
    required this.ask,
    required this.high,     // Add this parameter
    required this.low,
    required this.change,
    required this.changePercent,
    required this.isPositive,
    this.weight = '',
    this.price = 0.0,
  });

  MetalRate copyWith({
    String? name,
    String? code,
    double? bid,
    double? ask,
    double? high,     // Add this
    double? low,
    double? change,
    double? changePercent,
    bool? isPositive,
    String? weight,
    double? price,
  }) {
    return MetalRate(
      name: name ?? this.name,
      code: code ?? this.code,
      bid: bid ?? this.bid,
      ask: ask ?? this.ask,
      high: high ?? this.high,     // Add this
      low: low ?? this.low,
      change: change ?? this.change,
      changePercent: changePercent ?? this.changePercent,
      isPositive: isPositive ?? this.isPositive,
      weight: weight ?? this.weight,
      price: price ?? this.price,
    );
  }


}

extension MetalRateHelper on MetalRate {
  static MetalRate empty() => MetalRate(
    name: '',
    code: '',
    bid: 0,
    ask: 0,
    high: 0,
    low: 0,
    change: 0,
    changePercent: 0,
    isPositive: true,
  );
}


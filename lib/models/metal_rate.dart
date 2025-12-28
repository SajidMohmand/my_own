class MetalRate {
  final String name;
  final String code;
  final double bid;
  final double ask;
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
      change: change ?? this.change,
      changePercent: changePercent ?? this.changePercent,
      isPositive: isPositive ?? this.isPositive,
      weight: weight ?? this.weight,
      price: price ?? this.price,
    );
  }
}

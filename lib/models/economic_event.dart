class EconomicEvent {
  final String date;
  final String country;
  final String event;
  final String impact;
  final String actual;
  final String forecast;
  final String previous;

  EconomicEvent({
    required this.date,
    required this.country,
    required this.event,
    required this.impact,
    required this.actual,
    required this.forecast,
    required this.previous,
  });

  factory EconomicEvent.fromJson(Map<String, dynamic> json) {
    return EconomicEvent(
      date: json['date'] ?? '',
      country: json['country'] ?? '',
      event: json['event'] ?? '',
      impact: json['impact'] ?? '',
      actual: json['actual'] ?? '',
      forecast: json['forecast'] ?? '',
      previous: json['previous'] ?? '',
    );
  }
}

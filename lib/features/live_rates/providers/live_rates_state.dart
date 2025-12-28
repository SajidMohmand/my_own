import '../../../models/metal_rate.dart';

class LiveRatesState {
  final List<MetalRate> metals;
  final DateTime lastUpdated;
  final bool isLoading;
  final bool isRefreshing;
  final String? error;

  const LiveRatesState({
    required this.metals,
    required this.lastUpdated,
    this.isLoading = false,
    this.isRefreshing = false,
    this.error,
  });

  LiveRatesState copyWith({
    List<MetalRate>? metals,
    DateTime? lastUpdated,
    bool? isLoading,
    bool? isRefreshing,
    String? error,
  }) {
    return LiveRatesState(
      metals: metals ?? this.metals,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      error: error ?? this.error,
    );
  }
}

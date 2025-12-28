import 'package:flutter_riverpod/flutter_riverpod.dart';


class SelectedIndexNotifier extends Notifier<int> {
  @override
  int build() => 2; // default: Live Rates (center)

  void setIndex(int index) {
    state = index;
  }
}
// speed_dial_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../import_data.dart';

class SpeedDialNotifier extends StateNotifier<bool> {
  SpeedDialNotifier() : super(false);

  void open() => state = true;
  void close() => state = false;
  void toggle() => state = !state;
}

final speedDialProvider = StateNotifierProvider<SpeedDialNotifier, bool>((ref) {
  return SpeedDialNotifier();
});

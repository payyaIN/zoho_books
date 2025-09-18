import '../../../import_data.dart';

class BottomNavBarNotifier extends StateNotifier<int> {
  BottomNavBarNotifier() : super(0);

  void setIndex(int index) {
    state = index;
  }
}

final bottomNavBarProvider = StateNotifierProvider<BottomNavBarNotifier, int>(
      (ref) => BottomNavBarNotifier(),
);

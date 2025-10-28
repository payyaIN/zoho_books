import 'package:payzo_books/import_data.dart';

/// -------- State --------
enum PayzoDiscountLevel { global, item }

@immutable
class PayzoDiscountState {
  final bool apply;
  final PayzoDiscountLevel level;
  const PayzoDiscountState({
    required this.apply,
    required this.level,
  });

  PayzoDiscountState copyWith({bool? apply, PayzoDiscountLevel? level}) =>
      PayzoDiscountState(apply: apply ?? this.apply, level: level ?? this.level);
}

class PayzoDiscountNotifier extends StateNotifier<PayzoDiscountState> {
  PayzoDiscountNotifier()
      : super(const PayzoDiscountState(
    apply: false,
    level: PayzoDiscountLevel.item,
  ));

  void setApply(bool value) => state = state.copyWith(apply: value);
  void setLevel(PayzoDiscountLevel value) => state = state.copyWith(level: value);
  void reset() => state = const PayzoDiscountState(apply: false, level: PayzoDiscountLevel.item);
}

final payzoDiscountProvider =
StateNotifierProvider.autoDispose<PayzoDiscountNotifier, PayzoDiscountState>(
        (ref) => PayzoDiscountNotifier());
final addBillGlobalDiscountProvider = Provider.autoDispose<TextEditingController>(
      (ref) => TextEditingController(),
);
final addBillItemDiscountProvider = Provider.autoDispose<TextEditingController>(
      (ref) => TextEditingController(),
);
// Add these providers (paste near your other providers)
final addBillGlobalDiscountCurrencyProvider = StateProvider.autoDispose<String?>(
      (ref) => null,
);
final addBillGlobalDiscountCurrencyIdProvider = StateProvider.autoDispose<int?>(
      (ref) => null,
);
final addBillItemCurrencySelector = StateProvider.autoDispose<String?>(
      (ref) => null,
);

final addBillItemCurrencySelectorId = StateProvider.autoDispose<int?>(
      (ref) => null,
);
final addBillItemDiscountCurrencyStringProvider = StateProvider.autoDispose<String?>(
      (ref) => '\$',
);
final addBillItemDiscountCurrencyProvider = StateProvider.autoDispose<bool?>(
      (ref) => true,
);
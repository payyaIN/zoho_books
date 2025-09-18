import 'package:payzo_books/data/models/payment_due_model/payment_due_model.dart';
import 'package:payzo_books/import_data.dart';

class PaymentDueNotifier extends StateNotifier<PaymentDueModel?> {
  PaymentDueNotifier() : super(null);

  void setPaymentDueData(PaymentDueModel dueModel) {
    state = dueModel;
  }

  void clearPaymentDueData() {
    state = null;
  }
}

final paymentDueProvider =
    StateNotifierProvider<PaymentDueNotifier, PaymentDueModel?>((ref) {
  return PaymentDueNotifier();
});

final selectedPaymentDueProvider =
    StateProvider<PaymentDueItem?>((ref) => null);

void setSelectedPaymentDue(WidgetRef ref, PaymentDueItem item) {
  ref.read(selectedPaymentDueProvider.notifier).state = item;
}

PaymentDueItem? getSelectedPaymentDue(WidgetRef ref) {
  return ref.read(selectedPaymentDueProvider);
}

final paymentDueByValueProvider =
    Provider.family<PaymentDueItem?, int>((ref, value) {
  final dueModel = ref.watch(paymentDueProvider);
  if (dueModel == null) return null;

  try {
    return dueModel.items.firstWhere((item) => item.value == value);
  } catch (e) {
    print('Payment due item with value $value not found');
    return null;
  }
});

final paymentDueInRangeProvider =
    Provider.family<List<PaymentDueItem>, PaymentDueRange>((ref, range) {
  final dueModel = ref.watch(paymentDueProvider);
  if (dueModel == null) return [];

  return dueModel.items
      .where((item) => item.days >= range.minDays && item.days <= range.maxDays)
      .toList();
});

class PaymentDueRange {
  final int minDays;
  final int maxDays;

  PaymentDueRange({
    required this.minDays,
    required this.maxDays,
  });
}

// models/pending_counts.dart

class PendingCounts {
  final int quote;
  final int purchaseOrder;
  final int bill;
  final int invoice;
  final int rfq;

  PendingCounts({
    required this.quote,
    required this.purchaseOrder,
    required this.bill,
    required this.invoice,
    required this.rfq,
  });

  factory PendingCounts.fromJson(Map<String, dynamic> json) {
    final count = json['response']['count'];
    return PendingCounts(
      quote: count['quote'] ?? 0,
      purchaseOrder: count['purchase_order'] ?? 0,
      bill: count['bill'] ?? 0,
      invoice: count['invoice'] ?? 0,
      rfq: count['rfq'] ?? 0,
    );
  }
}

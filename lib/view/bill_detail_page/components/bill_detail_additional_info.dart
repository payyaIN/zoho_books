import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/bill_detail_page/components/bill_additional_info.dart';
import 'package:payzo_books/view/bill_detail_page/components/bill_detail_error_widget.dart';

class BillDetailAdditionalInfo extends ConsumerStatefulWidget {
  final int? billId;
  const BillDetailAdditionalInfo({required this.billId, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BillDetailAdditionalInfoState();
}

class _BillDetailAdditionalInfoState
    extends ConsumerState<BillDetailAdditionalInfo> {
  @override
  Widget build(BuildContext context) {
    final effectiveBillId = widget.billId ?? 1;
    final billDetailsAsync = ref.watch(getBillDetailsProvider(effectiveBillId));
    return billDetailsAsync.when(
        data: (billDetail) {
          // return billDetail.billCustomerNotes.trim().isNotEmpty ||
          //         billDetail.billTermsCondition.trim().isNotEmpty
          //     ? billAdditionalInfo(
          //         billDetail: billDetail,
          //         customerNotes: billDetail.billCustomerNotes,
          //         termsAndConditions: billDetail.billTermsCondition)
          //     : SizedBox();
          final hasCustomerNotes =
              billDetail.billCustomerNotes?.trim().isNotEmpty ?? false;
          final hasTermsCondition =
              billDetail.billTermsCondition?.trim().isNotEmpty ?? false;

          return hasCustomerNotes || hasTermsCondition
              ? billAdditionalInfo(
                  billDetail: billDetail,
                  // ✅ FIX 2: Provide default empty string for nullable strings
                  // This prevents "The argument type 'String?' can't be assigned to the parameter type 'String'"
                  customerNotes: billDetail.billCustomerNotes ?? "",
                  termsAndConditions: billDetail.billTermsCondition ?? "")
              : const SizedBox();
        },
        loading: () => const Center(
              child: CircularProgressIndicator(
                color: AppColors.appMainColor,
              ),
            ),
        error: (e, stackTrace) => billErrorWidget(
              error: e.toString(),
              onRetry: () =>
                  ref.refresh(getBillDetailsProvider(effectiveBillId)),
            ));
  }
}

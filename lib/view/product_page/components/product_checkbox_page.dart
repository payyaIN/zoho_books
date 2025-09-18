import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/product_page/provider/product_selection.dart';

class ProductCheckboxPage extends ConsumerStatefulWidget {
  const ProductCheckboxPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProductCheckboxPageState();
}

class _ProductCheckboxPageState extends ConsumerState<ProductCheckboxPage> {
  @override
  Widget build(BuildContext context) {
    final productSelectionState = ref.watch(productSelectionProvider);
    var width = MediaQuery.of(context).size.width;
    final productSelectionNotifier =
        ref.read(productSelectionProvider.notifier);
    return productSelectionState.isSelectionMode
        ? Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              width: width,
              height: 139,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(-0.02, -1.00),
                  end: Alignment(0.02, 1),
                  colors: [
                    Colors.white.withOpacity(0.8),
                    Colors.white,
                  ],
                ),
              ),
              child: Transform.translate(
                offset: Offset(0, 30),
                child: Padding(
                  padding: const EdgeInsets.only(top: 15, left: 8, right: 8),
                  child: PayzoFormSubmitTwoButtons(
                      cancelText: AppText.cancel,
                      saveText: AppText.approve,
                      cancelOnPressed: productSelectionNotifier.resetSelection,
                      saveOnPressed: () {
                        final selectedIndices =
                            productSelectionNotifier.getSelectedIndices();
                        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        //     content: Text('Bulk Approval inprogress...')));
                        // bulkApproveAlert(
                        //     context,
                        //     AppText.bulkApprvConfrmtn,
                        //     AppText.bulkApprvalSubTitle,
                        //     AppText.bulkApprvalcontent);
                        print(
                            'Approving products at indices: $selectedIndices');
                      }),
                ),
              ),
            ),
          )
        : SizedBox();
  }
}

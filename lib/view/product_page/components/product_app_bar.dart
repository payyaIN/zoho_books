import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/product_page/provider/product_selection.dart';

class ProductAppBar extends ConsumerStatefulWidget {
  const ProductAppBar({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductAppBarState();
}

class _ProductAppBarState extends ConsumerState<ProductAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

PreferredSizeWidget productAppBar(
    {required BuildContext context, required WidgetRef ref}) {
  final productSelectionState = ref.watch(productSelectionProvider);
  final productSelectionNotifier = ref.read(productSelectionProvider.notifier);
  return reusableAppBarWithSuffixWidget(
    context: context,
    showTitle: true,
    showBackButton: false,
    isSuffixText: true,
    title: AppText.product,
    suffixText:
        productSelectionState.isSelectionMode ? AppText.cancel : AppText.select,
    onSuffixTap: () {
      productSelectionNotifier.toggleSelectionMode();
    },
  );
}

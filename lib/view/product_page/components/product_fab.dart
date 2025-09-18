import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/product_page/provider/product_selection.dart';

class ProductFloatingActionButton extends ConsumerStatefulWidget {
  const ProductFloatingActionButton({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProductFloatingActionButtonState();
}

class _ProductFloatingActionButtonState
    extends ConsumerState<ProductFloatingActionButton> {
  @override
  Widget build(BuildContext context) {
    final productSelectionState = ref.watch(productSelectionProvider);
    return productSelectionState.isSelectionMode
        ? Transform.translate(
            offset: Offset(0, -85),
            child: floatingActionBtn(
              onPress: () {
                Navigator.pushNamed(context, RouteNames.addProduct);
              },
            ))
        : floatingActionBtn(
            onPress: () {
              Navigator.pushNamed(context, RouteNames.addProduct);
            },
          );
  }
}

import 'package:payzo_books/import_data.dart';

class ProductPage extends ConsumerStatefulWidget {
  const ProductPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductPageState();
}

class _ProductPageState extends ConsumerState<ProductPage> {
  @override
  Widget build(BuildContext context) {
    return ScalingFactor(
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBgColor,
        appBar: productAppBar(context: context, ref: ref),
        body: Stack(
          children: [
            Column(
              children: [ProductBodyStatus(), ProductMainBody()],
            ),
            ProductCheckboxPage()
          ],
        ),
        floatingActionButton: ProductFloatingActionButton(),
      ),
    );
  }
}

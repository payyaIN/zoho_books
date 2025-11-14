import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/add/add_invoice/views/widgets/add_invoice_alfaris_card_details.dart';
import 'package:payzo_books/view/add/add_invoice/views/widgets/invoice_details_fields_new.dart';
import '../controllers/add_invoice_new_controller.dart';

class AddInvoiceNew extends ConsumerStatefulWidget {
  const AddInvoiceNew({super.key});

  @override
  ConsumerState<AddInvoiceNew> createState() => _AddInvoiceNewState();
}

class _AddInvoiceNewState extends ConsumerState<AddInvoiceNew> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(addInvoiceNewControllerProvider.notifier).initOnOpen();
    });
  }

  Future<bool> _onWillPop() async {
    ref.read(addInvoiceNewControllerProvider.notifier).clearAllSelections();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return  PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          _onWillPop();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundColorGrey,
        appBar: reusableAppBar(
          title: 'Add Invoice',
          context: context,
          showBackButton: true,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: ReusableColumn(
            children: const <Widget>[
              InvoiceDetailsFieldsNew(),
              AlfariDetailsCard()
            ],
          ),
        ),
      ),
    );
  }
}

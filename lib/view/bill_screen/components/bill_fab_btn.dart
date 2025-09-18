import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/bill_screen/provider/bill_fn_provider.dart';

Widget billFABBtn({
  required BuildContext context,
  required WidgetRef ref,
}) {
  final billSelectionState = ref.watch(billSelectionProvider);
  return billSelectionState.isSelectionMode
      ? Transform.translate(
          offset: Offset(0, -85),
          child: floatingActionBtn(
            onPress: () {
              Navigator.pushNamed(context, RouteNames.addBills);
            },
          ))
      : floatingActionBtn(
          onPress: () {
            Navigator.pushNamed(context, RouteNames.addBills);
          },
        );
}

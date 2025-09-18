import 'package:payzo_books/import_data.dart';

Widget customerFABBtn({
  required BuildContext context,
}) {
  return floatingActionBtn(
    onPress: () {
      Navigator.pushNamed(context, RouteNames.addCustomer);
    },
  );
}

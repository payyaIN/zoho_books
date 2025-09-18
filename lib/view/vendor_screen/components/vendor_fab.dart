import 'package:payzo_books/import_data.dart';

Widget vendorFabBtn({required BuildContext context}) {
  return floatingActionBtn(
    onPress: () {
      Navigator.pushNamed(context, RouteNames.addVendor);
    },
  );
}

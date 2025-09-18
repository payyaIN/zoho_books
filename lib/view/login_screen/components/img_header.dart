import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/utils/common_widgets/app_space.dart';

Center loginImageHeader() {
  return Center(
    child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GapSpace.height80,
          SvgPictureWIidget(
              image: 'assets/payzo_logo.svg', height: 30.87, width: 142),
          GapSpace.height40,
          SvgPictureWIidget(
              image: 'assets/login_header.svg', height: 236, width: 236),
          // GapSpace.height40,
        ]),
  );
}

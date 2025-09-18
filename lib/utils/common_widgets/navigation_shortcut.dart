import 'package:payzo_books/import_data.dart';

Future pushNavigate(BuildContext context, Widget widget) {
  return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ));
}

Future pushReplacementNavigate(BuildContext context, Widget widget) {
  return Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ));
}

Future pushAndRemoveUntilNavigate(BuildContext context, Widget widget) {
  return Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => widget),
    (route) => false,
  );
}

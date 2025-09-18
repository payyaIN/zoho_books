import 'package:payzo_books/import_data.dart';

class PendingListViewPage extends StatelessWidget {
  final Widget widget;
  final String title;

  const PendingListViewPage({super.key, required this.widget, required this.title});

  @override
  Widget build(BuildContext context) {
    return ScalingFactor(
        child: Scaffold(
      appBar:
          reusableAppBar(title: title, showBackButton: true, context: context),
      body: widget,
    ));
  }
}

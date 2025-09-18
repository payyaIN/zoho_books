import 'package:payzo_books/import_data.dart';
class CustomStackWidget extends StatelessWidget {
  final List<Widget> widgets;
  final Alignment alignment;
  final StackFit fit;
  final Clip clipBehavior;

  const CustomStackWidget({
    super.key,
    this.widgets = const [],
    this.alignment = Alignment.topLeft,
    this.fit = StackFit.loose,
    this.clipBehavior = Clip.hardEdge,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: alignment,
      fit: fit,
      clipBehavior: clipBehavior,
      children: widgets,
    );
  }
}

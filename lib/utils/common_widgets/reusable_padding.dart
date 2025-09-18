import 'package:payzo_books/import_data.dart';

class ReusablePadding extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final Widget child;

  const ReusablePadding({
    super.key,
    required this.padding,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ScalingFactor(
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}

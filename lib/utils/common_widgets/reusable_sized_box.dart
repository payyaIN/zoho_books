import 'package:payzo_books/import_data.dart';

class ReusableSizedBox extends StatelessWidget {
  final double? width;
  final double? height;
  final Widget? child;

  const ReusableSizedBox({
    super.key,
    this.width,
    this.height,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ScalingFactor(
      child: SizedBox(
        width: width,
        height: height,
        child: child,
      ),
    );
  }
}

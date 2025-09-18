import 'package:payzo_books/import_data.dart';
class GreyCard extends StatelessWidget {
  final double? borderRadius;
  final double? height;
  final double? width;
  final Widget? child;

  const GreyCard({super.key, this.borderRadius, this.height, this.width, this.child});

  @override
  Widget build(BuildContext context) {
    return ReusableContainer(
      color: const Color(0xFFEEEEEE),
      borderRadius: BorderRadius.all(Radius.circular(borderRadius!)),
      height: height,
      width: width,
      child: child,
    );
  }
}

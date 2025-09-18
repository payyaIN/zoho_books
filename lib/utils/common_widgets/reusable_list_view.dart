
import 'package:payzo_books/import_data.dart';
class ReusableListView extends StatelessWidget {
  final List<Widget> children;
  final Axis scrollDirection;
  final ScrollPhysics? physics;
  final EdgeInsetsGeometry? padding;
  final bool shrinkWrap;
  final bool reverse;
  final ScrollController? controller;
  final double? cacheExtent;

  const ReusableListView({
    super.key,
    required this.children,
    this.scrollDirection = Axis.vertical,
    this.physics,
    this.padding,
    this.shrinkWrap = false,
    this.reverse = false,
    this.controller,
    this.cacheExtent,
  });

  @override
  Widget build(BuildContext context) {
    return ScalingFactor(
      child: ListView(
        scrollDirection: scrollDirection,
        physics: physics,
        padding: padding,
        shrinkWrap: shrinkWrap,
        reverse: reverse,
        controller: controller,
        cacheExtent: cacheExtent,
        children: children,
      ),
    );
  }
}

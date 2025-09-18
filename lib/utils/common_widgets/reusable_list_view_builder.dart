import 'package:payzo_books/import_data.dart';

class ReusableListViewBuilder extends StatelessWidget {
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;
  final Axis scrollDirection;
  final ScrollPhysics? physics;
  final EdgeInsetsGeometry? padding;
  final bool shrinkWrap;
  final bool reverse;
  final ScrollController? controller;
  final double? cacheExtent;

  const ReusableListViewBuilder({
    Key? key,
    required this.itemCount,
    required this.itemBuilder,
    this.scrollDirection = Axis.vertical,
    this.physics,
    this.padding,
    this.shrinkWrap = false,
    this.reverse = false,
    this.controller,
    this.cacheExtent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScalingFactor(
      child: ListView.builder(
        itemCount: itemCount,
        itemBuilder: itemBuilder,
        scrollDirection: scrollDirection,
        physics: physics,
        padding: padding,
        shrinkWrap: shrinkWrap,
        reverse: reverse,
        controller: controller,
        cacheExtent: cacheExtent,
      ),
    );
  }
}

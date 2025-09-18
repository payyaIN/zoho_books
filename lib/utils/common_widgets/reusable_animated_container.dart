import 'package:payzo_books/import_data.dart';

class ReusableAnimatedContainer extends StatelessWidget {
  final Duration duration;
  final Curve curve;
  final Color? color;
  final double? width;
  final double? height;
  final double? borderRadius;
  final BoxDecoration? decoration;
  final Widget? child;
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? padding;
  final BoxConstraints? constraints;
  final Decoration? foregroundDecoration;
  final Matrix4? transform;
  final Clip ?clipBehavior;
  final AlignmentGeometry? transformAlignment;



  const ReusableAnimatedContainer({
    Key? key,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
    this.color,
    this.width,
    this.height,
    this.borderRadius,
    this.decoration,
    this.child,
    this.alignment,
    this.padding,
    this.constraints,
    this.foregroundDecoration,
    this.transform,
    this.clipBehavior,
    this.transformAlignment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScalingFactor(
      child: AnimatedContainer(
        duration: duration,
        curve: curve,
        color: color,
        width: width,
        height: height,
        decoration: decoration ??
            BoxDecoration(
              color: color,
              borderRadius: borderRadius != null
                  ? BorderRadius.circular(borderRadius!)
                  : null,
            ),
        alignment: alignment,
        padding: padding,
        constraints: constraints,
        foregroundDecoration: foregroundDecoration,
        transform: transform,
        clipBehavior: clipBehavior!,
        transformAlignment: transformAlignment,
        child: child,
      ),
    );
  }
}

import 'package:payzo_books/import_data.dart';

class ReusableContainer extends StatelessWidget {
  final Widget? child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BoxDecoration? decoration;
  final Color? color;
  final AlignmentGeometry? alignment;
  final BoxConstraints? constraints;
  final BorderRadiusGeometry? borderRadius;
  final List<BoxShadow>? boxShadow;
  final Gradient? gradient;
  final double? borderWidth;
  final Color? borderColor;
  final Matrix4? transform;
  final GestureTapCallback? onTap;

  const ReusableContainer({
    super.key,
    this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.decoration,
    this.color,
    this.alignment,
    this.constraints,
    this.borderRadius,
    this.boxShadow,
    this.gradient,
    this.borderWidth,
    this.borderColor,
    this.transform,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ScalingFactor(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: width,
          height: height,
          padding: padding,
          margin: margin,
          alignment: alignment,
          constraints: constraints,
          decoration: decoration ??
              BoxDecoration(
                color: color,
                borderRadius: borderRadius,
                boxShadow: boxShadow,
                gradient: gradient,
                border: borderWidth != null
                    ? Border.all(
                  color: borderColor ?? Colors.black,
                  width: borderWidth!,
                )
                    : null,
              ),
          transform: transform,
          child: child,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:scaled_app/scaled_app.dart';

class ScalingFactor extends StatefulWidget {
  Widget child;
  ScalingFactor({required this.child, super.key});

  @override
  State<ScalingFactor> createState() => _ScalingFactorState();
}

class _ScalingFactorState extends State<ScalingFactor> {
  int currentPageIndex = 0;
  bool scaleMediaQueryData = true;

  @override
  Widget build(BuildContext context) {
    final originalMediaQueryData = MediaQuery.of(context).copyWith(
      textScaler: TextScaler.noScaling,
    );
    final scaledMediaQueryData = originalMediaQueryData.scale();

    return MediaQuery(
        data:
            scaleMediaQueryData ? scaledMediaQueryData : originalMediaQueryData,
        child: widget.child);
  }
}

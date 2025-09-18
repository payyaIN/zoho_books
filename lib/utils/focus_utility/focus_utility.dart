import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final focusUtilsProvider = Provider<FocusUtils>((ref) => FocusUtils());

class FocusUtils {
  Future<void> unfocusAndDelay() async {
    FocusManager.instance.primaryFocus?.unfocus();
    await Future.delayed(const Duration(milliseconds: 100));
  }
}

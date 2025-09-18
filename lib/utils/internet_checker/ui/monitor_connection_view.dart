import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payzo_books/utils/app_data/color_palette.dart';
import 'package:payzo_books/utils/internet_checker/provider/connectivity_provider.dart';
import 'package:payzo_books/utils/common_widgets/app_space.dart';

class MonitorConnectionView extends ConsumerWidget {
  final Widget child;

  const MonitorConnectionView({Key? key, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivityStatus = ref.watch(connectivityStatusProvider);

    return Scaffold(
      body: Stack(
        children: [
          child,
          connectivityStatus.when(
            data: (isConnected) => isConnected
                ? const SizedBox.shrink()
                : _buildNoInternetOverlay(context),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildNoInternetOverlay(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        color: AppColors.appMainColor,
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off, color: Colors.white),
            GapSpace.width15,
            Text(
              'No Internet Connection',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

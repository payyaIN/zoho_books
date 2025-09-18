import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/splash_screen/notifiers/splash_notifier.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<bool?>(authProvider, (previous, isAuthenticated) {
      if (isAuthenticated != null) {
        Future.delayed(Duration(microseconds: 3000)).whenComplete(
          () {
            Navigator.pushReplacementNamed(
              context,
              isAuthenticated ? RouteNames.homeScreen : RouteNames.loginScreen,
            );
          },
        );
      }
    });

    return Scaffold(
      body: Center(
        child: SvgPictureWidget(
          image: 'assets/payzo-logo (1).svg',
          height: 100,
          width: 200,
        ),
      ),
    );
  }
}

// import 'package:payzo_books/import_data.dart';
// import 'package:payzo_books/utils/clear_state/clear_app_state.dart';
// import 'package:payzo_books/view/splash_screen/notifiers/splash_notifier.dart';

// class SplashScreen extends ConsumerWidget {
//   const SplashScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     ref.listen<bool?>(authProvider, (previous, isAuthenticated) async {
//       if (isAuthenticated != null) {
//         print(
//             '🔄 App starting - clearing any cached data for fresh session...');
//         try {
//           await ProviderInvalidationHelper.invalidateAllProviders(ref);
//           print('✅ All cached data cleared before navigation');
//         } catch (e) {
//           print('❌ Error clearing cached data on app start: $e');
//           // Continue with navigation even if invalidation fails
//         }

//         // Navigate after clearing cache
//         Future.delayed(Duration(milliseconds: 500)).whenComplete(() {
//           if (context.mounted) {
//             Navigator.pushReplacementNamed(
//               context,
//               isAuthenticated ? RouteNames.homeScreen : RouteNames.loginScreen,
//             );
//           }
//         });
//       }
//     });

//     return Scaffold(
//       body: Center(
//         child: SvgPictureWidget(
//           image: 'assets/payzo-logo (1).svg',
//           height: 100,
//           width: 200,
//         ),
//       ),
//     );
//   }
// }

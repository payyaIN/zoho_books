import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/splash_screen/notifiers/splash_notifier.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    ref.listen<bool?>(authProvider, (previous, isAuthenticated) {
      if (isAuthenticated != null) {
        Future.delayed(Duration(microseconds: 3000)).whenComplete(() {
          Navigator.pushReplacementNamed(
            context,
            isAuthenticated ? RouteNames.homeScreen : RouteNames.loginScreen,
          );
        },);
      }
    });

    return Scaffold(
      body: Center(
        child: SvgPictureWidget(image: 'assets/payzo-logo (1).svg', height: 100, width: 200,),
      ),
    );
  }
}

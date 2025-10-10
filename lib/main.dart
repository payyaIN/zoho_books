import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:payzo_books/data/services/notification_services.dart';
import 'package:payzo_books/import_data.dart';

import 'firebase_options.dart';

double scaleFactorCallback(Size deviceSize) {
  const double widthOfDesign = 435;
  return deviceSize.width / widthOfDesign;
}
// void main() {
//   ScaledWidgetsFlutterBinding.ensureInitialized(
//     scaleFactor: scaleFactorCallback,
//   );
//   SharedPreferencesHelper.init();
//   SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
//   SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
//     statusBarColor: Colors.transparent,
//     systemNavigationBarColor: Colors.transparent,
//   ));
//   runApp(const ProviderScope(child: MyApp()));
// }
Future<void> main() async {
//Firebase Account
//techinterland@gmail.com
//pass:techinterland123@
  // WidgetsFlutterBinding.ensureInitialized();
  ScaledWidgetsFlutterBinding.ensureInitialized(
    scaleFactor: (deviceSize) {
      // screen width used in your UI design
      const double widthOfDesign = 435;
      // const double widthOfDesign = 435;
      return deviceSize.width / widthOfDesign;
    },
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // FirebaseMessaging.onBackgroundMessage((message) => _firebaseMessagingBackgroundHandler(message));
  // HttpOverrides.global = MyHttpOverrides();
  SharedPreferencesHelper.init();
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
  //     statusBarColor: Colors.transparent,
  //     systemNavigationBarColor: Colors.transparent,
  //     systemStatusBarContrastEnforced: false,
  //     systemNavigationBarContrastEnforced: false,
  //     statusBarBrightness: Brightness.dark,
  //     statusBarIconBrightness: Brightness.dark,
  //     systemNavigationBarIconBrightness: Brightness.dark,
  //     systemNavigationBarDividerColor: Colors.black));
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  AppRouter router = AppRouter();

  @override
  void initState() {
    super.initState();
    final container = ProviderScope.containerOf(context, listen: false);
    final notificationService = container.read(notificationProvider);

    notificationService.requestPermission();
    notificationService.firebaseInit(context);
    notificationService.initLocalNotifications(context);
    notificationService.getDeviceToken().then((token) {
      debugPrint('FCM Token: $token');
      SharedPreferencesHelper.saveString('fcm_token', '$token');
      String? fcmToken = SharedPreferencesHelper.getString('fcm_token');
      print('stored fcm token is:$fcmToken');
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScalingFactor(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Payzo Books',
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.backgroundColorGrey,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        onGenerateRoute: router.onGenerateRoute,
      ),
    );
  }
}

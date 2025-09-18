import 'package:payzo_books/view/bill_screen/bill_screen.dart';
import 'package:payzo_books/view/invoice_screen/invoice_screen.dart';
import 'package:payzo_books/view/main_screen/notifiers/bottom_nav_bar_notifier.dart';
import '../../import_data.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  final PageController _pageController = PageController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final selectedIndex = ref.read(bottomNavBarProvider);
      _pageController.jumpToPage(selectedIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(bottomNavBarProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_pageController.hasClients &&
          _pageController.page?.round() != currentIndex) {
        _pageController.jumpToPage(currentIndex);
      }
    });

    return ScalingFactor(
      child: SafeArea(
        top: false,
        child: Scaffold(
          body: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (index) =>
                ref.read(bottomNavBarProvider.notifier).state = index,
            children: const <Widget>[
              PayzoHome(),
              ProductPage(),
              InvoiceScreen(),
              BillScreen(),
              MoreScreen(),
            ],
          ),
          bottomNavigationBar:
              BottomNavBarPayzo(pageController: _pageController),
        ),
      ),
    );
  }
}

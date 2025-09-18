import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/main_screen/notifiers/bottom_nav_bar_notifier.dart';

class BottomNavBarPayzo extends ConsumerWidget {
  final PageController pageController;

  const BottomNavBarPayzo({Key? key, required this.pageController})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(bottomNavBarProvider);

    return ReusablePadding(
      padding: const EdgeInsets.only(bottom: 15, right: 18, left: 18),
      child: Container(
        height: 75,
        width: 354,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: const BoxDecoration(
          color: Color(0xFFF7F7F7),
          borderRadius: BorderRadius.all(Radius.circular(12)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              spreadRadius: 2,
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              ref,
              selectedIndex == 0 ? 'assets/home_purple.svg' : 'assets/home-outlined.svg',
              "Home",
              0,
            ),
            _buildNavItem(
              ref,
              selectedIndex == 1 ? 'assets/Product_purple.svg' : 'assets/Product_line.svg',
              "Product",
              1,
            ),
            _buildNavItem(
              ref,
              selectedIndex == 2 ? 'assets/invoice_purple.svg' : 'assets/invoice-svgrepo-com 1.svg',
              "Invoices",
              2,
            ),
            _buildNavItem(
              ref,
              selectedIndex == 3 ? 'assets/bill_purple.svg' : 'assets/bill-list-svgrepo-com (2) 1.svg',
              "Bills",
              3,
            ),
            _buildNavItem(
              ref,
              selectedIndex == 4 ? 'assets/more_purple.svg' : 'assets/more-horizontal-square-svgrepo-com 1.svg',
              "More",
              4,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(WidgetRef ref, String icon, String label, int index) {
    final isSelected = ref.watch(bottomNavBarProvider) == index;

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          ref.read(bottomNavBarProvider.notifier).setIndex(index);
          pageController.jumpToPage(index);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPictureWIidget(image: icon, height: 24, width: 24),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.appMainColor : const Color(0xFF999999),
                fontSize: 10,
                fontFamily: 'SF Pro Display',
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

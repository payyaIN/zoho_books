import 'package:payzo_books/import_data.dart';

class PayzoSwipableTopBar extends ConsumerStatefulWidget {
  const PayzoSwipableTopBar({super.key});

  @override
  ConsumerState<PayzoSwipableTopBar> createState() => _PayzoSwipableTopBarState();
}

class _PayzoSwipableTopBarState extends ConsumerState<PayzoSwipableTopBar> {
  int selectedIndex = 0;

  final List<_TabItem> tabs = [
    _TabItem(text: 'Dashboard', asset: 'assets/dashboard_purple.svg'),
    _TabItem(text: 'Announcements', asset: 'assets/announcement-02-svgrepo-com 1.svg'),
    _TabItem(text: 'Helps', asset: 'assets/help-svgrepo-com 1.svg'),
  ];

  @override
  Widget build(BuildContext context) {
    return ScalingFactor(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: ReusablePadding(
          padding: const EdgeInsets.only(left: 22, right: 22, top: 20),
          child: Row(
            children: List.generate(tabs.length, (index) {
              final tab = tabs[index];
              return Padding(
                padding: const EdgeInsets.only(right: 30),
                child: PayzoHomeTopBarButton(
                  text: tab.text,
                  assetName: tab.asset,
                  onTapped: index == selectedIndex,
                  OnTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _TabItem {
  final String text;
  final String asset;
  _TabItem({required this.text, required this.asset});
}

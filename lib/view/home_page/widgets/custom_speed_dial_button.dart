import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/home_page/notifier/speed_dial_notifier.dart';
class CustomSpeedDial extends StatefulWidget {
  const CustomSpeedDial({super.key});

  @override
  State<CustomSpeedDial> createState() => _CustomSpeedDialState();
}

class _CustomSpeedDialState extends State<CustomSpeedDial> {
  @override
  Widget build(BuildContext context) {
    return ScalingFactor(
      child: SpeedDial(
        key: const ValueKey('fab_key'), // static key
        backgroundColor: const Color(0xFF3F53EE),
        renderOverlay: false,
        buttonSize: const Size(65, 65),
        childrenButtonSize: const Size(60, 60),
        icon: Icons.add,
        activeIcon: Icons.close,
        iconTheme: const IconThemeData(color: Colors.white),
        children: [
          _buildChild(context, 'Invoice', 'assets/invoice-svgrepo-com-green.svg', RouteNames.addInvoice),
          _buildChild(context, 'Bills', 'assets/wallet-svgrepo-com (2)-green.svg', RouteNames.addBills),
          _buildChild(context, 'Customer', 'assets/user-svgrepo-com (8)-green.svg', RouteNames.addCustomer),
          _buildChild(context, 'Vendor', 'assets/document-list-svgrepo-com-green.svg', RouteNames.addVendor),
          _buildChild(context, 'Product', 'assets/invoice-svgrepo-com-green.svg', RouteNames.addProduct),
        ],
      ),
    );
  }

  SpeedDialChild _buildChild(BuildContext context, String text, String image, String routeName) {
    return SpeedDialChild(
      shape: const CircleBorder(),
      backgroundColor: const Color(0xFFF5F5F5),
      child: SpeedDialChikldrenWidget(text: text, image: image),
      onTap: () {
        Navigator.pushNamed(context, routeName);
      },
    );
  }
}
class CustomFabMenu extends StatefulWidget {
  const CustomFabMenu({super.key});

  @override
  State<CustomFabMenu> createState() => _CustomFabMenuState();
}

class _CustomFabMenuState extends State<CustomFabMenu> with SingleTickerProviderStateMixin {
  bool isOpen = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 250));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  void _toggleMenu() {
    setState(() {
      isOpen = !isOpen;
      isOpen ? _controller.forward() : _controller.reverse();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScalingFactor(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          if (isOpen) ..._buildFabActions(),
          ReusableSizedBox(
            height: 65,
            width: 65,
            child: FloatingActionButton(
              backgroundColor: AppColors.appMainColor,
              shape: const CircleBorder(),
              onPressed: _toggleMenu,
              child: Icon(isOpen ? Icons.close : Icons.add, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFabActions() {
    final actions = [
      _fabAction('Invoice', 'assets/invoice-svgrepo-com 1.svg', RouteNames.addInvoice),
      _fabAction('Bills', 'assets/wallet-svgrepo-com (2) 1.svg', RouteNames.addBills),
      _fabAction('Customer', 'assets/user-svgrepo-com (8) 1.svg', RouteNames.addCustomer),
      _fabAction('Vendor', 'assets/Group.svg', RouteNames.addVendor),
      _fabAction('Product', 'assets/Group 21073.svg', RouteNames.addProduct),
    ];

    return List.generate(actions.length, (index) {
      return ScaleTransition(
        scale: _animation,
        child: Padding(
          padding: EdgeInsets.only(bottom: 80.0 + (index * 75)),
          child: actions[index],
        ),
      );
    });
  }

  Widget _fabAction(String label, String iconPath, String routeName) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, routeName);
          },
          child:
        //   Container(
        //     margin: const EdgeInsets.only(right: 8.0),
        //     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        //     decoration: BoxDecoration(
        //       color: Colors.white,
        //       borderRadius: BorderRadius.circular(8),
        //       boxShadow: [
        //         BoxShadow(
        //           color: Colors.black12,
        //           blurRadius: 6,
        //         )
        //       ],
        //     ),
        //     child: Text(label, style: const TextStyle(fontSize: 14)),
        //   ),
        // ),
        SizedBox(
          height: 65,
          width: 65,
          child: FloatingActionButton(
            heroTag: label,
            mini: false,
            shape: const CircleBorder(),
            backgroundColor:Color.fromRGBO(245, 245, 245, 1),
            onPressed: () {
              setState(() {
                isOpen = false;
                _controller.reverse();
              });
              Navigator.pushNamed(context, routeName);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(iconPath, height: routeName==RouteNames.addVendor?18:routeName==RouteNames.addInvoice?25:22, width: 22),
                ReusableSizedBox(),
                ReusableText(text: label, fontSize: 10,color: Color.fromRGBO(124, 124, 124, 1),),
              ],
            ),
          ),
        ),)
      ],
    );
  }
}




class SvgPictureWidget extends StatelessWidget {
  final String image;
  final double height;
  final double width;

  const SvgPictureWidget({
    super.key,
    required this.image,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: width,
        height: height,
        child: SvgPicture.asset(
          image,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

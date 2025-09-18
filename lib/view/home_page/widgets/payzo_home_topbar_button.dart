import 'package:payzo_books/import_data.dart';

class PayzoHomeTopBarButton extends StatefulWidget {
  final String assetName;
  final String text;
  final bool onTapped;
  final VoidCallback OnTap;

  const PayzoHomeTopBarButton({
    super.key,
    required this.assetName,
    required this.text,
    required this.onTapped,
    required this.OnTap,
  });

  @override
  State<PayzoHomeTopBarButton> createState() => _PayzoHomeTopBarButtonState();
}

class _PayzoHomeTopBarButtonState extends State<PayzoHomeTopBarButton> {
  final GlobalKey _rowKey = GlobalKey();
  double rowWidth = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _calculateRowWidth());
  }

  @override
  void didUpdateWidget(covariant PayzoHomeTopBarButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) => _calculateRowWidth());
  }

  void _calculateRowWidth() {
    final RenderBox? renderBox = _rowKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null && mounted) {
      setState(() {
        rowWidth = renderBox.size.width;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color iconColor = widget.onTapped ? AppColors.appMainColor : const Color(0xFFA8A8A8);

    return GestureDetector(
      onTap: widget.OnTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            key: _rowKey,
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                widget.assetName,
                width: 20,
                height: 20,
                color: iconColor, // ✅ Change icon color here
              ),
              const SizedBox(width: 6),
              Text(
                widget.text,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: iconColor,
                  fontFamily: 'SF Pro Display',
                ),
              ),
            ],
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 80),
            margin: const EdgeInsets.only(top: 5),
            height: 3,
            width: widget.onTapped ? rowWidth : 0,
            decoration: BoxDecoration(
              color: AppColors.appMainColor,
              borderRadius: BorderRadius.circular(4),
            ),
          )
        ],
      ),
    );
  }
}

import 'package:payzo_books/utils/common_widgets/payzo_divider.dart';
import '../../../import_data.dart';

class MoreModulesListTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool divider;

  const MoreModulesListTile({
    super.key,
    required this.title,
    required this.onTap,
    this.divider = true,
  });

  @override
  Widget build(BuildContext context) {
    return ScalingFactor(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8), // optional for tap feedback
        child: Container(
          width: double.infinity,
          child: ReusableColumn(
            children: [
              ReusableRow(
                children: [
                  ReusableText(
                    text: title,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    fontFamily: 'SF Pro Display',
                  ),
                  const Spacer(),
                  ReusableText(
                    text: 'Tap to Enter',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    fontFamily: 'SF Pro Display',
                    color: const Color.fromRGBO(119, 119, 119, 1),
                  ),
                ],
              ),
              const ReusableSizedBox(height: 8),
              divider ? const PayzoDivider() : const ReusableSizedBox(),
              const ReusableSizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

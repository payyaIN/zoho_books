import '../../import_data.dart';

class FormCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final String title;

  const FormCheckbox({
    super.key,
    required this.value,
    required this.title,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (onChanged != null) {
          onChanged!(!value);
        }
      },
      child: ReusableRow(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.appMainColor, // ✅ same color as FormRadioButton
            side: BorderSide(
              color: AppColors.appMainColor, // ✅ same border color
              width: 1.6,
            ),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: const VisualDensity(horizontal: -4.0, vertical: -4.0),
          ),
          const ReusableSizedBox(width: 2.5),
          ReusableText(
            text: title,
            fontFamily: 'SF Pro Display',
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: const Color.fromRGBO(51, 51, 51, 1),
          ),
          PayzoDivider(),
        ],
      ),
    );
  }
}

import '../../import_data.dart';

class FormRadioButton extends StatelessWidget {
  final String value;
  final String groupValue;
  final String title;
  final void Function(String?)? onChanged;
  const FormRadioButton({super.key, required this.value, required this.groupValue, required this.title, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return ReusableRow(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Radio(
          activeColor: AppColors.appMainColor,
          value: value,
          groupValue: groupValue,
          onChanged:onChanged,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity(horizontal: -4.0, vertical: -4.0),
        ),
        ReusableSizedBox(
          width: 2.5,
        ),
        ReusableText(
          text: title,
          fontFamily: 'SF Pro Display',
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: Color.fromRGBO(51, 51, 51, 1),
        ),
        PayzoDivider()
      ],
    );
  }
}

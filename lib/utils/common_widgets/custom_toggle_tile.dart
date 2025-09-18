import '../../import_data.dart';

class CustomToggleTile extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool divider;

  final bool disableSwitch;

  const CustomToggleTile({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    required this.divider,
    this.disableSwitch = false,
  });

  @override
  Widget build(BuildContext context) {
    return ReusableColumn(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ReusableText(
              text: title,
              fontFamily: 'SF Pro Display',
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: const Color.fromRGBO(51, 51, 51, 1),
            ),
            SizedBox(
              height: 27,
              width: 44.42,
              child: IgnorePointer(
                ignoring: disableSwitch,
                child: Switch(
                  value: value,
                  onChanged: disableSwitch ? null : onChanged,
                  activeColor: Colors.white,
                  activeTrackColor: AppColors.appMainColor,
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: Colors.black38,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ),
          ],
        ),
        ReusableSizedBox(height: divider == true ? 8 : 0),
        divider == true ? PayzoDivider() : ReusableSizedBox()
      ],
    );
  }
}

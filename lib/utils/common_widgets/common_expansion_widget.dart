import 'package:payzo_books/import_data.dart';

Widget customExpandableSection(
  BuildContext context, {
  required String title,
  String? content,
  Widget? contentWidget,
  required bool isPrefixIconNeeded,
  String? prefixImg,
  required bool isContentTypeString,
}) {
  return FormContainer(
      height: double.infinity,
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          title: isPrefixIconNeeded
              ? Row(
                  children: [
                    SvgPictureWidget(
                        image: prefixImg ?? '', height: 24, width: 24),
                    GapSpace.width5,
                    ReusableText(
                      text: title,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'SF Pro Display',
                      fontSize: 16,
                    ),
                  ],
                )
              : ReusableText(
                  text: title,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'SF Pro Display',
                  fontSize: 16,
                ),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: isContentTypeString == true
                      ? ReusableText(
                          text: content ?? "",
                          fontWeight: FontWeight.w400,
                          fontFamily: 'SF Pro Display',
                          fontSize: 14,
                        )
                      : contentWidget),
            ),
          ],
        ),
      ));
}

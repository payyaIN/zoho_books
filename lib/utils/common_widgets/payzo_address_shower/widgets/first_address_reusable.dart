import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/utils/common_widgets/payzo_address_shower/widgets/address_shower_subtitle_text.dart';
import 'package:payzo_books/utils/common_widgets/payzo_address_shower/widgets/address_shower_title_text.dart';

class FirstAddressReusable extends ConsumerWidget {
  final String title;
  final List<String> firstAddressList;

  const FirstAddressReusable({
    super.key,
    required this.title,
    required this.firstAddressList,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScalingFactor(
      child: ReusableColumn(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          AddressShowerTitleText(title: title),
          const SizedBox(height: 6),
          if (firstAddressList.isEmpty)
            const SizedBox.shrink()
          else
            ListView.builder(
              itemCount: firstAddressList.length,
              shrinkWrap: true,
              primary: false,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: AddressShowerSubtitleText(
                    title: firstAddressList[index],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/utils/common_widgets/payzo_address_shower/providers/payzo_address_shower_provider.dart' show payzoFirstAddressListProvider, payzoSecondAddressListProvider;
import 'package:payzo_books/utils/common_widgets/payzo_address_shower/widgets/first_address_reusable.dart';

class PayzoAddressShower extends ConsumerWidget {
  final String title;
  final String secondTitle;

  const PayzoAddressShower({
    super.key,
    required this.title,
    required this.secondTitle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firstList = ref.watch(payzoFirstAddressListProvider);
    final secondList = ref.watch(payzoSecondAddressListProvider);

    return ScalingFactor(
      child: ReusableColumn(
        children: [
          ReusableRow(
            children: <Widget>[
              Expanded(
                  child: FirstAddressReusable(
                      title: title, firstAddressList: firstList)),
              const SizedBox(width: 16),
              Expanded(
                  child: FirstAddressReusable(
                      title: secondTitle, firstAddressList: secondList)),
            ],
          ),
          const SizedBox(height: 6),
          PayzoDivider(),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}

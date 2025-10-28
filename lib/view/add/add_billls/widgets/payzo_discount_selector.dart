import 'package:payzo_books/view/add/add_billls/notifier/add_bill_providers.dart';
import '../../../../import_data.dart';
import '../../../../utils/common_widgets/form_check_box.dart';

class PayzoDiscountSelector extends ConsumerWidget {
  final String title;
  final String globalLabel;
  final String itemLabel;
  final Color? activeColor; // default = #0599FB if null
  final double spacing;

  const PayzoDiscountSelector({
    super.key,
    this.title = 'Apply Discount',
    this.globalLabel = 'Global level discount',
    this.itemLabel = 'Item level discount',
    this.activeColor,
    this.spacing = 12,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(payzoDiscountProvider);
    final notifier = ref.read(payzoDiscountProvider.notifier);
    final Color selectedColor = activeColor ?? const Color(0xFF0599FB);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormCheckbox(
          value: state.apply,
          onChanged: (v) => notifier.setApply(v ?? false),
          title: title,
        ),
        SizedBox(height: spacing),
        // ✅ Radio Buttons Column (Global / Item level)
        Opacity(
          opacity: state.apply ? 1 : 0.5,
          child: IgnorePointer(
            ignoring: !state.apply,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FormRadioButton(
                  value: PayzoDiscountLevel.global.name,
                  groupValue: state.level.name,
                  title: globalLabel,
                  onChanged: (val) {
                    if (val == null) return;
                    final selected = PayzoDiscountLevel.values.firstWhere((e) => e.name == val);
                    notifier.setLevel(selected);
                  },
                ),
                const ReusableSizedBox(height: 10),
                FormRadioButton(
                  value: PayzoDiscountLevel.item.name,
                  groupValue: state.level.name,
                  title: itemLabel,
                  onChanged: (val) {
                    if (val == null) return;
                    final selected = PayzoDiscountLevel.values.firstWhere((e) => e.name == val);
                    notifier.setLevel(selected);
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

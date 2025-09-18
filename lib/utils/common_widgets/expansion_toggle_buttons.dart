import 'package:payzo_books/view/add/add_product/add_product.dart';

import '../../import_data.dart';

class ExpansionToggleButtons extends ConsumerWidget {
  final String title;
  final void Function(bool) onExpansionChanged;
  final bool initiallyExpanded;
  final List<Widget> children;

  const ExpansionToggleButtons(this.title, this.initiallyExpanded,
      this.children, this.onExpansionChanged,
      {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
        visualDensity: VisualDensity.compact,
      ),
      child: ExpansionTile(
          tilePadding: EdgeInsets.zero,
          childrenPadding: EdgeInsets.zero,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontFamily: 'SF Pro Display',
                  fontSize: 16,
                ),
              ),
            ],
          ),
          onExpansionChanged: (_) => onExpansionChanged,
          initiallyExpanded: initiallyExpanded,
          children: children),
    );
  }
}

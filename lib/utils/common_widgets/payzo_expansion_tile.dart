import 'package:payzo_books/import_data.dart';

class CustomExpansionTile extends ConsumerWidget {
  final String title;
  final bool isExpanded;
  final VoidCallback onToggle;
  final Widget child;
  final double height;

  const CustomExpansionTile({
    super.key,
    required this.title,
    required this.isExpanded,
    required this.onToggle,
    required this.child,
    required this.height,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FormContainer(
      height: height,
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontFamily: 'SF Pro Display',
              fontSize: 16,
            ),
          ),
          onExpansionChanged: (_) => onToggle(),
          childrenPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          initiallyExpanded: isExpanded,
          children: [
            child,
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

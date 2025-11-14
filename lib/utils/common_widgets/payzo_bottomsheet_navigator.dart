import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/utils/common_widgets/red_star_widget.dart';

class PayzoBottomsheetNavigator extends StatelessWidget {
  final String title;
  final String trailing;
  final VoidCallback onTap;
  final bool addButton;
  final bool isPayzoColor;
  final bool divider;
  final bool required;
  final bool enabled;
  final bool navigationButton;
  final String? errorText;

  /// New: callback for clearing/unselecting the current selection
  final VoidCallback? onUnselect;

  /// New: control whether the clear/unselect button is shown when there is a selection.
  final bool showClearButton;

  const PayzoBottomsheetNavigator({
    super.key,
    required this.title,
    required this.trailing,
    required this.onTap,
    this.addButton = false,
    this.isPayzoColor = false,
    this.divider = true,
    this.required = false,
    this.errorText,
    this.navigationButton = true,
    this.enabled = true,
    this.onUnselect,
    this.showClearButton = true, // default: show clear button when selection exists
  });

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null && errorText!.isNotEmpty;
    final hasSelection = trailing.isNotEmpty;

    return ScalingFactor(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          // main row tap (open bottomsheet) - only active when enabled
          onTap: enabled ? onTap : null,
          child: ReusableColumn(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ReusableContainer(
                color: Colors.transparent,
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Title + Trailing
                    Expanded(
                      child: (isPayzoColor == false || trailing == '')
                          ? Row(
                        children: [
                          ReusableText(
                            text: title,
                            fontFamily: 'SF Pro Display',
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: enabled
                                ? const Color.fromRGBO(51, 51, 51, 1)
                                : Colors.grey, // ✨ Disabled color
                          ),
                          if (required)
                            const Text(
                              ' *',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                        ],
                      )
                          : ReusableColumn(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              ReusableText(
                                text: title,
                                fontFamily: 'SF Pro Display',
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                color: enabled
                                    ? const Color.fromRGBO(51, 51, 51, 1)
                                    : Colors.grey,
                              ),
                              if (required) RedStarWidget(),
                            ],
                          ),
                          const ReusableSizedBox(height: 5),
                          Row(
                            children: [
                              ReusableText(
                                text: trailing,
                                fontFamily: 'SF Pro Display',
                                overflow: TextOverflow.ellipsis,
                                fontWeight: isPayzoColor
                                    ? FontWeight.w500
                                    : FontWeight.w400,
                                fontSize: 14,
                                color: enabled
                                    ? (isPayzoColor
                                    ? AppColors.appMainColor
                                    : const Color.fromRGBO(
                                    51, 51, 51, 1))
                                    : Colors.grey, // ✨ Disabled trailing
                              ),
                              const ReusableSizedBox(width: 10),

                              // --- Clear button (only if something is selected and showClearButton true)
                              if (hasSelection &&
                                  trailing != 'Tap to Select' &&
                                  showClearButton)
                              // Use InkWell so tap is consumed and parent InkWell won't trigger
                                InkWell(
                                  onTap: enabled && onUnselect != null
                                      ? () {
                                    // prevent parent onTap: InkWell in child will win the gesture
                                    onUnselect!();
                                  }
                                      : null,
                                  borderRadius: BorderRadius.circular(6),
                                  child: ReusableContainer(
                                    color: AppColors.backgroundColorGrey,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                    borderWidth: 0.5,
                                    borderColor: AppColors.appGreyColor2,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 4),
                                    child: Row(
                                      children: const [
                                        Icon(
                                          Icons.close,
                                          size: 12,
                                          color: AppColors.appMainColor,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    /// Navigation Button  / Add Button
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (addButton)
                          Row(
                            children: [
                              ReusableContainer(
                                height: 24,
                                width: 24,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.appMainColor,
                                ),
                                child: const Center(
                                  child: Icon(Icons.add, color: Colors.white),
                                ),
                              ),
                              const ReusableSizedBox(width: 10),
                            ],
                          ),
                        navigationButton
                            ? Icon(
                          Icons.keyboard_arrow_down,
                          color: enabled
                              ? const Color.fromRGBO(86, 86, 86, 1)
                              : Colors.grey, // ✨ Disabled icon
                        )
                            : const SizedBox(),
                      ],
                    ),
                  ],
                ),
              ),

              /// Divider or Error underline
              if (hasError)
                Divider(
                  color: Colors.red.shade700,
                  thickness: 1,
                  height: 1,
                )
              else if (divider)
                const PayzoDivider()
              else
                const SizedBox(),

              /// Error Text
              if (hasError) const ReusableSizedBox(height: 2),
              if (hasError)
                Padding(
                  padding: const EdgeInsets.only(left: 0),
                  child: ReusableText(
                    overflow: TextOverflow.ellipsis,
                    text: errorText!,
                    fontSize: 12,
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w400,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

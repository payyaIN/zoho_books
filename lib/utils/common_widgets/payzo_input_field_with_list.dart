import 'package:flutter/services.dart';
import 'package:payzo_books/import_data.dart';
class PayzoInputFieldWithList extends StatefulWidget {
  final String label;
  final String? errorText;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final TextInputType? keyboardType;
  final String? initialValue;
  final Widget? leading;
  final String? countryFlagCode;
  final bool required;
  final bool enabled;
  final bool? isPrefixText;
  final String? prefixText;
  final List<TextInputFormatter>? inputFormatters;

  /// Dropdown-specific
  final List<String> items;
  final String? selectedValue;
  final void Function(String selected)? onItemSelected;
  final String bottomSheetTitle;
  final bool showDividerInSheet;

  const PayzoInputFieldWithList({
    super.key,
    required this.label,
    required this.items,
    this.required = false,
    this.controller,
    this.onChanged,
    this.errorText,
    this.keyboardType,
    this.initialValue,
    this.leading,
    this.countryFlagCode,
    this.inputFormatters,
    this.enabled = true,
    this.isPrefixText,
    this.prefixText,
    this.selectedValue,
    this.onItemSelected,
    this.bottomSheetTitle = 'Select',
    this.showDividerInSheet = true,
  });

  @override
  State<PayzoInputFieldWithList> createState() =>
      _PayzoInputFieldWithListState();
}

class _PayzoInputFieldWithListState extends State<PayzoInputFieldWithList> {
  late final TextEditingController _internalController;
  TextEditingController get _controller =>
      widget.controller ?? _internalController;

  @override
  void initState() {
    super.initState();
    _internalController = TextEditingController(
        text: widget.controller == null
            ? (widget.initialValue ?? widget.selectedValue ?? '')
            : widget.controller!.text);
    // If a controller is provided, listen to it and keep state in sync (optional)
    widget.controller?.addListener(_handleExternalControllerChanged);
    // If initial selectedValue provided and no controller, set it
    if (widget.controller == null && widget.selectedValue != null) {
      _internalController.text = widget.selectedValue!;
    }
  }

  @override
  void didUpdateWidget(covariant PayzoInputFieldWithList oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If external controller changed, update listeners
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_handleExternalControllerChanged);
      widget.controller?.addListener(_handleExternalControllerChanged);
      if (widget.controller != null) {
        _internalController.text = widget.controller!.text;
      }
    }
    // If selectedValue changed from parent, update text
    if (widget.selectedValue != null &&
        widget.selectedValue != oldWidget.selectedValue) {
      (_controller).text = widget.selectedValue!;
    }
  }

  void _handleExternalControllerChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleExternalControllerChanged);
    if (widget.controller == null) {
      _internalController.dispose();
    }
    super.dispose();
  }

  Widget? _buildLeadingWidget() {
    if (widget.leading != null) return widget.leading;

    if (widget.countryFlagCode != null) {
      return GestureDetector(
        onTap: () {
          // If you want to allow countryTap you can expose a callback to widget
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: Image.network(
                'https://flagcdn.com/48x36/${widget.countryFlagCode!.toLowerCase()}.png',
                width: 30,
                height: 20,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 8),
            const Text('|',
                style:
                TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(width: 8),
          ],
        ),
      );
    }

    return null;
  }

  Future<void> _openSelectionSheet() async {
    if (!widget.enabled) return;

    final selected = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding:
            EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Optional header
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ReusableText(
                        text: widget.bottomSheetTitle,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Flexible(
                  // Use Flexible so sheet can grow but still be scrollable
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: widget.items.length,
                    separatorBuilder: (_, __) =>
                    widget.showDividerInSheet ? const Divider() : const SizedBox(),
                    itemBuilder: (context, index) {
                      final item = widget.items[index];
                      return PayzoBottomsheetNavigator(
                        title: item,
                        trailing: '',
                        onTap: () {
                          Navigator.of(context).pop(item);
                        },
                        addButton: false,
                        navigationButton: false,
                        isPayzoColor: false,
                        required: false,
                        divider: false,
                        enabled: true,
                        errorText: null,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (selected != null) {
      // update input and notify
      setState(() {
        _controller.text = selected;
      });
      if (widget.onItemSelected != null) widget.onItemSelected!(selected);
      if (widget.onChanged != null) widget.onChanged!(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final leading = _buildLeadingWidget();

    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: TextFormField(
        readOnly: true,
        enabled: widget.enabled,
        textAlignVertical: TextAlignVertical.center,
        controller: _controller,
        keyboardType: widget.keyboardType ?? TextInputType.text,
        onTap: _openSelectionSheet,
        inputFormatters: widget.inputFormatters,
        style: const TextStyle(
          fontFamily: 'SF Pro Display',
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: Color.fromRGBO(51, 51, 51, 1),
        ),
        decoration: InputDecoration(
          label: RichText(
            text: TextSpan(
              text: widget.label,
              style: const TextStyle(
                fontFamily: 'SF Pro Display',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(51, 51, 51, 1),
              ),
              children: widget.required
                  ? const [
                TextSpan(
                  text: ' *',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ]
                  : [],
            ),
          ),
          labelStyle: const TextStyle(
            fontFamily: 'SF Pro Display',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color.fromRGBO(51, 51, 51, 1),
          ),
          prefixText: widget.isPrefixText == true ? widget.prefixText : null,
          prefixStyle: const TextStyle(
            fontFamily: 'SF Pro Display',
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Color.fromRGBO(51, 51, 51, 1),
          ),
          errorText: widget.errorText?.isNotEmpty == true ? widget.errorText : null,
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color.fromRGBO(228, 228, 228, 1)),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.appMainColor, width: 2),
          ),
          floatingLabelStyle: const TextStyle(color: AppColors.appMainColor),
          prefixIcon: leading,
          prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
          // suffix icon: down arrow
          suffixIcon: IconButton(
            onPressed: widget.enabled ? _openSelectionSheet : null,
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: widget.enabled
                  ? const Color.fromRGBO(86, 86, 86, 1)
                  : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}

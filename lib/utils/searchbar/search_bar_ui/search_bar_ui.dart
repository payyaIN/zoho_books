// import 'package:payzo_books/import_data.dart';
// import 'package:payzo_books/utils/searchbar/provider/search_bar_provider.dart';

// class SearchBarUi extends ConsumerStatefulWidget {
//   final WidgetRef ref;
//   TextEditingController controller;
//   Function(String)? onChanged;
//   final VoidCallback? onClear;
//   String hintText;

//   SearchBarUi(
//       {Key? key,
//       required this.ref,
//       required this.controller,
//       required this.onChanged,
//       required this.onClear,
//       required this.hintText})
//       : super(key: key);

//   @override
//   ConsumerState<SearchBarUi> createState() => _SearchBarUiState();
// }

// class _SearchBarUiState extends ConsumerState<SearchBarUi> {
//   late FocusNode focusNode;

//   @override
//   void initState() {
//     super.initState();
//     focusNode = FocusNode();
//     if (widget.controller.text.isEmpty) {
//       print("Initializing search controller");
//     }
//   }

//   @override
//   void dispose() {
//     focusNode.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var width = MediaQuery.of(context).size.width;
//     final searchState = ref.watch(searchProvider);
//     print(
//         "Building SearchBarUi, current text: '${widget.controller.text}', search state: '${searchState.query}'");

//     return SizedBox(
//       width: 395,
//       height: 45,
//       child: TextField(
//         controller: widget.controller,
//         focusNode: focusNode,
//         decoration: InputDecoration(
//           hintText: widget.hintText,
//           hintStyle: TextStyle(
//               fontFamily: 'SF Pro Display',
//               fontSize: 14,
//               fontWeight: FontWeight.w400),
//           prefixIcon: const Icon(Icons.search),
//           suffixIcon:
//               widget.controller.text.isNotEmpty || searchState.query.isNotEmpty
//                   ? IconButton(
//                       icon: const Icon(Icons.clear),
//                       onPressed: () {
//                         print("Clear button pressed");
//                         if (widget.onClear != null) {
//                           widget.onClear!();
//                         }
//                       },
//                     )
//                   : null,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10.0),
//           ),
//         ),
//         onChanged: (value) {
//           print("TextField onChanged: '$value'");
//           if (widget.onChanged != null) {
//             widget.onChanged!(value);
//           }
//         },
//       ),
//     );
//   }
// }

import 'dart:async';
import 'package:payzo_books/import_data.dart';
import 'dart:developer' as developer;

class SearchBarUi extends ConsumerStatefulWidget {
  final WidgetRef ref;
  final TextEditingController controller;
  final Function(String)? onChanged;
  final VoidCallback? onClear;
  final String hintText;
  final FocusNode? focusNode;
  final Duration debounceTime;

  const SearchBarUi({
    Key? key,
    required this.ref,
    required this.controller,
    required this.onChanged,
    required this.onClear,
    required this.hintText,
    this.focusNode,
    this.debounceTime = const Duration(milliseconds: 300),
  }) : super(key: key);

  @override
  ConsumerState<SearchBarUi> createState() => _SearchBarUiState();
}

class _SearchBarUiState extends ConsumerState<SearchBarUi> {
  late FocusNode _focusNode;
  bool _hasFocus = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);

    if (widget.controller.text.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (widget.onChanged != null) {
          widget.onChanged!(widget.controller.text);
        }
      });
    }
  }

  void _onFocusChange() {
    setState(() {
      _hasFocus = _focusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    if (widget.focusNode == null) {
      _focusNode.removeListener(_onFocusChange);
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }

    _debounce = Timer(widget.debounceTime, () {
      developer.log("Search debounce completed for: '$value'",
          name: 'SearchBar');
      if (widget.onChanged != null) {
        widget.onChanged!(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    developer.log(
      "Building SearchBarUi, text: '${widget.controller.text}'",
      name: 'SearchBar',
    );

    return SizedBox(
      width: 395,
      height: 45,
      child: TextField(
        controller: widget.controller,
        focusNode: _focusNode,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(
            fontFamily: 'SF Pro Display',
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: const Icon(Icons.search),
          suffixIcon: widget.controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    widget.controller.clear();
                    if (widget.onClear != null) {
                      widget.onClear!();
                    }
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color: AppColors.appMainColor,
              width: 2.0,
            ),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
        ),
        onChanged: _onSearchChanged,
        textInputAction: TextInputAction.search,
        onSubmitted: (value) {
          if (widget.onChanged != null) {
            widget.onChanged!(value);
          }
          FocusScope.of(context).unfocus();
        },
      ),
    );
  }
}

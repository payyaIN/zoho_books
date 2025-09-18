import 'package:payzo_books/import_data.dart';

class ReusableCountryBottomSheet extends StatefulWidget {
  final String title;
  final List<String> items;
  final void Function(String selected) onSelect;

  const ReusableCountryBottomSheet({
    super.key,
    required this.title,
    required this.items,
    required this.onSelect,
  });

  @override
  State<ReusableCountryBottomSheet> createState() => _ReusableCountryBottomSheetState();
}

class _ReusableCountryBottomSheetState extends State<ReusableCountryBottomSheet> {
  late List<String> filteredItems;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredItems = widget.items;
    _searchController.addListener(_filterList);
  }

  void _filterList() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredItems = widget.items
          .where((item) => item.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScalingFactor(
      child: DraggableScrollableSheet(
        initialChildSize: 0.65,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Column(
              children: [
                Stack(
                  children: [
                    ReusableContainer(
                      height: 50,
                    ),
                    Center(
                      child: ReusableText(
                        text: widget.title,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Positioned(
                      top: -10,
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    prefixIcon: const Icon(Icons.search, size: 20),
                    hintText: "Search",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Color.fromRGBO(238, 238, 238, 1)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: FormContainer(
                    height: 2,
                    child: ListView.separated(
                      controller: scrollController,
                      itemCount: filteredItems.length,
                      itemBuilder: (_, index) => SizedBox(
                        height: 50,
                        child: ListTile(
                          dense: true,
                          title: Text(filteredItems[index], style: const TextStyle(fontSize: 14)),
                          onTap: () {
                            widget.onSelect(filteredItems[index]);
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      separatorBuilder: (_, __) => const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: PayzoDivider(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

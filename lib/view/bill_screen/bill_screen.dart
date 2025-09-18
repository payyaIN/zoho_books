import 'package:payzo_books/view/bill_screen/components/bill_app_bar.dart';
import 'package:payzo_books/view/bill_screen/components/bill_body_data.dart';
import 'package:payzo_books/view/bill_screen/components/bill_checkbox_btn.dart';
import 'package:payzo_books/view/bill_screen/components/bill_fab_btn.dart';
import 'package:payzo_books/view/bill_screen/components/bill_search_data.dart';

import '../../import_data.dart';

class BillScreen extends ConsumerStatefulWidget {
  const BillScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BillScreenState();
}

class _BillScreenState extends ConsumerState<BillScreen> {
  @override
  Widget build(BuildContext context) {
    return ScalingFactor(
      child: Scaffold(
        appBar: billAppBar(
          context: context,
          ref: ref,
        ),
        body: Stack(
          children: [
            Column(
              children: [Container(), BillSearchData(), BillBodyData()],
            ),
            BillCheckBoxSection(),
          ],
        ),
        floatingActionButton: billFABBtn(
          context: context,
          ref: ref,
        ),
      ),
    );
  }
}

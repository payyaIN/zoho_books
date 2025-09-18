import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/expenses/repo/expense_details_repo.dart';
import 'package:payzo_books/view/expenses/widgets/details/expense_detail_summary_widget.dart';
import 'package:payzo_books/view/expenses/widgets/details/expense_details_header_data.dart';
import 'package:payzo_books/view/expenses/widgets/details/expense_journal.dart';
import 'package:payzo_books/data/repository/journal_entries/journal_entries_api.dart';
import 'package:payzo_books/view/notification_details/components/other_widgts.dart';

class ExpenseDetailPage extends ConsumerStatefulWidget {
  final int? expenseId;
  const ExpenseDetailPage({super.key, this.expenseId});

  @override
  ConsumerState<ExpenseDetailPage> createState() => _ExpenseDetailPageState();
}

class _ExpenseDetailPageState extends ConsumerState<ExpenseDetailPage> {
  late final int id;

  @override
  void initState() {
    super.initState();
    id = widget.expenseId ?? 1;

    Future.microtask(() async {
      await ref.refresh(getExpenseDetailsProvider(id).future);
      await ref.refresh(journalEntriesProvider(id).future);
    });
  }

  @override
  Widget build(BuildContext context) {
    final expenseAsync = ref.watch(getExpenseDetailsProvider(id));
    final journalAsync = ref.watch(journalEntriesProvider(id));

    return ScalingFactor(
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBgColor,
        appBar: reusableAppBar(
          title: "Expense Details",
          context: context,
          showBackButton: true,
        ),
        body: expenseAsync.when(
          data: (_) {
            return RefreshIndicator(
              onRefresh: () async {
                await ref.refresh(getExpenseDetailsProvider(id).future);
                await ref.refresh(journalEntriesProvider(id).future);
              },
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🔁 Replaced static header with dynamic widget
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: ExpenseDetailHeaderData(expenseId: id),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16),
                      child: Column(
                        children: [
                          infoSection("Expense Information", [
                            infoRow("Date", formatDateFn(
                                DateTime.tryParse(
                                    ref.read(getExpenseDetailsProvider(id)).value?.response?.date ?? '') ??
                                    DateTime.now())),
                            infoRow("Branch",
                                ref.read(getExpenseDetailsProvider(id)).value?.response?.branch ?? ''),
                            infoRow("Expense Account",
                                ref.read(getExpenseDetailsProvider(id)).value?.response?.expenseAccount ?? ''),
                            infoRow("Reference",
                                ref.read(getExpenseDetailsProvider(id)).value?.response?.reference?.toString() ??
                                    'NA'),
                            infoRow("Vendor",
                                ref.read(getExpenseDetailsProvider(id)).value?.response?.vendor ?? 'NA'),
                            infoRow("Paid Through",
                                ref.read(getExpenseDetailsProvider(id)).value?.response?.paidThrough ?? 'NA'),
                            infoRow("Customer",
                                ref.read(getExpenseDetailsProvider(id)).value?.response?.customer ?? 'NA'),
                            infoRow("Status",
                                ref.read(getExpenseDetailsProvider(id)).value?.response?.status ?? 'NA'),
                            infoRow("Currency",
                                ref.read(getExpenseDetailsProvider(id)).value?.response?.currency ?? 'NA'),
                          ]),
                          const SizedBox(height: 16),
                          ExpenseDetailSummaryData(expenseId: id),
                          const SizedBox(height: 16),
                          ExpenseJournalEntries(
                            journalEntriesAsync: journalAsync,
                            currency: ref
                                .read(getExpenseDetailsProvider(id))
                                .value
                                ?.response
                                ?.currency ??
                                '',
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 50),
                  ],
                ),
              ),
            );
          },
          error: (e, _) => Center(
            child: Text("Error: $e", style: const TextStyle(color: Colors.red)),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }

  Widget infoSection(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const Divider(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(label,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
                overflow: TextOverflow.ellipsis),
          ),
          Expanded(
            child: Text(value,
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 14),
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}

import 'package:payzo_books/data/models/jounrnal_entries_model/journal_entries_model.dart';
import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/notification_details/components/other_widgts.dart';

class ExpenseJournalEntries extends StatelessWidget {
  final AsyncValue<GetJournalEntriesModel> journalEntriesAsync;
  final String currency;

  const ExpenseJournalEntries({
    Key? key,
    required this.journalEntriesAsync,
    required this.currency,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Journal Entries",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: AppColors.loginTextColor,
            ),
          ),
          Divider(height: 16),
          journalEntriesAsync.when(
            data: (journalEntriesModel) {
              if (journalEntriesModel.response.isEmpty) {
                return emptyJournalEntries();
              }

              double totalDebitAmount = journalEntriesModel.response
                  .fold(0.0, (sum, entry) => sum + entry.debitAmount);
              double totalCreditAmount = journalEntriesModel.response
                  .fold(0.0, (sum, entry) => sum + entry.creditAmount);

              return Column(
                children: [
                  GapSpace.height20,
                  Row(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Amount is displayed in your base currency",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: AppColors.loginTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  GapSpace.height30,
                  ...journalEntriesModel.response.map((entry) {
                    return Column(
                      children: [
                        buildJournalEntryCard(
                          accountName: entry.accountName,
                          branchName: entry.branchName,
                          debitAmount:
                          formatCurrency(entry.debitAmount, currency),
                          creditAmount:
                          formatCurrency(entry.creditAmount, currency),
                        ),
                        SizedBox(height: 12),
                      ],
                    );
                  }).toList(),
                  journalTotal(
                    totalDebit: formatCurrency(totalDebitAmount, currency),
                    totalCredit: formatCurrency(totalCreditAmount, currency),
                  ),
                ],
              );
            },
            loading: () => Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (error, stackTrace) => Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  "Error loading journal entries",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildJournalEntryCard({
    required String accountName,
    required String branchName,
    required String debitAmount,
    required String creditAmount,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Account", style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                    SizedBox(height: 4),
                    Text(accountName, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.loginTextColor)),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Branch", style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                    SizedBox(height: 4),
                    Text(branchName, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: AppColors.loginTextColor)),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Divider(height: 1, thickness: 0.5),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Debit", style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                    SizedBox(height: 4),
                    Text(debitAmount, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: debitAmount != "0.00" ? Colors.red.shade700 : Colors.grey.shade500)),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Credit", style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                    SizedBox(height: 4),
                    Text(creditAmount, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: creditAmount != "0.00" ? Colors.green.shade700 : Colors.grey.shade500)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget journalTotal({
    required String totalDebit,
    required String totalCredit,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Text("Totals", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.loginTextColor)),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Total Debit", style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
                    SizedBox(height: 4),
                    Text(totalDebit, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: AppColors.loginTextColor)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("Total Credit", style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
                    SizedBox(height: 4),
                    Text(totalCredit, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: AppColors.loginTextColor)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget emptyJournalEntries() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Text(
          "No journal entries available",
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}

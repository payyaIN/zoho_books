import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/utils/common_widgets/single_custom_btn.dart';

bulkApproveExpensesAlert(
    BuildContext context,
    String title,
    String subTitle,
    String content,
    VoidCallback onApprove,
    ) async {
  return showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      actionsAlignment: MainAxisAlignment.start,
      title: ReusableText(
        text: title,
        fontSize: 18,
        fontFamily: 'SF Pro Display',
        fontWeight: FontWeight.w700,
        color: AppColors.appMainColor,
      ),
      content: SizedBox(
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ReusableText(
              text: subTitle,
              fontFamily: 'SF Pro Display',
            ),
            ...List.generate(
              5,
                  (_) => const ReusableText(
                text: '•',
                fontFamily: 'SF Pro Display',
              ),
            ),
            ReusableText(
              text: content,
              fontSize: 14,
              fontFamily: 'SF Pro Display',
              fontWeight: FontWeight.w400,
            ),
          ],
        ),
      ),
      actions: [
        PayzoFormSubmitTwoButtons(
          cancelText: 'No',
          saveText: 'Yes',
          cancelOnPressed: () {
            Navigator.pop(context);
          },
          saveOnPressed: () {
            Navigator.pop(context);
            bulkApproveExpensesResultAlert(context, onApprove);
          },
        )
      ],
    ),
  );
}

bulkApproveExpensesResultAlert(
    BuildContext context, VoidCallback onApproveResult) async {
  return showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      actionsAlignment: MainAxisAlignment.start,
      title: const ReusableText(
        text: 'Bulk Approval Result',
        fontSize: 18,
        fontFamily: 'SF Pro Display',
        fontWeight: FontWeight.w700,
        color: AppColors.appMainColor,
      ),
      content: SizedBox(
        height: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            ReusableText(
              text: 'Total Expense(s) For Approval:',
              fontFamily: 'SF Pro Display',
              fontWeight: FontWeight.w600,
            ),
            ReusableText(
              text: 'Number of Expense(s) Approved:',
              fontFamily: 'SF Pro Display',
              fontWeight: FontWeight.w600,
            ),
            ReusableText(
              text: 'Number of Expense(s) Failed:',
              fontSize: 14,
              fontFamily: 'SF Pro Display',
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ),
      actions: [
        singleButton(
          btnText: 'OK',
          onPress: () {
            Navigator.pop(context);
            onApproveResult();
          },
          height: 50,
          width: 70,
        )
      ],
    ),
  );
}

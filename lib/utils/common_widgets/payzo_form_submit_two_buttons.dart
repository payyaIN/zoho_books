import 'package:payzo_books/utils/common_widgets/payzo_progress.dart';

import '../../import_data.dart';

class PayzoFormSubmitTwoButtons extends ConsumerWidget {
  final String cancelText;
  final String saveText;
  final bool? safeArea;
  final VoidCallback cancelOnPressed;
  final VoidCallback saveOnPressed;

  const PayzoFormSubmitTwoButtons(
      {super.key,
      this.safeArea,
      required this.cancelText,
      required this.saveText,
      required this.cancelOnPressed,
      required this.saveOnPressed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isLoading = ref.watch(isLoadingProvider);
    return ReusablePadding(
      padding: EdgeInsets.only(
          left: 22, right: 22, bottom: safeArea == true ? 60 : 15),
      child: Row(
        children: [
          Expanded(
            child: ReusableSizedBox(
              height: 50,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)))),
                onPressed: cancelOnPressed,
                child: ReusableText(
                  text: cancelText,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: Color.fromRGBO(33, 33, 33, 1),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: 50,
              width: 160,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.appMainColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)))),
                onPressed: saveOnPressed,
                child: ReusableText(
                  text: saveText,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: Color.fromRGBO(247, 247, 247, 1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

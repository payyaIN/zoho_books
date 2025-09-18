import 'package:intl/intl.dart';
import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/main_screen/notifiers/dashboard_notifier.dart';

class PayxoHomeAppBarCardText extends ConsumerWidget {
  const PayxoHomeAppBarCardText({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(getTotalRecievablesAmount);
    final payableData = ref.watch(getTotalPayableAmount);
    return ReusablePadding(
      padding: const EdgeInsets.only(top: 15, bottom: 15, left: 25),
      child: ReusableSizedBox(
        width: 167,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ReusableSizedBox(
              width: double.infinity,
              height: 49,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ReusableSizedBox(
                    width: double.infinity,
                    child: Text(
                      'Total Receivables',
                      style: TextStyle(
                        color: Color(0xFFDFDFDF),
                        fontSize: 12,
                        fontFamily: 'SF Pro Display',
                        fontWeight: FontWeight.w400,
                        height: 1.52,
                      ),
                    ),
                  ),
                  const ReusableSizedBox(height: 10),
                  ReusableSizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        data.when(
                            data: (data) {
                              final totalAmount = data.response?.total ?? 0.0;
                              final formattedTotal = NumberFormat.currency(
                                locale: 'en_SA', // Saudi Arabia locale
                                symbol: 'SAR ',
                                decimalDigits: 2,
                              ).format(totalAmount);

                              return Text(
                                formattedTotal,
                                style: TextStyle(
                                  color: Color(0xFFF7F7F7),
                                  fontSize: 18,
                                  fontFamily: 'SF Pro Display',
                                  fontWeight: FontWeight.w700,
                                  height: 1.01,
                                ),
                              );
                            },
                            error: (err, _) {
                              print(_);
                              print('error is $err');
                              return Text(
                                'Data not available',
                                style: TextStyle(
                                  color: Color(0xFFF7F7F7),
                                  fontSize: 18,
                                  fontFamily: 'SF Pro Display',
                                  fontWeight: FontWeight.w700,
                                  height: 1.01,
                                ),
                              );;
                            },
                            loading: () => ReusableSizedBox(
                                width: 10,
                                height: 10,
                                child: CircularProgressIndicator())),
                        const ReusableSizedBox(width: 2),
                        // ReusableSizedBox(
                        //   width: 20,
                        //   height: 20,
                        //   child: SvgPicture.asset(
                        //     'assets/chevron-down.svg',
                        //     fit: BoxFit.cover,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const ReusableSizedBox(height: 25),
            ReusableSizedBox(
              height: 49,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: double.infinity,
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        'Total Payables',
                        style: TextStyle(
                          color: Color(0xFFDFDFDF),
                          fontSize: 12,
                          fontFamily: 'SF Pro Display',
                          fontWeight: FontWeight.w400,
                          height: 1.52,
                        ),
                      ),
                    ),
                  ),
                  const ReusableSizedBox(height: 10),
                  ReusableSizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        payableData.when(
                            data: (data) {
                              final totalAmount = data.response.total;
                              final formattedTotal = NumberFormat.currency(
                                locale: 'en_SA', // Saudi Arabia locale
                                symbol: 'SAR ',
                                decimalDigits: 2,
                              ).format(totalAmount);
                              return Text(
                                formattedTotal,
                                style: TextStyle(
                                  color: Color(0xFFF7F7F7),
                                  fontSize: 18,
                                  fontFamily: 'SF Pro Display',
                                  fontWeight: FontWeight.w700,
                                  height: 1.01,
                                ),
                              );
                            },
                            error: (err, _) {
                              print(_);
                              print('error is $err');
                              return Text(
                                'Data not available',
                                style: TextStyle(
                                  color: Color(0xFFF7F7F7),
                                  fontSize: 18,
                                  fontFamily: 'SF Pro Display',
                                  fontWeight: FontWeight.w700,
                                  height: 1.01,
                                ),
                              );
                            },
                            loading: () => ReusableSizedBox(
                                width: 10,
                                height: 10,
                                child: CircularProgressIndicator())),
                        const SizedBox(width: 2),

                        // ReusableSizedBox(
                        //   width: 20,
                        //   height: 20,
                        //   child: SvgPicture.asset(
                        //     'assets/chevron-down.svg',
                        //     fit: BoxFit.cover,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

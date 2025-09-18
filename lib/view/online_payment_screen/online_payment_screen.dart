import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/utils/common_widgets/single_custom_btn.dart';

final paymentGatewaysProvider =
    StateNotifierProvider<PaymentGatewaysNotifier, List<PaymentGateway>>((ref) {
  return PaymentGatewaysNotifier();
});

class PaymentGateway {
  final String name;
  final String description;
  bool isSetUp;

  PaymentGateway(
      {required this.name, required this.description, this.isSetUp = false});
}

class PaymentGatewaysNotifier extends StateNotifier<List<PaymentGateway>> {
  PaymentGatewaysNotifier()
      : super([
          PaymentGateway(
              name: 'Razorpay',
              description:
                  'Razorpay is an Indian payment gateway which allows your customer to pay via cards, netbanking and wallets.'),
          PaymentGateway(
              name: 'PayPal',
              description:
                  'Razorpay is an Indian payment gateway which allows your customer to pay via cards, netbanking and wallets.'),
          PaymentGateway(
              name: 'Verifone',
              description:
                  'Razorpay is an Indian payment gateway which allows your customer to pay via cards, netbanking and wallets.')
        ]);

  void toggleSetup(String name) {
    state = [
      for (final gateway in state)
        if (gateway.name == name)
          PaymentGateway(
              name: gateway.name,
              description: gateway.description,
              isSetUp: !gateway.isSetUp)
        else
          gateway
    ];
  }
}

class OnlinePaymentsScreen extends ConsumerWidget {
  const OnlinePaymentsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: reusableAppBar(
            title: AppText.onlinePaymnts,
            showBackButton: true,
            context: context),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 25, right: 25, top: 30),
            child: Column(
              children: [
                onlinePayementBody(
                    isRightTextNeeded: true,
                    paymntImg: AppImages.razorpay,
                    rightUnderLineText: AppText.razrpayCntnt,
                    desTxt: AppText.razorpayDisc,
                    onPress: () {}),
                onlinePayementBody(
                    isRightTextNeeded: false,
                    paymntImg: AppImages.paypal,
                    rightUnderLineText: AppText.razrpayCntnt,
                    desTxt: AppText.razorpayDisc,
                    onPress: () {}),
                onlinePayementBody(
                    isRightTextNeeded: false,
                    paymntImg: AppImages.verifone,
                    rightUnderLineText: AppText.razrpayCntnt,
                    desTxt: AppText.razorpayDisc,
                    onPress: () {
                      //     ref
                      // .read(paymentGatewaysProvider.notifier)
                      // .toggleSetup(gateway.name);
                    })
              ],
            ),
          ),
        ));
  }

  Widget onlinePayementBody({
    required String paymntImg,
    required String rightUnderLineText,
    required String desTxt,
    required bool isRightTextNeeded,
    required VoidCallback onPress,
  }) {
    return Column(
      children: [
        ReusableContainer(
          height: 187,
          width: 340,
          borderColor: AppColors.boxBorder,
          borderRadius: BorderRadius.all(Radius.circular(6)),
          borderWidth: 1,
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPictureWidget(image: paymntImg, height: 23, width: 109),
                    isRightTextNeeded == true
                        ? ReusableText(
                            text: rightUnderLineText,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'SF Pro Display',
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.appMainColor,
                            color: AppColors.appMainColor)
                        : SizedBox()
                  ],
                ),
                GapSpace.height10,
                Divider(
                  color: AppColors.borderColor,
                  indent: 10,
                  endIndent: 10,
                  thickness: 1,
                ),
                ReusableText(
                  text: desTxt,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'SF Pro Display',
                  fontSize: 14,
                  color: AppColors.loginTextColor,
                ),
                GapSpace.height10,
                singleButton(
                    btnText: AppText.setup,
                    onPress: onPress,
                    height: 27,
                    width: 100),
                GapSpace.height10,
              ],
            ),
          ),
        ),
        GapSpace.height20
      ],
    );
  }
}

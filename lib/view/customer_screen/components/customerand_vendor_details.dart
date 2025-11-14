import 'package:payzo_books/data/models/customer_model/customer_model.dart';
import 'package:payzo_books/import_data.dart';

Widget customerAndVendorDetails({
  required String customerImg,
  required String name,
  required String email,
  required String stateValue,
  required String cityValue,
}) {
  return
      // name.isNotEmpty && email.isNotEmpty
      //     ?
      Column(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          width: double.infinity,
          height: 129,
          padding: const EdgeInsets.all(10),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1,
                strokeAlign: BorderSide.strokeAlignCenter,
                color: const Color(0xFFEEEEEE),
              ),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(),
                // padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                child: Row(
                  // mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(217, 217, 217, 1),
                          image: DecorationImage(
                              image: AssetImage('assets/$customerImg'),
                              fit: BoxFit.fitWidth),
                          borderRadius:
                              BorderRadius.all(Radius.elliptical(36, 36)),
                        )),
                    SizedBox(width: 10),
                    Container(
                      decoration: BoxDecoration(),
                      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(),
                            padding: EdgeInsets.symmetric(
                                horizontal: 0, vertical: 0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                ReusableText(
                                    text: name,
                                    textAlign: TextAlign.left,
                                    color: Color.fromRGBO(33, 33, 33, 1),
                                    fontFamily: 'SF Pro Display',
                                    fontSize: 16,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.w500,
                                    height: 1),
                                SizedBox(height: 5),
                                ReusableText(
                                    text: email,
                                    textAlign: TextAlign.left,
                                    color: Color.fromRGBO(51, 51, 51, 1),
                                    fontFamily: 'SF Pro Display',
                                    fontSize: 14,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.normal,
                                    height: 1),
                              ],
                            ),
                          ),
                          SizedBox(height: 15),
                          Container(
                              width: 320,
                              height: 53,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(4),
                                  topRight: Radius.circular(4),
                                  bottomLeft: Radius.circular(4),
                                  bottomRight: Radius.circular(4),
                                ),
                                color: Color.fromRGBO(245, 245, 245, 1),
                                border: Border.all(
                                  color: Color.fromRGBO(238, 238, 238, 1),
                                  width: 1,
                                ),
                              ),
                              child: Stack(children: <Widget>[
                                Positioned(
                                    top: 8,
                                    left: 10,
                                    child: Container(
                                      decoration: BoxDecoration(),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 0, vertical: 0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          ReusableText(
                                              text: AppText.state,
                                              textAlign: TextAlign.left,
                                              color:
                                                  Color.fromRGBO(51, 51, 51, 1),
                                              fontFamily: 'SF Pro Display',
                                              fontSize: 12,
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.normal,
                                              height: 1),
                                          SizedBox(height: 6),
                                          ReusableText(
                                            text: stateValue,
                                            textAlign: TextAlign.left,
                                            color: const Color(0xFF212121),
                                            fontSize: 14,
                                            fontFamily: 'SF Pro Display',
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ],
                                      ),
                                    )),
                                Positioned(
                                    top: 8,
                                    right: 10,
                                    child: Container(
                                      decoration: BoxDecoration(),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          ReusableText(
                                              text: AppText.city,
                                              textAlign: TextAlign.left,
                                              color:
                                                  Color.fromRGBO(51, 51, 51, 1),
                                              fontFamily: 'SF Pro Display',
                                              fontSize: 12,
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.normal,
                                              height: 1),
                                          SizedBox(height: 6),
                                          ReusableText(
                                            text: cityValue,
                                            textAlign: TextAlign.left,
                                            color: const Color(0xFF212121),
                                            fontSize: 14,
                                            fontFamily: 'SF Pro Display',
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ],
                                      ),
                                    )),
                              ])),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      GapSpace.height10
    ],
  );
  // : SizedBox();
}

Widget primaryContactWidget(
  PrimaryContact contact,
  String companyName,
  PhoneLauncher launcher,
  String customerEmail,
  String customerContact,
  String countryCode,
  VoidCallback callOnTap,
  VoidCallback mailOnTap,
  VoidCallback msgOnTap,
) {
  final fullName =
      "${contact.salutation ?? ''} ${contact.firstName} ${contact.lastName}"
          .trim();

  return Row(
    crossAxisAlignment: CrossAxisAlignment.end,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          textRowData(
            leftText: 'Full Name : ',
            rightText: fullName,
          ),
          textRowData(
            leftText: 'Company : ',
            rightText: companyName,
          ),
          textRowData(
            leftText: 'Email : ',
            rightText: customerEmail,
          ),
          textRowData(
            leftText: 'Phone : ',
            rightText: '$countryCode $customerContact',
          ),
        ],
      ),
      boxIconWithOutLabel(
          callOnTap: callOnTap, mailOnTap: mailOnTap, msgOnTap: msgOnTap)
    ],
  );
}

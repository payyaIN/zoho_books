import 'package:payzo_books/import_data.dart';
class PendingRequestListTile extends StatelessWidget {
  final String companyName;
  final String companyLogo;
  final String subtitleText;

  const PendingRequestListTile(
      {super.key,
      required this.companyName,
      required this.companyLogo,
      required this.subtitleText});

  @override
  Widget build(BuildContext context) {
    return ReusablePadding(
      padding: const EdgeInsets.only(top: 10,bottom: 10),

      child: SizedBox(
        height: 50,
        child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ReusableSizedBox(
                child: ReusableRow(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      clipBehavior: Clip.antiAlias,
                      decoration: ShapeDecoration(
                        image: DecorationImage(
                          image: AssetImage(companyLogo),
                          fit: BoxFit.fill,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                    const ReusableSizedBox(width: 10),
                     ReusableSizedBox(
                      width: 117,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ReusableSizedBox(
                            width: double.infinity,
                            child: ReusableSizedBox(
                              width: double.infinity,
                              child: Text(
                                companyName,
                                style: const TextStyle(
                                  color: Color(0xFF212121),
                                  fontSize: 14,
                                  fontFamily: 'SF Pro Display',
                                  fontWeight: FontWeight.w500,
                                  height: 1.30,
                                ),
                              ),
                            ),
                          ),
                          const ReusableSizedBox(height: 2),
                          ReusableSizedBox(
                            width: double.infinity,
                            height: 18,
                            child: ReusableSizedBox(
                              width: double.infinity,
                              height: 18,
                              child: Text(
                                subtitleText,
                                style: const TextStyle(
                                  color: Color(0xFF777777),
                                  fontSize: 12,
                                  fontFamily: 'SF Pro Display',
                                  fontWeight: FontWeight.w400,
                                  height: 1.30,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              const ReusableSizedBox(
                child: ReusableRow(children: <Widget>[
                  SvgPictureWIidget(
                      image:
                          'assets/Frame 21618.svg',
                      height: 28,
                      width: 28),
                  ReusableSizedBox(
                    width: 15,
                  ),
                  SvgPictureWIidget(
                      image:
                          'assets/Frame 21619.svg',
                      height: 28,
                      width: 28),
                  ReusableSizedBox(
                    width: 15,
                  ),
                ]),
              )
            ]),
      ),
    );
  }
}

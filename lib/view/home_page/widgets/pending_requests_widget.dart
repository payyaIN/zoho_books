import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/utils/common_widgets/white_container.dart';

class PendingRequestsWidget extends StatelessWidget {
  const PendingRequestsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return WhiteContainer(
      child: ScalingFactor(
        child: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: ReusableColumn(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const HeadingTextPayzo(text: 'Pending Requests'),
                const ReusableSizedBox(
                  height: 10,
                ),
                const PendingRequestListTile(
                  companyLogo: 'assets/apple_logo.jpg',
                  subtitleText: 'Bill for the latest office',
                  companyName: 'Apple.co.inc',
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: PayzoDivider(),
                ),
                const PendingRequestListTile(
                  companyLogo: 'assets/mcdonalds-logo.jpg',
                  subtitleText: 'Bill for the latest office',
                  companyName: 'Mcdonalds',
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: PayzoDivider(),
                ),
                const PendingRequestListTile(
                  companyLogo: 'assets/starbucks_logo.jpg',
                  subtitleText: 'Bill for the latest office',
                  companyName: 'Starbucks',
                ),
                const ReusableSizedBox(
                  height: 8,
                ),
                ReusableRow(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'See More',
                      style: TextStyle(
                        color: Color(0xFF777777),
                        fontSize: 12,
                        fontFamily: 'SF Pro Display',
                        fontWeight: FontWeight.w400,
                        height: 1.52,
                      ),
                    ),
                    ReusableSizedBox(
                      height: 15,
                    ),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 20,
                    ),
                  ],
                ),
                const ReusableSizedBox(
                  height: 10,
                )
              ]),
        ),
      ),
    );
  }
}

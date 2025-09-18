import 'package:payzo_books/data/repository/get_user_details/get_user_details.dart';
import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/utils/app_data/image_data.dart';

class AccountNameWidget extends ConsumerStatefulWidget {
  const AccountNameWidget({super.key});

  @override
  ConsumerState<AccountNameWidget> createState() => _AccountNameWidgetState();
}

class _AccountNameWidgetState extends ConsumerState<AccountNameWidget> {
  @override
  Widget build(BuildContext context) {
    final userName = ref.watch(fetchUserDetails);

    return ScalingFactor(
      child: Padding(
        padding: const EdgeInsets.only(top: 60, left: 22, right: 22),

        child: ReusableColumn(
          children: [
            ReusableRow(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReusableText(
                  text: 'Welcome',
                  color: Colors.black,
                  fontSize: 12,
                  fontFamily: 'SF Pro Display',
                  fontWeight: FontWeight.w400,
                  height: 1.83,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, RouteNames.notificationScreen);
                  },
                  child: SvgPictureWIidget(
                    image: AppImages.bellBlack,
                    height: 22,
                    width: 22,
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.topLeft,
              child: ReusableSizedBox(
                width: 162,
                height: 30,
                child: ReusableText(
                  text: userName.when(
                    data: (data) => '${data.response!.userName}',
                    error: (err, _) {
                      print(_);
                      print('error is $err');
                      return '';
                    },
                    loading: () => '',
                  ),
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: 'SF Pro Display',
                  fontWeight: FontWeight.w700,
                  height: 1.83,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

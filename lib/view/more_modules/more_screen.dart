import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/utils/common_widgets/single_custom_btn.dart';
import 'package:payzo_books/view/main_screen/notifiers/logout_notifier.dart';
import 'package:payzo_books/view/more_modules/widgets/more_modules_list_tile.dart';

class MoreScreen extends ConsumerStatefulWidget {
  const MoreScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MoreScreenState();
}

class _MoreScreenState extends ConsumerState<MoreScreen> {
  @override
  Widget build(BuildContext context) {
    return ScalingFactor(
        child: Scaffold(
      appBar: reusableAppBarWithSuffixWidget(
        title: 'More Modules',
        context: context,
        showTitle: true,
        showBackButton: false,
        widget: Icon(Icons.logout),
        // SvgPictureWIidget(
        //     image: AppImages.logoutimg, height: 100, width: 100),
        onSuffixTap: () => performLogout(context, ref),
      ),
      //  reusableAppBar(
      //     title: 'More Modules', context: context, showBackButton: false),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 22, right: 22, bottom: 15, top: 15),
        child: ReusableColumn(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            FormContainer(
                height: 2,
                child: ReusablePadding(
                  padding: const EdgeInsets.only(
                      left: 15, right: 15, top: 18, bottom: 10),
                  child: ReusableColumn(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      MoreModulesListTile(
                        title: 'Customer',
                        onTap: () => Navigator.pushNamed(
                            context, RouteNames.customerScreen),
                      ),
                      MoreModulesListTile(
                        divider: true,
                        title: 'Vendors',
                        onTap: () => Navigator.pushNamed(
                            context, RouteNames.vendorScreen),
                      ),
                      MoreModulesListTile(
                        divider: false,
                        title: 'Expenses',
                        onTap: () => Navigator.pushNamed(
                            context, RouteNames.expensesListing),
                      ),
                    ],
                  ),
                )),
            // GapSpace.height500,
            // singleButton(
            //     isExpandNeeded: false,
            //     btnText: 'Log Out',
            //     onPress: () => performLogout(context, ref),
            //     height: 46,
            //     width: 342),
          ],
        ),
      ),
    ));
  }
}

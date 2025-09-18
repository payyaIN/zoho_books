import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/utils/app_data/color_palette.dart';

class NotificationTile extends StatelessWidget {
  final String title;
  final String message;
  final String timeAgo;
  final bool isDelivery;
  final bool isRead;
  // final int status;

  const NotificationTile({
    Key? key,
    required this.title,
    required this.message,
    required this.timeAgo,
    required this.isDelivery,
    required this.isRead,
    // required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // bool isRead = status == 1;
    return Container(
      decoration: BoxDecoration(
        color:
            isRead ? AppColors.appWhiteColor : AppColors.listTileSelectionColor,
        border: Border.all(color: AppColors.borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPictureWidget(
                image: isDelivery
                    ? AppImages.invoiceIcon1
                    : AppImages.invoiceIcon2,
                height: 28,
                width: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: ReusableText(
                          text: title,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: 'SF Pro Display',
                        ),
                      ),
                      Transform.translate(
                        offset: const Offset(0, 4),
                        child: ReusableText(
                          text: timeAgo,
                          color: Colors.grey[500],
                          fontSize: 12,
                          fontFamily: 'SF Pro Display',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ReusableText(
                    text: message,
                    color: Colors.grey[800],
                    fontSize: 14,
                    fontFamily: 'SF Pro Display',
                    maxLines: 2,
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

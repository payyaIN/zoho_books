import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/main_screen/notifiers/logout_notifier.dart';

void showLogoutConfirmation(BuildContext context, WidgetRef ref) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Logout'),
      content: Text('Are you sure you want to logout?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            performLogout(context, ref);
          },
          child: Text('Logout', style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}

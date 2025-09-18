import 'package:payzo_books/import_data.dart';
class WhiteContainer extends StatelessWidget {
  final Widget child;
  const WhiteContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ReusablePadding(
      padding: const EdgeInsets.only(left: 22,right: 22,top: 25),
      child: ReusableContainer(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        child: ReusablePadding(
          padding: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
          child: child,
        ),
      ),
    );
  }
}

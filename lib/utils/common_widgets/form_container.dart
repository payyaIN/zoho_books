import 'package:flutter/material.dart';
import 'package:payzo_books/utils/common_widgets/reusable_container.dart';

class FormContainer extends StatelessWidget {
  final Widget child;
  final double ?height;

  const FormContainer({super.key, required this.child,this.height});

  @override
  Widget build(BuildContext context) {
    return ReusableContainer(
      width: double.infinity,
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderWidth: 1,
      borderColor: Color.fromRGBO(238, 238, 238, 1),
      child: child,
    );
  }
}

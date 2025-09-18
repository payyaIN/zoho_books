import 'package:flutter/material.dart';
import 'package:payzo_books/import_data.dart';

class TrackInvetorySectionEditProducts extends StatelessWidget {
  const TrackInvetorySectionEditProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return ScalingFactor(
        child: FormContainer(
      height: 2,
      child: Padding(
        padding:
            const EdgeInsets.only(left: 15, right: 15, top: 18, bottom: 18),
        child: CustomToggleTile(
            title: 'Track Inventory for this item',
            value: true,
            onChanged: (value) {},
            divider: false),
      ),
    ));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payzo_books/data/repository/add_vendor/get_state_list_repository.dart';
import 'package:payzo_books/view/add/add_vendor/notifier/add_vendor_notifier.dart';
import 'package:payzo_books/utils/common_widgets/reusable_bottom_sheet.dart';

import '../../../../import_data.dart';

class AddVendorTopSection extends ConsumerWidget {
  const AddVendorTopSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vendorState = ref.watch(vendorFormProvider);
    final notifier = ref.read(vendorFormProvider.notifier);

    final state = ref.read(vendorFormProvider);
    final data = ref.watch(getCountryList);
    final stateData = ref.watch(getStateList);
    final vendorControllers = <String, TextEditingController>{
      'firstName': TextEditingController(),
      'firstNameArabic': TextEditingController(),
      'secondName': TextEditingController(),
      'secondNameArabic': TextEditingController(),
      'companyName': TextEditingController(),
      'companyNameArabic': TextEditingController(),
      'email': TextEditingController(),
      'mobile': TextEditingController(),
      'workPhone': TextEditingController(),
    };
    return FormContainer(
      height: 2,
      child: Padding(
        padding: const EdgeInsets.only(top: 0, left: 15, right: 15, bottom: 18),
        child: ReusableColumn(
          children: [
            ReusableColumn(
              children: vendorControllers.entries
                  .map((entry) => PayzoInputField(
                        label: entry.key,
                        required: entry.key == 'workPhone' ? false : true,
                        countryTap: entry.key == 'workPhone'
                            ? () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (_) => data.when(
                                      data: (data) =>
                                          ReusableCountryBottomSheet(
                                            title: 'Countries',
                                            items: data.response
                                                    ?.map((e) => e.countryName!)
                                                    .toList() ??
                                                [],
                                            onSelect: (selectedCountry) {
                                              final selected = data.response
                                                  ?.firstWhere((element) =>
                                                      element.countryName ==
                                                      selectedCountry);
                                              if (selected != null) {
                                                // notifier.updateBillingAddress('country',
                                                //     selected.countryName ?? '');
                                                ref
                                                    .read(countryPhoneProvider
                                                        .notifier)
                                                    .state = selected.ccphnCode
                                                        ?.toString() ??
                                                    '';
                                                ref
                                                    .read(countryFlagProvider
                                                        .notifier)
                                                    .state = selected
                                                        .countryFlag
                                                        ?.toString() ??
                                                    '';
                                              }
                                            },
                                          ),
                                      error: (err, _) {
                                        print(_);
                                        print('error is $err');
                                        return SizedBox();
                                      },
                                      loading: () => ReusableSizedBox(
                                          width: 10,
                                          height: 10,
                                          child: CircularProgressIndicator())),
                                );
                              }
                            : () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (_) => data.when(
                                      data: (data) =>
                                          ReusableCountryBottomSheet(
                                            title: 'Countries',
                                            items: data.response
                                                    ?.map((e) => e.countryName!)
                                                    .toList() ??
                                                [],
                                            onSelect: (selectedCountry) {
                                              final selected = data.response
                                                  ?.firstWhere((element) =>
                                                      element.countryName ==
                                                      selectedCountry);
                                              if (selected != null) {
                                                // notifier.updateBillingAddress('country',
                                                //     selected.countryName ?? '');
                                                ref
                                                    .read(countryPhoneProvider
                                                        .notifier)
                                                    .state = selected.ccphnCode
                                                        ?.toString() ??
                                                    '';
                                                ref
                                                    .read(
                                                        countryFlagMobileProvider
                                                            .notifier)
                                                    .state = selected
                                                        .countryFlag
                                                        ?.toString() ??
                                                    '';
                                              }
                                            },
                                          ),
                                      error: (err, _) {
                                        print(_);
                                        print('error is $err');
                                        return SizedBox();
                                      },
                                      loading: () => ReusableSizedBox(
                                          width: 10,
                                          height: 10,
                                          child: CircularProgressIndicator())),
                                );
                              },
                        controller: entry.value,
                        errorText: vendorState.errors[entry.key],
                        countryFlagCode: entry.key == 'workPhone'
                            ? ref.watch(countryFlagProvider)
                            : entry.key == 'mobile'
                                ? ref.watch(countryFlagMobileProvider)
                                : null,
                        onChanged: (value) =>
                            notifier.updateField(entry.key, value),
                      ))
                  .toList(),
            ),
            PayzoInputField(label: 'VAT Number'),
            PayzoInputField(label: 'Vendor CR')
          ],
        ),
      ),
    );
  }
}

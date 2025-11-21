import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payzo_books/data/repository/add_bills/get_branch_list_repository.dart';
import 'package:payzo_books/data/repository/add_bills/get_unit_list_repo.dart';
import 'package:payzo_books/data/repository/add_bills/get_vendor_list_repository.dart';
import 'package:payzo_books/data/repository/add_bills/shipping_method_repository.dart';
import 'package:payzo_books/data/repository/bills_api/bill_actions_repository.dart';
import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/utils/common_widgets/form_container.dart';
import 'package:payzo_books/utils/common_widgets/payzo_bottomsheet_navigator.dart';
import 'package:payzo_books/utils/common_widgets/payzo_form_submit_two_buttons.dart';
import 'package:payzo_books/utils/common_widgets/payzo_progress.dart';
import 'package:payzo_books/utils/common_widgets/reusable_appbar.dart';
import 'package:payzo_books/utils/common_widgets/reusable_column.dart';
import 'package:payzo_books/utils/common_widgets/reusable_row.dart';
import 'package:payzo_books/utils/common_widgets/reusable_sized_box.dart';
import 'package:payzo_books/utils/common_widgets/reusable_text.dart';
import 'package:payzo_books/utils/focus_utility/focus_utility.dart';
import 'package:payzo_books/view/add/add_billls/notifier/add_bill_form_notifier.dart';
import 'package:payzo_books/view/add/add_billls/widgets/bill_details_add_bills.dart';
import 'package:payzo_books/view/add/add_billls/widgets/bill_total_widget.dart';
import 'package:payzo_books/view/add/add_billls/widgets/item_details_add_bills.dart';
import 'package:payzo_books/view/bill_screen/notifier/edit_bill_form_notifier.dart';

class EditBillScreen extends ConsumerStatefulWidget {
  final int billId;
  const EditBillScreen({Key? key, required this.billId}) : super(key: key);

  @override
  ConsumerState<EditBillScreen> createState() => _EditBillScreenState();
}

class _EditBillScreenState extends ConsumerState<EditBillScreen> {
  // billDetailsControllers mapping:
  // 0 -> Bill Ref No
  // 1 -> Order No
  // 2 -> Customer Notes
  // 3 -> Terms
  // 4 -> Payment Terms
  // 5 -> Bill Info
  final List<TextEditingController> billDetailsControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  // Manage item controllers dynamically
  List<List<TextEditingController>> itemControllers = [];

  List<TextEditingController> _createControllersForItem() {
    return [
      TextEditingController(), // 0 -> quantity
      TextEditingController(), // 1 -> rate
      TextEditingController(), // 2 -> amount
      TextEditingController(), // 3 -> itemName
      TextEditingController(), // 4 -> discount
    ];
  }

  void _addControllersForNewItem() {
    itemControllers.add(_createControllersForItem());
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadBillDetails();
    });
  }

  @override
  void dispose() {
    for (var c in billDetailsControllers) c.dispose();
    for (var list in itemControllers) {
      for (var c in list) c.dispose();
    }
    super.dispose();
  }

  Future<void> _loadBillDetails() async {
    showPayzoProgress(context: context);
    try {
      final repo = ref.read(billActionsRepositoryProvider);
      final details = await repo.fetchBillEditDetails(widget.billId);
      if (details != null) {
        // Use addBillFormProvider which is overridden in parent
        final notifier = ref.read(addBillFormProvider.notifier);
        if (notifier is EditBillFormNotifier) {
          notifier.populate(details);
        }

        // Fetch lists to map IDs to names
        try {
          final vendorListAsync = await ref.read(getVendorList.future);
          final branchListAsync =
              await ref.read(fetchBranchListProvider.future);
          // Also fetch shipping methods to ensure validation passes
          final shippingMethods =
              await ref.read(fetchShippingMethodsProvider.future);
          // Fetch unit list to map unitId to unitType
          final unitList = await ref.read(fetchUnitListProvider.future);

          // Find Vendor Name
          if (details.billVendorId != null) {
            final vendor = vendorListAsync.response?.response?.firstWhere(
              (v) => v.partyId == details.billVendorId,
              orElse: () =>
                  vendorListAsync.response!.response!.first, // Fallback
            );
            if (vendor != null) {
              notifier.updateField('vendor', vendor.displayName ?? '');
              notifier.updateField('vendorId', vendor.partyId);
            }
          }

          // Find Branch Name
          if (details.billBranchId != null) {
            final branch = branchListAsync.data?.firstWhere(
              (b) => b.branchId == details.billBranchId,
              orElse: () => branchListAsync.data!.first, // Fallback
            );
            if (branch != null) {
              notifier.updateField('branch', branch.namePrimary ?? '');
              notifier.updateField('branchId', branch.branchId);
            }
          }

          // Set Default Shipping Method if not present (Validation Requirement)
          if (shippingMethods.isNotEmpty) {
            final landFreight = shippingMethods.firstWhere(
              (method) => method.shpmName == "Land Freight",
              orElse: () => shippingMethods.first,
            );
            notifier.updateField('shippingMethod', landFreight.shpmName ?? '');
            notifier.updateField('shippingMethodId', landFreight.shpmId);
          }

          // Map unitId to unitType for items
          final currentItems = notifier.state.itemDetails;
          for (int i = 0; i < currentItems.length; i++) {
            final item = currentItems[i];
            if (item.unitId != null &&
                (item.unitType == null || item.unitType!.isEmpty)) {
              final unit = unitList.firstWhere(
                (u) => u.unitId == item.unitId,
                orElse: () => unitList.first,
              );
              notifier.updateItemField(i, 'unitType', unit.displayUnit);
            }
          }
        } catch (e) {
          debugPrint("Error fetching dropdown lists: $e");
        }

        // Sync controllers with populated data
        billDetailsControllers[0].text = details.billInvoiceNumber ?? '';
        billDetailsControllers[1].text = details.billOrderNumber ?? '';
        billDetailsControllers[2].text = details.billCustomerNotes ?? '';
        billDetailsControllers[3].text = details.billTermsCondition ?? '';
        billDetailsControllers[4].text = details.billPaymentTerms ?? '';
        billDetailsControllers[5].text = details.billInfo ?? '';

        // Sync item controllers
        final items = details.billProductDetails;
        itemControllers.clear();
        for (var item in items) {
          final controllers = _createControllersForItem();
          // ItemDetailsAddBills mapping:
          // 0 -> Quantity
          // 1 -> Rate
          // 2 -> Amount (Not used for input)
          // 3 -> Item Name
          // 4 -> Discount

          controllers[0].text = item.billProdQuantity?.toString() ?? '';
          controllers[1].text = item.billProdUnitPrice?.toString() ?? '';
          controllers[2].text = item.billProdTotalAmount?.toString() ?? '';
          controllers[3].text = item.billProdName ?? '';
          controllers[4].text = item.billProdDiscountAmount?.toString() ?? '';

          itemControllers.add(controllers);
        }
        setState(() {});
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading bill details: $e')),
      );
    } finally {
      Navigator.pop(context); // Remove progress
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addBillFormProvider);
    final notifier = ref.read(addBillFormProvider.notifier);

    return Scaffold(
      appBar: reusableAppBar(
        title: 'Edit Bill',
        context: context,
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
        child: ReusableColumn(
          children: <Widget>[
            BillDetailsAddBills(
              controller: billDetailsControllers,
            ),
            const ReusableSizedBox(height: 15),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.itemDetails.length,
              itemBuilder: (context, index) {
                // Ensure controllers exist for this item
                if (index >= itemControllers.length) {
                  itemControllers.add(_createControllersForItem());
                }
                final controllersForThisItem = itemControllers[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: ItemDetailsAddBills(
                    index: index,
                    controllers: controllersForThisItem,
                  ),
                );
              },
            ),
            FormContainer(
              height: 2,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: PayzoBottomsheetNavigator(
                  isPayzoColor: true,
                  addButton: true,
                  title: 'Item Details',
                  trailing: 'Add New Line',
                  divider: false,
                  onTap: () async {
                    await ref.read(focusUtilsProvider).unfocusAndDelay();

                    final isValid = ref
                        .read(addBillFormProvider.notifier)
                        .validateLastItemFields();

                    if (isValid) {
                      // 1) Add form model item
                      ref.read(addBillFormProvider.notifier).addNewItem();

                      // 2) Add controllers for new item (must be after state change)
                      _addControllersForNewItem();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Finish filling out the current item to add a new one.'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
            const ReusableSizedBox(height: 15),
            FormContainer(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: ReusableColumn(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ReusableRow(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SvgPictureWIidget(
                            image: 'assets/pin.svg', height: 24, width: 24),
                        const ReusableSizedBox(width: 10),
                        Expanded(
                          child: PayzoBottomsheetNavigator(
                            title: 'Attachments',
                            divider: false,
                            trailing: state.attachment?.path.split('/').last ??
                                'Tap to Select',
                            onTap: () async {
                              await ref
                                  .read(focusUtilsProvider)
                                  .unfocusAndDelay();
                              final result =
                                  await FilePicker.platform.pickFiles(
                                type: FileType.custom,
                                allowedExtensions: [
                                  'pdf',
                                  'jpg',
                                  'png',
                                  'jpeg'
                                ],
                              );
                              if (result != null &&
                                  result.files.single.path != null) {
                                final pickedFile =
                                    File(result.files.single.path!);
                                notifier.updateField('attachment', pickedFile);
                              } else {
                                debugPrint('❌ No file selected');
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    if (state.attachment != null) ...[
                      const ReusableSizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.only(left: 34.0),
                        child: ReusableRow(
                          children: [
                            const Icon(Icons.insert_drive_file_outlined,
                                color: AppColors.appMainColor, size: 20),
                            const ReusableSizedBox(width: 8),
                            Expanded(
                              child: ReusableText(
                                text: state.attachment!.path.split('/').last,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                try {
                                  notifier.updateField('attachment', null);
                                } catch (e) {
                                  debugPrint(
                                      'Failed to clear attachment via updateField: $e');
                                }
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Icon(Icons.cancel_outlined,
                                    color: Colors.redAccent, size: 20),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const ReusableSizedBox(height: 15),
            BillTotalWidget(),
          ],
        ),
      ),
      bottomNavigationBar: PayzoFormSubmitTwoButtons(
        safeArea: true,
        cancelText: 'Clear',
        saveText: 'Update',
        cancelOnPressed: () {
          notifier.clearForm();
          for (var c in billDetailsControllers) c.clear();
          itemControllers.clear();
          _addControllersForNewItem();
          notifier.addNewItem();
        },
        saveOnPressed: () async {
          notifier.validateForm();
          await Future.delayed(Duration.zero);

          if (state.errors.isEmpty) {
            showPayzoProgress(context: context);
            try {
              if (notifier is EditBillFormNotifier) {
                await notifier.updateBill(widget.billId);
                Navigator.pop(context); // remove progress
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Bill updated successfully')),
                );
                Navigator.pop(context); // Go back
              }
            } catch (e) {
              Navigator.pop(context); // remove progress
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error updating bill: $e')),
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Please fill in all required fields')),
            );
          }
        },
      ),
    );
  }
}

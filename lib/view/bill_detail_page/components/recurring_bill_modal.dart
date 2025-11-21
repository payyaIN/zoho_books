import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payzo_books/data/repository/bills_api/bill_actions_repository.dart';
import 'package:payzo_books/utils/common_widgets/payzo_progress.dart';
import 'package:payzo_books/utils/common_widgets/reusable_bottom_sheet.dart';
import 'package:payzo_books/utils/common_widgets/payzo_input_field.dart';
import 'package:payzo_books/import_data.dart';

class RecurringBillModal extends ConsumerStatefulWidget {
  final int billId;
  const RecurringBillModal({Key? key, required this.billId}) : super(key: key);

  @override
  ConsumerState<RecurringBillModal> createState() => _RecurringBillModalState();
}

class _RecurringBillModalState extends ConsumerState<RecurringBillModal> {
  final TextEditingController _profileNameController = TextEditingController();
  final TextEditingController _repeatEveryController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  bool _neverExpire = false;

  String? _profileNameError;
  String? _repeatEveryError;
  String? _startDateError;
  String? _endDateError;

  final List<String> _frequencies = ['Day', 'Week', 'Month', 'Year'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Make Recurring',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          PayzoInputField(
            controller: _profileNameController,
            label: 'Profile Name',
            errorText: _profileNameError,
            onChanged: (val) {
              if (_profileNameError != null) {
                setState(() => _profileNameError = null);
              }
            },
          ),
          const SizedBox(height: 12),
          PayzoInputField(
            controller: _repeatEveryController,
            label: 'Repeat Every',
            errorText: _repeatEveryError,
            showList: true,
            showListTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => ReusableCountryBottomSheet(
                  title: 'Repeat Every',
                  items: _frequencies,
                  onSelect: (value) {
                    _repeatEveryController.text = value;
                    setState(() => _repeatEveryError = null);
                  },
                ),
              );
            },
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => ReusableCountryBottomSheet(
                  title: 'Repeat Every',
                  items: _frequencies,
                  onSelect: (value) {
                    _repeatEveryController.text = value;
                    setState(() => _repeatEveryError = null);
                  },
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          PayzoInputField(
            controller: _startDateController,
            label: 'Start Date',
            errorText: _startDateError,
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2100),
              );
              if (date != null) {
                _startDateController.text =
                    date.toIso8601String().split('T')[0];
                setState(() => _startDateError = null);
              }
            },
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Checkbox(
                value: _neverExpire,
                onChanged: (val) {
                  setState(() {
                    _neverExpire = val ?? false;
                    if (_neverExpire) {
                      _endDateController.clear();
                      _endDateError = null;
                    }
                  });
                },
              ),
              const Text('Never Expire'),
            ],
          ),
          if (!_neverExpire)
            PayzoInputField(
              controller: _endDateController,
              label: 'End Date',
              errorText: _endDateError,
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (date != null) {
                  _endDateController.text =
                      date.toIso8601String().split('T')[0];
                  setState(() => _endDateError = null);
                }
              },
            ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Save'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool _validate() {
    bool isValid = true;
    setState(() {
      if (_profileNameController.text.isEmpty) {
        _profileNameError = 'Profile Name is required';
        isValid = false;
      } else {
        _profileNameError = null;
      }

      if (_repeatEveryController.text.isEmpty) {
        _repeatEveryError = 'Frequency is required';
        isValid = false;
      } else {
        _repeatEveryError = null;
      }

      if (_startDateController.text.isEmpty) {
        _startDateError = 'Start Date is required';
        isValid = false;
      } else {
        _startDateError = null;
      }

      if (!_neverExpire && _endDateController.text.isEmpty) {
        _endDateError = 'End Date is required';
        isValid = false;
      } else {
        _endDateError = null;
      }
    });
    return isValid;
  }

  Future<void> _submit() async {
    if (!_validate()) return;

    final dto = {
      "billId": widget.billId,
      "profileName": _profileNameController.text,
      "repeatEvery": _repeatEveryController.text,
      "startDate": _startDateController.text,
      "endDate": _neverExpire ? null : _endDateController.text,
      "neverExpire": _neverExpire,
    };

    showPayzoProgress(context: context);
    try {
      final repo = ref.read(billActionsRepositoryProvider);
      await repo.submitRecurringBill(dto);
      Navigator.pop(context); // Remove progress
      Navigator.pop(context); // Close modal
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Recurring bill created')));
    } catch (e) {
      Navigator.pop(context); // Remove progress
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }
}

import 'package:absence_manager/absence_records/absence_records_enums.dart';
import 'package:absence_manager/absence_records/models/absence_records_filter_model.dart';
import 'package:absence_manager/core/shared_utils.dart';
import 'package:flutter/material.dart';

class AbsenceRecordsFilterDialog extends StatefulWidget {
  const AbsenceRecordsFilterDialog({super.key});

  @override
  State<StatefulWidget> createState() => _AbsenceRecordsFilterDialogState();
}

class _AbsenceRecordsFilterDialogState
    extends State<AbsenceRecordsFilterDialog> {
  DateTime? _selectedDate;
  AbsenceRequestType? _selectedRequestType;
  final dropDownOptions = [
    AbsenceRequestType.vacation,
    AbsenceRequestType.sickness
  ];
  final TextEditingController dateFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: theme.colorScheme.primary,
        leading: const IgnorePointer(),
      ),
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Absence Request Type:",
                          style: Theme.of(context).textTheme.labelLarge),
                      DropdownButtonFormField(
                          //key: PersonalExpenseKeys.categoryFieldKey,
                          value: _selectedRequestType,
                          decoration:
                              InputDecoration(border: OutlineInputBorder()),
                          hint: Text("Selected Request Type",
                              style: Theme.of(context).textTheme.bodyMedium),
                          items: dropDownOptions.map((request) {
                            return DropdownMenuItem<AbsenceRequestType>(
                                value: request,
                                child: Text(request.type.toUpperCase(),
                                    style:
                                        Theme.of(context).textTheme.bodyLarge));
                          }).toList(),
                          onChanged: (AbsenceRequestType? value) {
                            setState(() {
                              _selectedRequestType = value;
                            });
                          }),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Date:",
                          style: Theme.of(context).textTheme.labelLarge),
                      TextFormField(
                        readOnly: true,
                        //key: PersonalExpenseKeys.dateFieldKey,
                        controller: dateFieldController,
                        style: Theme.of(context).textTheme.bodyLarge,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Select Date",
                            hintStyle: Theme.of(context).textTheme.bodyMedium),
                        onTap: () async {
                          await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2021),
                            lastDate: DateTime.now(),
                          ).then((date) {
                            if (date != null) {
                              setState(() {
                                _selectedDate = date;
                                dateFieldController.text =
                                    SharedUtils.getYearMonthDayFormat(date);
                              });
                            }
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(24),
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("Cancel")),
                      ),
                      Padding(
                        padding: EdgeInsets.all(24),
                        child: ElevatedButton(
                            onPressed: _selectedDate == null &&
                                    _selectedRequestType == null
                                ? null
                                : () {
                                    if (_selectedDate != null ||
                                        _selectedRequestType != null) {
                                      Navigator.of(context).pop(
                                          AbsenceRecordsFilterModel(
                                              selectedDate: _selectedDate,
                                              selectedRequestType:
                                                  _selectedRequestType));
                                    }
                                  },
                            child: Text("Submit")),
                      )
                    ],
                  )
                ],
              ),
            )),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    dateFieldController.dispose();
    _selectedDate = null;
    _selectedRequestType = null;
  }
}

import 'package:absence_manager/absence_records/absence_records_enums.dart';
import 'package:absence_manager/absence_records/absence_records_strings.dart';
import 'package:absence_manager/absence_records/models/absence_records_filter_model.dart';
import 'package:absence_manager/core/shared_utils.dart';
import 'package:flutter/material.dart';

class AbsenceRecordsFilterDialog extends StatefulWidget {
  const AbsenceRecordsFilterDialog({super.key});

  @override
  State<AbsenceRecordsFilterDialog> createState() =>
      _AbsenceRecordsFilterDialogState();
}

class _AbsenceRecordsFilterDialogState
    extends State<AbsenceRecordsFilterDialog> {
  DateTime? _selectedDate;
  AbsenceRequestType? _selectedRequestType;

  final dropDownOptions = [
    AbsenceRequestType.vacation,
    AbsenceRequestType.sickness
  ];
  final _formKey = GlobalKey<FormState>();
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
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(AbsenceRecordsStrings.absenceRecordFilter,
                      style: theme.textTheme.headlineSmall
                          ?.copyWith(color: theme.colorScheme.primary)),
                  SizedBox(height: 24),
                  _RequestTypeDropdown(
                    selectedRequestType: _selectedRequestType,
                    onChanged: (value) {
                      setState(() {
                        _selectedRequestType = value;
                      });
                    },
                    onValidate: (_) {
                      if (_selectedRequestType == null &&
                          _selectedDate == null) {
                        return AbsenceRecordsStrings.formValidationErrorMessage;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24),
                  _DatePickerField(
                    controller: dateFieldController,
                    selectedDate: _selectedDate,
                    onDateSelected: (date) {
                      setState(() {
                        _selectedDate = date;
                        dateFieldController.text =
                            SharedUtils.getYearMonthDayFormat(date);
                      });
                    },
                    onValidate: (_) {
                      if (_selectedRequestType == null &&
                          _selectedDate == null) {
                        return AbsenceRecordsStrings.formValidationErrorMessage;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24),
                  _ActionButtons(
                    onCancel: () {
                      Navigator.pop(context);
                    },
                    onSubmit: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.of(context).pop(
                          AbsenceRecordsFilterModel(
                            selectedDate: _selectedDate,
                            selectedRequestType: _selectedRequestType,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    dateFieldController.dispose();
  }
}

class _RequestTypeDropdown extends StatelessWidget {
  final AbsenceRequestType? selectedRequestType;
  final ValueChanged<AbsenceRequestType?> onChanged;
  final FormFieldValidator<AbsenceRequestType>? onValidate;

  const _RequestTypeDropdown(
      {required this.selectedRequestType,
      required this.onChanged,
      required this.onValidate});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AbsenceRecordsStrings.absenceRequestType,
          style: theme.textTheme.labelLarge,
        ),
        DropdownButtonFormField<AbsenceRequestType>(
            value: selectedRequestType,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
            hint: Text(
              AbsenceRecordsStrings.absenceRequestTypeHint,
              style: theme.textTheme.bodyMedium,
            ),
            items: AbsenceRequestType.values.map((request) {
              return DropdownMenuItem<AbsenceRequestType>(
                value: request,
                child: Text(
                  request.type.toUpperCase(),
                  style: theme.textTheme.bodyLarge,
                ),
              );
            }).toList(),
            onChanged: onChanged,
            validator: onValidate),
      ],
    );
  }
}

class _DatePickerField extends StatelessWidget {
  final TextEditingController controller;
  final DateTime? selectedDate;
  final ValueChanged<DateTime?> onDateSelected;
  final FormFieldValidator<String>? onValidate;

  const _DatePickerField(
      {required this.controller,
      required this.selectedDate,
      required this.onDateSelected,
      required this.onValidate});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AbsenceRecordsStrings.date,
          style: theme.textTheme.labelLarge,
        ),
        TextFormField(
            readOnly: true,
            controller: controller,
            style: theme.textTheme.bodyLarge,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: AbsenceRecordsStrings.dateHint,
              hintStyle: theme.textTheme.bodyMedium,
            ),
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2021),
                lastDate: DateTime.now(),
              );
              if (date != null) {
                onDateSelected(date);
              }
            },
            validator: onValidate),
      ],
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onSubmit;

  const _ActionButtons({
    required this.onCancel,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: ElevatedButton(
              onPressed: onCancel,
              style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                      Theme.of(context).colorScheme.inverseSurface),
                  foregroundColor: WidgetStateProperty.all(
                      Theme.of(context).colorScheme.onPrimary)),
              child: const Text(AbsenceRecordsStrings.cancel),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: ElevatedButton(
              onPressed: onSubmit,
              style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                      Theme.of(context).colorScheme.primary),
                  foregroundColor: WidgetStateProperty.all(
                      Theme.of(context).colorScheme.onPrimary)),
              child: const Text(AbsenceRecordsStrings.submit),
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:absence_manager/absence_records/absence_records_enums.dart';
import 'package:absence_manager/absence_records/absence_records_strings.dart';
import 'package:absence_manager/absence_records/absence_records_widget_keys.dart';
import 'package:absence_manager/absence_records/bloc/absence_records_bloc.dart';
import 'package:absence_manager/absence_records/bloc/absence_records_event.dart';
import 'package:absence_manager/absence_records/bloc/absence_records_state.dart';
import 'package:absence_manager/core/shared_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AbsenceRecordsFilterWidget extends StatelessWidget {
  final dropDownOptions = [
    AbsenceRequestType.vacation,
    AbsenceRequestType.sickness
  ];
  final _formKey = GlobalKey<FormState>();
  final TextEditingController dateFieldController = TextEditingController();

  AbsenceRecordsFilterWidget({super.key});

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
        child: BlocBuilder<AbsenceRecordsBloc, AbsenceRecordsState>(
            builder: (context, state) {
          if (state.dateFilter != null) {
            dateFieldController.text = state.dateFilter!.formattedDate;
          }
          return Padding(
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
                      selectedRequestType: state.requestTypeFilter,
                      onChanged: (value) {
                        context.read<AbsenceRecordsBloc>().add(
                              UpdateRequestTypeFilterEvent(
                                  requestTypeFilter: value),
                            );
                      },
                      onValidate: (_) {
                        if (state.requestTypeFilter == null &&
                            state.dateFilter == null) {
                          return AbsenceRecordsStrings
                              .formValidationErrorMessage;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 24),
                    _DatePickerField(
                      controller: dateFieldController,
                      selectedDate: state.dateFilter,
                      onDateSelected: (date) {
                        dateFieldController.text = date!.formattedDate;
                        context.read<AbsenceRecordsBloc>().add(
                              UpdateDateFilterEvent(dateFilter: date),
                            );
                      },
                      onValidate: (_) {
                        if (state.requestTypeFilter == null &&
                            state.dateFilter == null) {
                          return AbsenceRecordsStrings
                              .formValidationErrorMessage;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 24),
                    _ActionButtons(
                      onCancel: () {
                        context
                            .read<AbsenceRecordsBloc>()
                            .add(ClearAllFiltersEvent());
                        Navigator.pop(context);
                      },
                      onSubmit: () {
                        if (_formKey.currentState!.validate()) {
                          context
                              .read<AbsenceRecordsBloc>()
                              .add(AbsenceRecordsWithFilterEvent());
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
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
            key: AbsenceRecordsWidgetKeys.requestTypeFieldKey,
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
            key: AbsenceRecordsWidgetKeys.dateFieldKey,
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
              key: AbsenceRecordsWidgetKeys.clearFilterButtonKey,
              onPressed: onCancel,
              style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                      Theme.of(context).colorScheme.inverseSurface),
                  foregroundColor: WidgetStateProperty.all(
                      Theme.of(context).colorScheme.onPrimary)),
              child: const Text(AbsenceRecordsStrings.clearFilters),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: ElevatedButton(
              key: AbsenceRecordsWidgetKeys.submitButtonKey,
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

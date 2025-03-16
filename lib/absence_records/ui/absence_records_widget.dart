import 'package:absence_manager/absence_records/bloc/absence_records_bloc.dart';
import 'package:absence_manager/absence_records/bloc/absence_records_event.dart';
import 'package:absence_manager/absence_records/bloc/absence_records_state.dart';
import 'package:absence_manager/absence_records/models/absence_records_filter_model.dart';
import 'package:absence_manager/absence_records/ui/absence_records_filter_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AbsenceRecordsWidget extends StatelessWidget {
  const AbsenceRecordsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: theme.colorScheme.primary,
          title: Text("Absence Records"),
        ),
        body: SafeArea(child:
            BlocBuilder<AbsenceRecordsBloc, AbsenceRecordsState>(
                builder: (context, state) {
          if (state is AbsenceRecordsLoadingState) {
            return Center(child: CircularProgressIndicator());
          } else if (state is AbsenceRecordsErrorState) {
            return Center(
                child: Text(
                    "Sorry something went wrong. Please try again later."));
          } else {
            return Container(
              color: theme.colorScheme.surfaceContainer,
              child: Column(
                children: [
                  StatusAndFilterWidget(state: state),
                  Expanded(
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (scrollNotification) {
                        if (scrollNotification is ScrollEndNotification) {
                          if (scrollNotification.metrics.maxScrollExtent ==
                              scrollNotification.metrics.pixels) {
                            if (state.currentAbsenceRecordsCount <
                                state.totalAbsenceRecordsCount) {
                              context
                                  .read<AbsenceRecordsBloc>()
                                  .add(FetchPaginatedRecordsEvent());
                            }
                          }
                        }
                        return true;
                      },
                      child: ListView.builder(
                          itemCount: state.records.length,
                          itemBuilder: (context, index) {
                            final record = state.records[index];
                            return Row(
                              children: [
                                Expanded(
                                  child: Card(
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(record.name),
                                      )),
                                ),
                              ],
                            );
                          }),
                    ),
                  ),
                ],
              ),
            );
          }
        })));
  }
}

class StatusAndFilterWidget extends StatelessWidget {
  final AbsenceRecordsState state;
  const StatusAndFilterWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Row(children: [
      Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Text(
            "Showing ${state.records.length} of ${state.totalAbsenceRecordsCount}",
            style: theme.textTheme.bodyMedium),
      ),
      Spacer(),
      if (state.dateFilter == null && state.statusFilter == null)
        TextButton(
            onPressed: () async {
              AbsenceRecordsFilterModel? filterModel =
                  await Navigator.of(context).push(
                      MaterialPageRoute<AbsenceRecordsFilterModel>(
                          builder: (context) => AbsenceRecordsFilterDialog()));
              print(
                  "Date: ${filterModel?.selectedDate.toString()}  Request Type: ${filterModel?.selectedRequestType.toString()}");
            },
            child: Row(
              children: [
                Text("FILTER",
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(color: theme.colorScheme.primary)),
                Icon(Icons.filter_list_alt,
                    color: Theme.of(context).colorScheme.primary)
              ],
            )),
      if (state.dateFilter != null)
        FilterTagWidget(
            label: state.dateFilter!,
            onTapClear: () {
              context.read<AbsenceRecordsBloc>().add(ClearDateFilterEvent());
            }),
      if (state.statusFilter != null)
        FilterTagWidget(
            label: state.statusFilter!.name,
            onTapClear: () {
              context.read<AbsenceRecordsBloc>().add(ClearStatusFilterEvent());
            }),
    ]);
  }
}

class FilterTagWidget extends StatelessWidget {
  final String label;
  final VoidCallback onTapClear;

  const FilterTagWidget(
      {super.key, required this.label, required this.onTapClear});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return InkWell(
      onTap: onTapClear,
      child: Container(
        padding: EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: theme.colorScheme.primary,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Text(label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                )),
            Padding(
              padding: const EdgeInsets.only(left: 2.0),
              child: Icon(
                Icons.close,
                color: theme.colorScheme.primary,
                size: 16,
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:absence_manager/absence_records/absence_records_enums.dart';
import 'package:absence_manager/absence_records/absence_records_strings.dart';
import 'package:absence_manager/absence_records/bloc/absence_records_bloc.dart';
import 'package:absence_manager/absence_records/bloc/absence_records_event.dart';
import 'package:absence_manager/absence_records/bloc/absence_records_state.dart';
import 'package:absence_manager/absence_records/bloc/absence_state.dart';
import 'package:absence_manager/absence_records/models/absence_records_filter_model.dart';
import 'package:absence_manager/absence_records/ui/absence_records_filter_dialog.dart';
import 'package:absence_manager/core/shared_utils.dart';
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
        title: const Text(AbsenceRecordsStrings.absenceRecords),
        actions: [
          IconButton(
              onPressed: () async {
                final filterModel = await Navigator.of(context).push(
                  MaterialPageRoute<AbsenceRecordsFilterModel>(
                    builder: (context) => const AbsenceRecordsFilterDialog(),
                    fullscreenDialog: true,
                  ),
                );
                if (filterModel != null) {
                  context.read<AbsenceRecordsBloc>().add(
                        AbsenceRecordsWithFilterEvent(filterModel: filterModel),
                      );
                }
              },
              icon: Icon(Icons.filter_list_alt))
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<AbsenceRecordsBloc, AbsenceRecordsState>(
          builder: (context, state) {
            if (state is AbsenceRecordsInitialLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AbsenceRecordsErrorState) {
              return const Center(
                  child: Text(AbsenceRecordsStrings.technicalDifficulties));
            } else {
              return AbsenceRecordsList(state: state);
            }
          },
        ),
      ),
    );
  }
}

class AbsenceRecordsList extends StatelessWidget {
  final AbsenceRecordsState state;

  const AbsenceRecordsList({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.surfaceContainer,
      child: Column(
        children: [
          PageAndFilterSection(state: state),
          state.records.isEmpty
              ? Expanded(
                  child: Center(
                  child: Text(AbsenceRecordsStrings.noAbsenceRecordsMessage),
                ))
              : Expanded(
                  child: NotificationListener<ScrollNotification>(
                  onNotification: (scrollNotification) {
                    if (scrollNotification is ScrollEndNotification &&
                        scrollNotification.metrics.maxScrollExtent ==
                            scrollNotification.metrics.pixels) {
                      if (state.currentAbsenceRecordsCount <
                          state.totalAbsenceRecordsCount) {
                        context
                            .read<AbsenceRecordsBloc>()
                            .add(FetchPaginatedRecordsEvent());
                      }
                    }
                    return true;
                  },
                  child: ListView.builder(
                    itemCount: state.records.length,
                    itemBuilder: (context, index) {
                      final record = state.records[index];
                      return AbsenceRecordCard(record: record);
                    },
                  ),
                )),
        ],
      ),
    );
  }
}

class PageAndFilterSection extends StatelessWidget {
  final AbsenceRecordsState state;

  const PageAndFilterSection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Text(
            "Showing ${state.records.length} of ${state.totalAbsenceRecordsCount}",
            style: theme.textTheme.bodyMedium,
          ),
          const Spacer(),
          Row(
            children: [
              if (state.dateFilter != null)
                FilterTagWidget(
                  label: SharedUtils.getYearMonthDayFormat(state.dateFilter),
                  onTapClear: () {
                    context
                        .read<AbsenceRecordsBloc>()
                        .add(ClearDateFilterEvent());
                  },
                ),
              SizedBox(width: 8),
              if (state.requestTypeFilter != null)
                FilterTagWidget(
                  label: state.requestTypeFilter!.type.toUpperCase(),
                  onTapClear: () {
                    context
                        .read<AbsenceRecordsBloc>()
                        .add(ClearRequestTypeFilterEvent());
                  },
                ),
            ],
          )
        ],
      ),
    );
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
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: theme.colorScheme.primary,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
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

class AbsenceRecordCard extends StatelessWidget {
  final AbsenceState record;

  const AbsenceRecordCard({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Card(
            color: theme.colorScheme.surface,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  NameAndStatusListItem(record: record),
                  DurationListItem(record: record),
                  CategoryListItem(record: record),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class NameAndStatusListItem extends StatelessWidget {
  final AbsenceState record;

  const NameAndStatusListItem({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Color statusColor;
    String status;

    switch (record.status) {
      case AbsenceStatusType.requested:
        status = AbsenceRecordsStrings.requested;
        statusColor = theme.colorScheme.primary;
      case AbsenceStatusType.confirmed:
        status = AbsenceRecordsStrings.confirmed;
        statusColor = theme.colorScheme.tertiary;
      case AbsenceStatusType.rejected:
        status = AbsenceRecordsStrings.rejected;
        statusColor = theme.colorScheme.error;
    }

    return Row(
      children: [
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              record.name,
              style: theme.textTheme.bodyLarge,
            ),
            Row(
              children: [
                Text(
                  record.type.type.toUpperCase(),
                  style: theme.textTheme.bodySmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            )
          ],
        )),
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: statusColor.withAlpha(50),
            border: Border.all(
              color: statusColor,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(status,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: statusColor,
              )),
        ),
      ],
    );
  }
}

class DurationListItem extends StatelessWidget {
  final AbsenceState record;

  const DurationListItem({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Row(
            children: [
              Text("Start Date: ",
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  )),
              Text(SharedUtils.getYearMonthDayFormat(record.startDate),
                  style: theme.textTheme.bodySmall),
              SizedBox(width: 8),
              Text("End Date: ",
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  )),
              Text(SharedUtils.getYearMonthDayFormat(record.endDate),
                  style: theme.textTheme.bodySmall),
            ],
          ),
        ),
      ],
    );
  }
}

class CategoryListItem extends StatelessWidget {
  final AbsenceState record;

  const CategoryListItem({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(record.type.type.toString()),
      ],
    );
  }
}

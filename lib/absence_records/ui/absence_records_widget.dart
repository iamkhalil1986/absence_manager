import 'package:absence_manager/absence_records/absence_records_enums.dart';
import 'package:absence_manager/absence_records/absence_records_strings.dart';
import 'package:absence_manager/absence_records/bloc/absence_records_bloc.dart';
import 'package:absence_manager/absence_records/bloc/absence_records_event.dart';
import 'package:absence_manager/absence_records/bloc/absence_records_state.dart';
import 'package:absence_manager/absence_records/bloc/absence_state.dart';
import 'package:absence_manager/absence_records/ui/absence_record_detail_widget.dart';
import 'package:absence_manager/absence_records/ui/absence_records_filter_widget.dart';
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
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AbsenceRecordsFilterWidget(),
                    fullscreenDialog: true,
                  ),
                );
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
              return _AbsenceRecordsList(state: state);
            }
          },
        ),
      ),
    );
  }
}

class _AbsenceRecordsList extends StatelessWidget {
  final AbsenceRecordsState state;

  const _AbsenceRecordsList({required this.state});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.surfaceContainer,
      child: Column(
        children: [
          _PageAndFilterSection(state: state),
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
                      return _AbsenceRecordCard(record: record);
                    },
                  ),
                )),
        ],
      ),
    );
  }
}

class _PageAndFilterSection extends StatelessWidget {
  final AbsenceRecordsState state;

  const _PageAndFilterSection({required this.state});

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
                _FilterTagWidget(
                  label: state.dateFilter!.formattedDate,
                  onTapClear: () {
                    context
                        .read<AbsenceRecordsBloc>()
                        .add(ClearDateFilterEvent());
                  },
                ),
              SizedBox(width: 8),
              if (state.requestTypeFilter != null)
                _FilterTagWidget(
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

class _FilterTagWidget extends StatelessWidget {
  final String label;
  final VoidCallback onTapClear;

  const _FilterTagWidget({required this.label, required this.onTapClear});

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

class _AbsenceRecordCard extends StatelessWidget {
  final AbsenceState record;

  const _AbsenceRecordCard({required this.record});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Card(
            color: theme.colorScheme.surface,
            child: _AbsenceRecordsListItem(record: record),
          ),
        ),
      ],
    );
  }
}

class _AbsenceRecordsListItem extends StatelessWidget {
  final AbsenceState record;

  const _AbsenceRecordsListItem({required this.record});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Color statusColor;
    String status;
    IconData statusIcon;
    switch (record.status) {
      case AbsenceStatusType.requested:
        status = AbsenceRecordsStrings.requested;
        statusColor = theme.colorScheme.primary;
        statusIcon = Icons.hourglass_empty;
      case AbsenceStatusType.confirmed:
        status = AbsenceRecordsStrings.confirmed;
        statusColor = theme.colorScheme.tertiary;
        statusIcon = Icons.check_circle;
      case AbsenceStatusType.rejected:
        status = AbsenceRecordsStrings.rejected;
        statusColor = theme.colorScheme.error;
        statusIcon = Icons.cancel;
    }
    final duration = record.endDate.difference(record.startDate).inDays + 1;
    return ListTile(
      onTap: () {
        showModalBottomSheet(
            context: context,
            backgroundColor: Theme.of(context).colorScheme.surface,
            builder: (BuildContext context) {
              return AbsenceRecordDetailWidget(
                record: record,
                status: status,
                statusColor: statusColor,
                statusIcon: statusIcon,
                duration: duration,
              );
            });
      },
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: statusColor,
        ),
        child: Icon(
          statusIcon,
          color: Colors.white,
          size: 24,
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              record.name,
              style: theme.textTheme.bodyLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            alignment: Alignment.topRight,
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: statusColor.withAlpha(20),
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
          )
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            record.type.type.capitalizeFirst,
            style: theme.textTheme.bodySmall,
          ),
          Text(
            'Duration: $duration ${duration == 1 ? "day" : "days"}',
            style: theme.textTheme.bodySmall,
          ),
          duration == 1
              ? Text("On: ${record.startDate.formattedDate}",
                  style: theme.textTheme.bodySmall?.copyWith(
                      //fontWeight: FontWeight.bold,
                      ))
              : Text(
                  "From ${record.startDate.formattedDate} To ${record.endDate.formattedDate}",
                  style: theme.textTheme.bodySmall?.copyWith(
                      //fontWeight: FontWeight.bold,
                      )),
        ],
      ),
    );
  }
}

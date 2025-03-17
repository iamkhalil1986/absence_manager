import 'package:absence_manager/absence_records/absence_records_strings.dart';
import 'package:absence_manager/absence_records/bloc/absence_state.dart';
import 'package:absence_manager/core/shared_utils.dart';
import 'package:flutter/material.dart';

class AbsenceRecordDetailWidget extends StatelessWidget {
  final AbsenceState record;
  final Color statusColor;
  final String status;
  final IconData statusIcon;
  final int duration;

  const AbsenceRecordDetailWidget(
      {super.key,
      required this.record,
      required this.statusColor,
      required this.status,
      required this.statusIcon,
      required this.duration});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Container(
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
          ),
          Text(status,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: statusColor,
              )),
          _AbsenceRecordDetailItemWidget(
              label: AbsenceRecordsStrings.name, value: record.name),
          _AbsenceRecordDetailItemWidget(
              label: AbsenceRecordsStrings.requestCategory,
              value: record.type.type.capitalizeFirst),
          _AbsenceRecordDetailItemWidget(
              label: AbsenceRecordsStrings.duration,
              value: "$duration ${duration == 1 ? "day" : "days"}"),
          duration == 1
              ? _AbsenceRecordDetailItemWidget(
                  label: AbsenceRecordsStrings.date,
                  value: record.startDate.formattedDate)
              : Row(
                  children: [
                    Expanded(
                      child: _AbsenceRecordDetailItemWidget(
                          label: AbsenceRecordsStrings.startDate,
                          value: record.startDate.formattedDate),
                    ),
                    Expanded(
                      child: _AbsenceRecordDetailItemWidget(
                          label: AbsenceRecordsStrings.endDate,
                          value: record.endDate.formattedDate),
                    )
                  ],
                ),
          Visibility(
              visible: record.memberNote.isNotEmpty,
              child: _AbsenceRecordDetailItemWidget(
                  label: AbsenceRecordsStrings.membersNote,
                  value: record.memberNote)),
          Visibility(
              visible: record.admitterNote.isNotEmpty,
              child: _AbsenceRecordDetailItemWidget(
                  label: AbsenceRecordsStrings.admittersNote,
                  value: record.admitterNote))
        ],
      ),
    );
  }
}

class _AbsenceRecordDetailItemWidget extends StatelessWidget {
  final String label;
  final String value;
  const _AbsenceRecordDetailItemWidget(
      {required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          Text(value, style: Theme.of(context).textTheme.bodyLarge),
          Divider()
        ],
      ),
    );
  }
}

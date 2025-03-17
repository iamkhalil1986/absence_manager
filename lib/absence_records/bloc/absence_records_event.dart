import 'package:absence_manager/absence_records/absence_records_enums.dart';
import 'package:equatable/equatable.dart';

class AbsenceRecordsEvent extends Equatable {
  const AbsenceRecordsEvent();
  @override
  List<Object?> get props => [];
}

class FetchAllRecordsEvent extends AbsenceRecordsEvent {}

class FetchPaginatedRecordsEvent extends AbsenceRecordsEvent {}

class AbsenceRecordsWithFilterEvent extends AbsenceRecordsEvent {}

class UpdateRequestTypeFilterEvent extends AbsenceRecordsEvent {
  final AbsenceRequestType? requestTypeFilter;

  const UpdateRequestTypeFilterEvent({this.requestTypeFilter});

  @override
  List<Object?> get props => [requestTypeFilter];
}

class UpdateDateFilterEvent extends AbsenceRecordsEvent {
  final DateTime? dateFilter;

  const UpdateDateFilterEvent({this.dateFilter});

  @override
  List<Object?> get props => [dateFilter];
}

class ClearDateFilterEvent extends AbsenceRecordsEvent {}

class ClearRequestTypeFilterEvent extends AbsenceRecordsEvent {}

class ClearAllFiltersEvent extends AbsenceRecordsEvent {}

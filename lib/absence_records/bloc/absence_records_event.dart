import 'package:absence_manager/absence_records/models/absence_records_filter_model.dart';
import 'package:equatable/equatable.dart';

class AbsenceRecordsEvent extends Equatable {
  const AbsenceRecordsEvent();
  @override
  List<Object?> get props => [];
}

class FetchAllRecordsEvent extends AbsenceRecordsEvent {}

class FetchPaginatedRecordsEvent extends AbsenceRecordsEvent {}

class AbsenceRecordsWithFilterEvent extends AbsenceRecordsEvent {
  final AbsenceRecordsFilterModel? filterModel;

  const AbsenceRecordsWithFilterEvent({this.filterModel});

  @override
  List<Object?> get props => [filterModel];
}

class ClearDateFilterEvent extends AbsenceRecordsEvent {}

class ClearRequestTypeFilterEvent extends AbsenceRecordsEvent {}

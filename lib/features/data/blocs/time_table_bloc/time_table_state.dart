part of 'time_table_bloc.dart';

sealed class TimeTableState extends Equatable {
  const TimeTableState();

  @override
  List<Object> get props => [];
}

final class TimeTableLoading extends TimeTableState {}

final class TimeTableSuccess extends TimeTableState {
  final List<TimeTableModel> timeTableList;

  const TimeTableSuccess({required this.timeTableList});
}

final class TimeTableFailure extends TimeTableState {
  final String errorMessage;
  final String? statusCode;

  const TimeTableFailure({required this.errorMessage, this.statusCode});
}

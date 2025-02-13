part of 'time_table_bloc.dart';

sealed class TimeTableEvent extends Equatable {
  const TimeTableEvent();

  @override
  List<Object> get props => [];
}

final class TimeTableRequested extends TimeTableEvent {
  final int studentId;

  const TimeTableRequested({required this.studentId});
}

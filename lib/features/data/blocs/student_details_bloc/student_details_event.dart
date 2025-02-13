part of 'student_details_bloc.dart';

sealed class StudentDetailsEvent extends Equatable {
  const StudentDetailsEvent();

  @override
  List<Object> get props => [];
}

class AttendanceDetailsRequested extends StudentDetailsEvent {
  final int studentId;
  final int timeId;
  final int page;
  final bool? hideLoading;

  const AttendanceDetailsRequested({required this.studentId, required this.timeId, required this.page, this.hideLoading});
  @override
  List<Object> get props => [studentId, timeId, page, hideLoading ?? false];
}

class TransactionDetailsRequested extends StudentDetailsEvent {
  final int studentId;
  final String type;
  final int page;
  final bool? hideLoading;

  const TransactionDetailsRequested(
      {required this.studentId, required this.type, required this.page, this.hideLoading});

  @override
  List<Object> get props => [studentId, type, page, hideLoading ?? false];
}

class GradesDetailsRequested extends StudentDetailsEvent {
  final int studentId;
  final String type;

  const GradesDetailsRequested({required this.studentId, required this.type});
  @override
  List<Object> get props => [studentId, type];
}

class CommentsDetailsRequested extends StudentDetailsEvent {
  final int studentId;
  final String type;

  const CommentsDetailsRequested({required this.studentId, required this.type});
  @override
  List<Object> get props => [studentId, type];
}

class DailyGradeDetailsRequested extends StudentDetailsEvent {
  final int studentId;
  final String type;
  final bool? hideLoading;
  final int page;

  const DailyGradeDetailsRequested({
    required this.studentId,
    required this.type,
    required this.page,
    this.hideLoading,
  });
  @override
  List<Object> get props => [studentId, type, page, hideLoading ?? false];
}

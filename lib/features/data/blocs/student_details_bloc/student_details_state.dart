part of 'student_details_bloc.dart';

sealed class StudentDetailsState extends Equatable {
  const StudentDetailsState();

  @override
  List<Object> get props => [];
}

final class StudentDetailsLoading extends StudentDetailsState {}

// Attendance...
final class AttendanceSuccess extends StudentDetailsState {
  final List<AttendanceModel> attendanceList;
  final bool? hasMore;

  const AttendanceSuccess({required this.attendanceList, this.hasMore});
  @override
  List<Object> get props => [attendanceList, hasMore ?? true];
}

final class AttendanceFailure extends StudentDetailsState {
  final String errorMessage;

  const AttendanceFailure({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}

// Transaction...
final class TransactionSuccess extends StudentDetailsState {
  final List<TransactionModel> transactionList;

  const TransactionSuccess({required this.transactionList});
  @override
  List<Object> get props => [transactionList];
}

final class TransactionFailure extends StudentDetailsState {
  final String errorMessage;

  const TransactionFailure({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

// Grades...
final class GradesSuccess extends StudentDetailsState {
  final List<GradeModel> gradesList;

  const GradesSuccess({required this.gradesList});
  @override
  List<Object> get props => [gradesList];
}

final class GradesFailure extends StudentDetailsState {
  final String errorMessage;
  final String? statusCode;

  const GradesFailure({required this.errorMessage, this.statusCode});
  @override
  List<Object> get props => [errorMessage, statusCode ?? ''];
}

// Comments...
final class CommentsSuccess extends StudentDetailsState {
  final List<CommentModel> commentsList;

  const CommentsSuccess({required this.commentsList});
  @override
  List<Object> get props => [commentsList];
}

final class CommentsFailure extends StudentDetailsState {
  final String errorMessage;

  const CommentsFailure({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}

// Daily Grade...
final class DailyGradesSuccess extends StudentDetailsState {
  final List<DailyGradeModel> dailyGradesList;

  const DailyGradesSuccess({required this.dailyGradesList});
  @override
  List<Object> get props => [dailyGradesList];
}

final class DailyGradeFailure extends StudentDetailsState {
  final String errorMessage;

  const DailyGradeFailure({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

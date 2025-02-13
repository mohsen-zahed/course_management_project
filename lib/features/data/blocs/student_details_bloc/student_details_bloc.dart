import 'package:bloc/bloc.dart';
import 'package:course_management_project/config/exceptions/app_exceptions.dart';
import 'package:course_management_project/features/data/models/attendance_model.dart';
import 'package:course_management_project/features/data/models/commetns_model.dart';
import 'package:course_management_project/features/data/models/daily_grade_model.dart';
import 'package:course_management_project/features/data/models/grade_model.dart';
import 'package:course_management_project/features/data/models/transaction_model.dart';
import 'package:course_management_project/features/data/repository/idata_repository.dart';
import 'package:course_management_project/packages/dio_package/status_codes.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

part 'student_details_event.dart';
part 'student_details_state.dart';

class StudentDetailsBloc extends Bloc<StudentDetailsEvent, StudentDetailsState> {
  static int attendancePage = 1;
  static bool attendanceHasMore = true;
  static int transactionPage = 1;
  static bool transactionHasMore = true;
  static int dailyGradesPage = 1;
  static bool dailyGradesHasMore = true;

  final IDataRepository iDataRepository;

  StudentDetailsBloc(this.iDataRepository) : super(StudentDetailsLoading()) {
    on<AttendanceDetailsRequested>(_onAttendanceDetailsRequested);
    on<TransactionDetailsRequested>(_onTransactionDetailsRequested);
    on<GradesDetailsRequested>(_onGradesDetailsRequested);
    on<CommentsDetailsRequested>(_onCommentsDetailsRequested);
    on<DailyGradeDetailsRequested>(_onDailyGradeDetailsRequested);
  }

  _onAttendanceDetailsRequested(AttendanceDetailsRequested event, Emitter<StudentDetailsState> emit) async {
    event.hideLoading != true ? emit(StudentDetailsLoading()) : null;
    try {
      final result = await iDataRepository.fetchStudentAttendanceDetails(event.studentId, event.timeId, event.page);
      if (result.isNotEmpty && result.length >= 30) {
        attendancePage = event.page;
        attendanceHasMore = true;
      } else {
        attendanceHasMore = false;
      }
      emit(AttendanceSuccess(attendanceList: result, hasMore: attendanceHasMore));
    } on NoDataException catch (e) {
      emit(AttendanceFailure(errorMessage: e.message));
    } on NoInternetException catch (e) {
      emit(AttendanceFailure(errorMessage: e.message));
    } on NoServerException catch (e) {
      emit(AttendanceFailure(errorMessage: e.message));
    } on AuthException catch (e) {
      emit(AttendanceFailure(errorMessage: e.message));
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.badResponse:
          emit(AttendanceFailure(errorMessage: e.message.toString()));
          break;
        case DioExceptionType.connectionError:
          emit(const AttendanceFailure(errorMessage: StatusCodes.noInternetConnectionCode));
          break;
        case DioExceptionType.connectionTimeout:
          emit(const AttendanceFailure(errorMessage: StatusCodes.noServerFoundCode));
          break;
        case DioExceptionType.unknown:
          emit(const AttendanceFailure(errorMessage: 'UKNOWN'));
        default:
          emit(const AttendanceFailure(errorMessage: 'UKNOWN'));
      }
    } catch (e) {
      emit(AttendanceFailure(errorMessage: e.toString()));
    }
  }

  _onTransactionDetailsRequested(TransactionDetailsRequested event, Emitter<StudentDetailsState> emit) async {
    event.hideLoading != true ? emit(StudentDetailsLoading()) : null;
    try {
      final result = await iDataRepository.fetchStudentTransactionDetails(event.studentId, event.type, event.page);
      if (result.isNotEmpty && result.length >= 30) {
        transactionPage = event.page;
        transactionHasMore = true;
      } else {
        transactionHasMore = false;
      }
      emit(TransactionSuccess(transactionList: result));
    } on NoDataException catch (e) {
      emit(TransactionFailure(errorMessage: e.message));
    } on NoInternetException catch (e) {
      emit(TransactionFailure(errorMessage: e.message));
    } on NoServerException catch (e) {
      emit(TransactionFailure(errorMessage: e.message));
    } on AuthException catch (e) {
      emit(TransactionFailure(errorMessage: e.message));
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.badResponse:
          emit(TransactionFailure(errorMessage: e.message.toString()));
          break;
        case DioExceptionType.connectionError:
          emit(const TransactionFailure(errorMessage: StatusCodes.noInternetConnectionCode));
          break;
        case DioExceptionType.connectionTimeout:
          emit(const TransactionFailure(errorMessage: StatusCodes.noServerFoundCode));
          break;
        case DioExceptionType.unknown:
          emit(const TransactionFailure(errorMessage: 'UKNOWN'));
        default:
          emit(const TransactionFailure(errorMessage: 'UKNOWN'));
      }
    } catch (e) {
      emit(TransactionFailure(errorMessage: e.toString()));
    }
  }

  _onGradesDetailsRequested(GradesDetailsRequested event, Emitter<StudentDetailsState> emit) async {
    emit(StudentDetailsLoading());
    try {
      final result = await iDataRepository.fetchStudentGradesDetails(event.studentId, event.type);
      emit(GradesSuccess(gradesList: result));
    } on NoDataException catch (e) {
      emit(GradesFailure(errorMessage: e.message));
    } on NoInternetException catch (e) {
      emit(GradesFailure(errorMessage: e.message));
    } on NoServerException catch (e) {
      emit(GradesFailure(errorMessage: e.message));
    } on AuthException catch (e) {
      emit(GradesFailure(errorMessage: e.message));
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.cancel:
          emit(const GradesFailure(errorMessage: StatusCodes.cancelCode));
        case DioExceptionType.badResponse:
          emit(const GradesFailure(errorMessage: StatusCodes.badStateCode));
          break;
        case DioExceptionType.connectionError:
          emit(const GradesFailure(errorMessage: StatusCodes.noInternetConnectionCode));
          break;
        case DioExceptionType.connectionTimeout:
          emit(const GradesFailure(errorMessage: StatusCodes.noServerFoundCode));
          break;
        case DioExceptionType.unknown:
          emit(const GradesFailure(errorMessage: StatusCodes.unknownCode));
        default:
          emit(const GradesFailure(errorMessage: StatusCodes.unknownCode));
      }
    } catch (e) {
      emit(GradesFailure(errorMessage: e.toString()));
    }
  }

  _onCommentsDetailsRequested(CommentsDetailsRequested event, Emitter<StudentDetailsState> emit) async {
    emit(StudentDetailsLoading());
    try {
      final result = await iDataRepository.fetchStudentCommentsDetails(event.studentId, event.type);
      emit(CommentsSuccess(commentsList: result));
    } on NoDataException catch (e) {
      emit(CommentsFailure(errorMessage: e.message));
    } on NoInternetException catch (e) {
      emit(CommentsFailure(errorMessage: e.message));
    } on NoServerException catch (e) {
      emit(CommentsFailure(errorMessage: e.message));
    } on AuthException catch (e) {
      emit(CommentsFailure(errorMessage: e.message));
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.badResponse:
          emit(CommentsFailure(errorMessage: e.message.toString()));
          break;
        case DioExceptionType.connectionError:
          emit(const CommentsFailure(errorMessage: StatusCodes.noInternetConnectionCode));
          break;
        case DioExceptionType.connectionTimeout:
          emit(const CommentsFailure(errorMessage: StatusCodes.noServerFoundCode));
          break;
        case DioExceptionType.unknown:
          emit(const CommentsFailure(errorMessage: 'UKNOWN'));
        default:
          emit(const CommentsFailure(errorMessage: 'UKNOWN'));
      }
    } catch (e) {
      emit(CommentsFailure(errorMessage: e.toString()));
    }
  }

  _onDailyGradeDetailsRequested(DailyGradeDetailsRequested event, Emitter<StudentDetailsState> emit) async {
    event.hideLoading != true ? emit(StudentDetailsLoading()) : null;
    try {
      final result = await iDataRepository.fetchStudentDailyGradeDetails(event.studentId, event.type, event.page);
      if (result.isNotEmpty && result.length >= 30) {
        dailyGradesPage = event.page;
        dailyGradesHasMore = true;
      } else {
        dailyGradesHasMore = false;
      }
      emit(DailyGradesSuccess(dailyGradesList: result));
    } on NoDataException catch (e) {
      emit(DailyGradeFailure(errorMessage: e.message));
    } on NoInternetException catch (e) {
      emit(DailyGradeFailure(errorMessage: e.message));
    } on NoServerException catch (e) {
      emit(DailyGradeFailure(errorMessage: e.message));
    } on AuthException catch (e) {
      emit(DailyGradeFailure(errorMessage: e.message));
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.badResponse:
          emit(DailyGradeFailure(errorMessage: e.message.toString()));
          break;
        case DioExceptionType.connectionError:
          emit(const DailyGradeFailure(errorMessage: StatusCodes.noInternetConnectionCode));
          break;
        case DioExceptionType.connectionTimeout:
          emit(const DailyGradeFailure(errorMessage: StatusCodes.noServerFoundCode));
          break;
        case DioExceptionType.unknown:
          emit(const DailyGradeFailure(errorMessage: StatusCodes.unknownCode));
        default:
          emit(const DailyGradeFailure(errorMessage: StatusCodes.unknownCode));
      }
    } catch (e) {
      emit(DailyGradeFailure(errorMessage: e.toString()));
    }
  }
}

import 'package:bloc/bloc.dart';
import 'package:course_management_project/config/exceptions/app_exceptions.dart';
import 'package:course_management_project/features/data/models/time_table_model.dart';
import 'package:course_management_project/features/data/repository/idata_repository.dart';
import 'package:course_management_project/packages/dio_package/status_codes.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

part 'time_table_event.dart';
part 'time_table_state.dart';

class TimeTableBloc extends Bloc<TimeTableEvent, TimeTableState> {
  final IDataRepository iDataRepository;

  TimeTableBloc(this.iDataRepository) : super(TimeTableLoading()) {
    on<TimeTableRequested>(_onTimeTableRequested);
  }

  _onTimeTableRequested(TimeTableRequested event, Emitter<TimeTableState> emit) async {
    emit(TimeTableLoading());
    try {
      final result = await iDataRepository.fetchStudentTimeTable(event.studentId);
      emit(TimeTableSuccess(timeTableList: result));
    } on NoDataException catch (e) {
      emit(TimeTableFailure(errorMessage: e.message));
    } on NoInternetException catch (e) {
      emit(TimeTableFailure(errorMessage: e.message));
    } on NoServerException catch (e) {
      emit(TimeTableFailure(errorMessage: e.message));
    } on AuthException catch (e) {
      emit(TimeTableFailure(errorMessage: e.message));
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.badResponse:
          emit(TimeTableFailure(errorMessage: e.message.toString()));
          break;
        case DioExceptionType.connectionError:
          emit(const TimeTableFailure(errorMessage: StatusCodes.noInternetConnectionCode));
          break;
        case DioExceptionType.connectionTimeout:
          emit(const TimeTableFailure(errorMessage: StatusCodes.noServerFoundCode));
          break;
        case DioExceptionType.unknown:
          emit(const TimeTableFailure(errorMessage: 'UKNOWN'));
        default:
          emit(const TimeTableFailure(errorMessage: 'UKNOWN'));
      }
    } catch (e) {
      emit(TimeTableFailure(errorMessage: e.toString()));
    }
  }
}

import 'package:bloc/bloc.dart';
import 'package:course_management_project/config/exceptions/app_exceptions.dart';
import 'package:course_management_project/features/data/models/student_model.dart';
import 'package:course_management_project/features/data/repository/idata_repository.dart';
import 'package:course_management_project/packages/dio_package/status_codes.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final IDataRepository iDataRepository;

  HomeBloc(this.iDataRepository) : super(HomeLoading()) {
    on<StudentsListRequested>(_onStudentsListRequested);
  }

  _onStudentsListRequested(StudentsListRequested event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      final result = await iDataRepository.fetchStudentsList();
      emit(StudentsListSuccess(studentsList: result));
    } on NoDataException catch (e) {
      emit(StudentsListFailure(errorMessage: e.message));
    } on NoInternetException catch (e) {
      emit(StudentsListFailure(errorMessage: e.message));
    } on NoServerException catch (e) {
      emit(StudentsListFailure(errorMessage: e.message));
    } on AuthException catch (e) {
      emit(StudentsListFailure(errorMessage: e.message));
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.badResponse:
          emit(StudentsListFailure(errorMessage: e.message.toString()));
          break;
        case DioExceptionType.connectionError:
          emit(const StudentsListFailure(errorMessage: StatusCodes.noInternetConnectionCode));
          break;
        case DioExceptionType.connectionTimeout:
          emit(const StudentsListFailure(errorMessage: StatusCodes.noServerFoundCode));
          break;
        case DioExceptionType.unknown:
          emit(const StudentsListFailure(errorMessage: 'UKNOWN'));
        default:
          emit(const StudentsListFailure(errorMessage: 'UKNOWN'));
      }
    } catch (e) {
      emit(StudentsListFailure(errorMessage: e.toString()));
    }
  }
}

import 'package:bloc/bloc.dart';
import 'package:course_management_project/config/exceptions/app_exceptions.dart';
import 'package:course_management_project/features/data/models/news_model.dart';
import 'package:course_management_project/features/data/repository/idata_repository.dart';
import 'package:course_management_project/packages/dio_package/status_codes.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final IDataRepository iDataRepository;
  NewsBloc(this.iDataRepository) : super(NewsLoading()) {
    on<NewsDataRequested>(_onNewsDataRequested);
  }

  _onNewsDataRequested(NewsDataRequested event, Emitter<NewsState> emit) async {
    emit(NewsLoading());
    try {
      final result = await iDataRepository.fetchNewsData(event.page);
      emit(NewsSuccess(newsList: result));
    } on NoDataException catch (e) {
      emit(NewsFailure(errorMessage: e.message));
    } on NoInternetException catch (e) {
      emit(NewsFailure(errorMessage: e.message));
    } on NoServerException catch (e) {
      emit(NewsFailure(errorMessage: e.message));
    } on AuthException catch (e) {
      emit(NewsFailure(errorMessage: e.message));
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.badResponse:
          emit(NewsFailure(errorMessage: e.message.toString()));
          break;
        case DioExceptionType.connectionError:
          emit(const NewsFailure(errorMessage: StatusCodes.noInternetConnectionCode));
          break;
        case DioExceptionType.connectionTimeout:
          emit(const NewsFailure(errorMessage: StatusCodes.noServerFoundCode));
          break;
        case DioExceptionType.unknown:
          emit(const NewsFailure(errorMessage: 'UKNOWN'));
        default:
          emit(const NewsFailure(errorMessage: 'UKNOWN'));
      }
    } catch (e) {
      emit(NewsFailure(errorMessage: e.toString()));
    }
  }
}

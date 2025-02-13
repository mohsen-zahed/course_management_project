import 'package:bloc/bloc.dart';
import 'package:course_management_project/config/exceptions/app_exceptions.dart';
import 'package:course_management_project/features/data/models/user_model.dart';
import 'package:course_management_project/features/data/repository/iauth_repository.dart';
import 'package:course_management_project/packages/dio_package/status_codes.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final IAuthRepository iAuthRepository;
  AuthBloc(this.iAuthRepository) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthenticatingUser());
    try {
      final result = await iAuthRepository.loginUser(event.email, event.password);
      emit(AuthSuccess(userModel: result));
    } on NoDataException catch (e) {
      emit(AuthFailure(errorMessage: e.message));
    } on NoInternetException catch (e) {
      emit(AuthFailure(errorMessage: e.message));
    } on NoServerException catch (e) {
      emit(AuthFailure(errorMessage: e.message));
    } on DioException catch (e) {
      if (e.response?.statusCode == 302) {
        emit(const AuthFailure(errorMessage: StatusCodes.unAthurizedCode));
        // throw AuthException('message');
      } else {
        switch (e.type) {
          case DioExceptionType.badResponse:
            emit(AuthFailure(errorMessage: e.message.toString()));
            break;
          case DioExceptionType.connectionError:
            emit(const AuthFailure(errorMessage: StatusCodes.noInternetConnectionCode));
            break;
          case DioExceptionType.connectionTimeout:
            emit(const AuthFailure(errorMessage: StatusCodes.noServerFoundCode));
            break;
          case DioExceptionType.unknown:
            emit(const AuthFailure(errorMessage: 'UKNOWN'));
          default:
            emit(const AuthFailure(errorMessage: 'UKNOWN'));
        }
      }
    } catch (e) {
      emit(AuthFailure(errorMessage: e.toString()));
    } finally {
      emit(AuthInitial());
    }
  }

  _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) async {
    emit(LoggingOut());
    try {
      final result = await iAuthRepository.logoutUser(event.id);
      emit(LogoutSuccess(message: result));
    } on NoDataException catch (e) {
      emit(LogoutFailure(errorMessage: e.message));
    } on NoInternetException catch (e) {
      emit(LogoutFailure(errorMessage: e.message));
    } on NoServerException catch (e) {
      emit(LogoutFailure(errorMessage: e.message));
    } on DioException catch (e) {
      if (e.response?.statusCode == 302) {
        emit(const LogoutFailure(errorMessage: StatusCodes.unAthurizedCode));
        // throw AuthException('message');
      } else {
        switch (e.type) {
          case DioExceptionType.badResponse:
            emit(LogoutFailure(errorMessage: e.message.toString()));
            break;
          case DioExceptionType.connectionError:
            emit(const LogoutFailure(errorMessage: StatusCodes.noInternetConnectionCode));
            break;
          case DioExceptionType.connectionTimeout:
            emit(const LogoutFailure(errorMessage: StatusCodes.noServerFoundCode));
            break;
          case DioExceptionType.unknown:
            emit(const LogoutFailure(errorMessage: StatusCodes.unknownCode));
          default:
            emit(const LogoutFailure(errorMessage: StatusCodes.unknownCode));
        }
      }
    } catch (e) {
      emit(LogoutFailure(errorMessage: e.toString()));
    } finally {
      emit(AuthInitial());
    }
  }
}

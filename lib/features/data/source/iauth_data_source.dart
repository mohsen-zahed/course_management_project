import 'dart:async';
import 'dart:io';

import 'package:course_management_project/config/exceptions/app_exceptions.dart';
import 'package:course_management_project/features/data/models/user_model.dart';
import 'package:course_management_project/helpers/helper_functions.dart';
import 'package:course_management_project/packages/dio_package/dio_package.dart';
import 'package:course_management_project/packages/dio_package/status_codes.dart';
import 'package:dio/dio.dart';

abstract class IAuthDataSource {
  Future<UserModel> loginUser(String email, String password);
  Future<String> logoutUser(int id);
}

class AuthDataSourceImp implements IAuthDataSource {
  final Dio httpClient;

  const AuthDataSourceImp({required this.httpClient});
  @override
  Future<UserModel> loginUser(String email, String password) async {
    try {
      cancelToken = CancelToken();
      final response = await httpClient
          .post(
            'api/student/login',
            queryParameters: {'email': email, 'password': password},
            options: Options(contentType: 'application/json'),
            cancelToken: cancelToken,
          )
          .timeout(const Duration(seconds: defaultTimeOut));
      if (response.data == null) {
        throw const NoDataException(StatusCodes.noDataReceivedCode);
      } else if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        return UserModel.fromJson(response.data);
      } else {
        throw UnknowException('${response.statusMessage} ${response.statusCode}');
      }
    } on SocketException catch (_) {
      throw const NoInternetException(StatusCodes.noInternetConnectionCode);
    } on TimeoutException catch (_) {
      throw const NoServerException(StatusCodes.noServerFoundCode);
    }
  }

  @override
  Future<String> logoutUser(int id) async {
    try {
      cancelToken = CancelToken();
      final tokenId = await HelperFunctions.extractTokenId();
      final response = await httpClient
          .post(
            'api/logout',
            queryParameters: {
              'id': id,
              'token_id': tokenId,
            },
            cancelToken: cancelToken,
          )
          .timeout(const Duration(seconds: defaultTimeOut));
      if (response.data == null) {
        throw const NoDataException(StatusCodes.noDataReceivedCode);
      } else if (response.statusCode == 200 && response.data is Map) {
        return response.data['message'];
      } else if (response.statusCode == 200 && response.data is! Map) {
        throw const AuthException(StatusCodes.unAthurizedCode);
      } else {
        throw UnknowException('${response.statusMessage} ${response.statusCode}');
      }
    } on SocketException catch (_) {
      throw const NoInternetException(StatusCodes.noInternetConnectionCode);
    } on TimeoutException catch (_) {
      throw const NoServerException(StatusCodes.noServerFoundCode);
    }
  }
}

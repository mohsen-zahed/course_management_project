import 'dart:async';
import 'dart:io';

import 'package:course_management_project/config/exceptions/app_exceptions.dart';
import 'package:course_management_project/features/data/models/attendance_model.dart';
import 'package:course_management_project/features/data/models/commetns_model.dart';
import 'package:course_management_project/features/data/models/daily_grade_model.dart';
import 'package:course_management_project/features/data/models/grade_model.dart';
import 'package:course_management_project/features/data/models/news_model.dart';
import 'package:course_management_project/features/data/models/student_model.dart';
import 'package:course_management_project/features/data/models/time_table_model.dart';
import 'package:course_management_project/features/data/models/transaction_model.dart';
import 'package:course_management_project/packages/dio_package/dio_package.dart';
import 'package:course_management_project/packages/dio_package/status_codes.dart';
import 'package:dio/dio.dart';

abstract class IDataDataSource {
  Future<List<StudentModel>> fetchStudentsList();
  Future<List<AttendanceModel>> fetchStudentAttendanceDetails(int studentId, int timeId, int page);
  Future<List<TransactionModel>> fetchStudentTransactionDetails(int studentId, String type, int page);
  Future<List<GradeModel>> fetchStudentGradesDetails(int studentId, String type);
  Future<List<CommentModel>> fetchStudentCommentsDetails(int studentId, String type);
  Future<List<DailyGradeModel>> fetchStudentDailyGradeDetails(int studentId, String type, int page);
  Future<List<TimeTableModel>> fetchStudentTimeTable(int studentId);
  Future<List<NewsModel>> fetchNewsData(int page);
}

class DataDataSourceImp implements IDataDataSource {
  final Dio httpClient;

  const DataDataSourceImp({required this.httpClient});

  @override
  Future<List<StudentModel>> fetchStudentsList() async {
    try {
      cancelToken = CancelToken();
      final response = await httpClient
          .get(
            'api/show_students',
            cancelToken: cancelToken,
          )
          .timeout(const Duration(seconds: defaultTimeOut));

      if (response.data == null) {
        throw const NoDataException(StatusCodes.noDataReceivedCode);
      } else if (response.statusCode == 200 && response.data is List) {
        return (response.data as List).map((e) => StudentModel.fromJson(e)).toList();
      } else if (response.statusCode == 200 && (response.data is! List && response.data.contains('<!DOCTYPE html>'))) {
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

  @override
  Future<List<AttendanceModel>> fetchStudentAttendanceDetails(int studentId, int timeId, int page) async {
    try {
      cancelToken = CancelToken();
      final response = await httpClient
          .get(
            'api/show_time_table_attendance',
            queryParameters: {
              'id': studentId,
              'time_id': timeId,
              'page': page,
            },
            cancelToken: cancelToken,
          )
          .timeout(const Duration(seconds: defaultTimeOut));
      if (response.data == null) {
        throw const NoDataException(StatusCodes.noDataReceivedCode);
      } else if (response.statusCode == 200 && response.data is Map) {
        return (response.data['data'] as List).map((e) => AttendanceModel.fromJson(e)).toList();
      } else if (response.statusCode == 200 && response.data is! Map<String, dynamic>) {
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

  @override
  Future<List<TransactionModel>> fetchStudentTransactionDetails(int studentId, String type, int page) async {
    try {
      cancelToken = CancelToken();
      final response = await httpClient.get(
        'api/get_information',
        queryParameters: {
          'id': studentId,
          'type': type,
          'page': page,
        },
        cancelToken: cancelToken,
      );
      if (response.data == null) {
        throw const NoDataException(StatusCodes.noDataReceivedCode);
      } else if (response.statusCode == 200 && response.data is Map) {
        return (response.data['data'] as List).map((e) => TransactionModel.fromJson(e)).toList();
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

  @override
  Future<List<GradeModel>> fetchStudentGradesDetails(int studentId, String type) async {
    try {
      cancelToken = CancelToken();
      final response = await httpClient
          .get(
            'api/get_information',
            queryParameters: {
              'id': studentId,
              'type': type,
            },
            cancelToken: cancelToken,
          )
          .timeout(const Duration(seconds: defaultTimeOut));
      if (response.data == null) {
        throw const NoDataException(StatusCodes.noDataReceivedCode);
      } else if (response.statusCode == 200 && response.data is List) {
        return (response.data as List).map((e) => GradeModel.fromJson(e)).toList();
      } else if (response.statusCode == 200 && response.data is! List) {
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

  @override
  Future<List<CommentModel>> fetchStudentCommentsDetails(int studentId, String type) async {
    try {
      cancelToken = CancelToken();
      final response = await httpClient
          .get(
            'api/get_information',
            queryParameters: {
              'id': studentId,
              'type': type,
            },
            cancelToken: cancelToken,
          )
          .timeout(const Duration(seconds: defaultTimeOut));
      if (response.data == null) {
        throw const NoDataException(StatusCodes.noDataReceivedCode);
      } else if (response.statusCode == 200 && response.data is Map) {
        return (response.data['data'] as List).map((e) => CommentModel.fromJson(e)).toList();
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

  @override
  Future<List<DailyGradeModel>> fetchStudentDailyGradeDetails(int studentId, String type, int page) async {
    try {
      cancelToken = CancelToken();
      final response = await httpClient
          .get(
            'api/get_information',
            queryParameters: {
              'id': studentId,
              'type': type,
              'page': page,
            },
            cancelToken: cancelToken,
          )
          .timeout(const Duration(seconds: defaultTimeOut));

      if (response.data == null) {
        throw const NoDataException(StatusCodes.noDataReceivedCode);
      } else if (response.statusCode == 200 && response.data is Map) {
        return (response.data['data'] as List).map((e) => DailyGradeModel.fromJson(e)).toList();
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

  @override
  Future<List<TimeTableModel>> fetchStudentTimeTable(int studentId) async {
    try {
      cancelToken = CancelToken();
      final response = await httpClient
          .get(
            'api/show_time_table',
            queryParameters: {'id': studentId},
            cancelToken: cancelToken,
          )
          .timeout(const Duration(seconds: defaultTimeOut));
      if (response.data == null) {
        throw const NoDataException(StatusCodes.noDataReceivedCode);
      } else if (response.statusCode == 200 && response.data is List) {
        return (response.data as List).map((e) => TimeTableModel.fromJson(e)).toList();
      } else if (response.statusCode == 200 && response.data is! List) {
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

  @override
  Future<List<NewsModel>> fetchNewsData(int page) async {
    try {
      cancelToken = CancelToken();
      final response = await httpClient
          .get(
            newsGetApi,
            cancelToken: cancelToken,
          )
          .timeout(const Duration(seconds: defaultTimeOut));
      if (response.data == null) {
        throw const NoDataException(StatusCodes.noDataReceivedCode);
      } else if (response.statusCode == 200 && response.data is Map && response.data['data'].isEmpty) {
        return [];
      } else if (response.statusCode == 200 && response.data is Map) {
        return (response.data['data'] as List).map((e) => NewsModel.fromJson(e)).toList();
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

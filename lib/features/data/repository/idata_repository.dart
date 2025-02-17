import 'package:course_management_project/config/constants/list.dart';
import 'package:course_management_project/features/data/models/ad_banner_model.dart';
import 'package:course_management_project/features/data/models/attendance_model.dart';
import 'package:course_management_project/features/data/models/commetns_model.dart';
import 'package:course_management_project/features/data/models/daily_grade_model.dart';
import 'package:course_management_project/features/data/models/grade_model.dart';
import 'package:course_management_project/features/data/models/home_student_model.dart';
import 'package:course_management_project/features/data/models/news_model.dart';
import 'package:course_management_project/features/data/models/student_model.dart';
import 'package:course_management_project/features/data/models/time_table_model.dart';
import 'package:course_management_project/features/data/models/transaction_model.dart';
import 'package:course_management_project/features/data/providers/attendance_provider.dart';
import 'package:course_management_project/features/data/providers/daily_grades_provider.dart';
import 'package:course_management_project/features/data/providers/news_provider.dart';
import 'package:course_management_project/features/data/providers/transaction_provider.dart';
import 'package:course_management_project/features/data/source/idata_data_source.dart';
import 'package:course_management_project/packages/dio_package/dio_package.dart';
import 'package:course_management_project/packages/get_it_package/get_it_package.dart';

final dataRepository = DataRepositoryImp(iDataDataSource: DataDataSourceImp(httpClient: httpClient));

abstract class IDataRepository extends IDataDataSource {}

class DataRepositoryImp implements IDataRepository {
  final IDataDataSource iDataDataSource;

  const DataRepositoryImp({required this.iDataDataSource});

  @override
  Future<List<StudentModel>> fetchStudentsList() async {
    try {
      final result = await iDataDataSource.fetchStudentsList();
      return result;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<AttendanceModel>> fetchStudentAttendanceDetails(int studentId, int timeId, int page) async {
    try {
      final result = await iDataDataSource.fetchStudentAttendanceDetails(studentId, timeId, page);
      di<AttendanceProvider>().updateAttendanceList(result);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<TransactionModel>> fetchStudentTransactionDetails(int studentId, String type, int page) async {
    try {
      final result = await iDataDataSource.fetchStudentTransactionDetails(studentId, type, page);
      di<TransactionProvider>().updateTransactionList(result);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<GradeModel>> fetchStudentGradesDetails(int studentId, String type) async {
    try {
      final result = await iDataDataSource.fetchStudentGradesDetails(studentId, type);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<CommentModel>> fetchStudentCommentsDetails(int studentId, String type) async {
    try {
      final result = await iDataDataSource.fetchStudentCommentsDetails(studentId, type);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<DailyGradeModel>> fetchStudentDailyGradeDetails(int studentId, String type, int page) async {
    try {
      final result = await iDataDataSource.fetchStudentDailyGradeDetails(studentId, type, page);
      di<DailyGradesProvider>().updateDailyGradesList(result);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<TimeTableModel>> fetchStudentTimeTable(int studentId) async {
    try {
      final result = await iDataDataSource.fetchStudentTimeTable(studentId);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<NewsModel>> fetchNewsData(int page) async {
    try {
      final result = await iDataDataSource.fetchNewsData(page);
      di<NewsProvider>().updateNewsList(result);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<AdBannerModel>> fetchAdData() async {
    try {
      final result = await iDataDataSource.fetchAdData();
      return result;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<HomeStudentModel>> fetchReportCardsData() async {
    try {
      final result = await iDataDataSource.fetchReportCardsData();
      for (var i = 0; i < result.length; i++) {
        for (var j = 0; j < result[i].details.length; j++) {
          result[i].details[j] = result[i].details[j].copyWith(imagePath: AllLists.imagesList[j]);
        }
      }
      return result;
    } catch (e) {
      rethrow;
    }
  }
}

import 'package:course_management_project/features/data/providers/attendance_provider.dart';
import 'package:course_management_project/features/data/providers/daily_grades_provider.dart';
import 'package:course_management_project/features/data/providers/transaction_provider.dart';
import 'package:course_management_project/features/data/providers/user_provider.dart';
import 'package:get_it/get_it.dart';

GetIt di = GetIt.instance;

Future<void> setupGetIt() async {
  di.registerSingleton(UserProvider());
  di.registerSingleton(AttendanceProvider());
  di.registerSingleton(TransactionProvider());
  di.registerSingleton(DailyGradesProvider());
}

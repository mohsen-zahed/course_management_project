part of 'home_bloc.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

final class HomeLoading extends HomeState {}

final class StudentsListSuccess extends HomeState {
  final List<StudentModel> studentsList;

  const StudentsListSuccess({required this.studentsList});
  @override
  List<Object> get props => [studentsList];
}

final class StudentsListFailure extends HomeState {
  final String errorMessage;

  const StudentsListFailure({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

final class AdBannerListLoading extends HomeState {}

final class AdBannerListSuccess extends HomeState {
  final List<AdBannerModel> adList;

  const AdBannerListSuccess({required this.adList});
}

final class AdBannerListFailure extends HomeState {
  final String errorMessage;
  final String? statusCode;

  const AdBannerListFailure({required this.errorMessage, this.statusCode});
}

class InfoCardsSummaryDataLoading extends HomeState {}

class InfoCardsSummaryDataSuccess extends HomeState {
  final List<HomeStudentModel> homeInfoList;

  const InfoCardsSummaryDataSuccess({required this.homeInfoList});
}

class InfoCardsSummaryDataFailure extends HomeState {
  final String errorMessage;

  const InfoCardsSummaryDataFailure({required this.errorMessage});
}

class StudentsHistoryRecordsLoading extends HomeState {}

class StudentsHistoryRecorddsSuccess extends HomeState {
  final List<Student> studentsHistoryList;

  const StudentsHistoryRecorddsSuccess({required this.studentsHistoryList});
}

class StudentsHistoryRecordsFailure extends HomeState {
  final String errorMessage;

  const StudentsHistoryRecordsFailure({required this.errorMessage});
}

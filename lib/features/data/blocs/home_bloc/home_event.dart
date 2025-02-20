part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class StudentsListRequested extends HomeEvent {}

class InfoCardsSummaryDataRequested extends HomeEvent {}

class AdBannerDataRequested extends HomeEvent {}

class StudentsHistoryRecordsRequested extends HomeEvent {}

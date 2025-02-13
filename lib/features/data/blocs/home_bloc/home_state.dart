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

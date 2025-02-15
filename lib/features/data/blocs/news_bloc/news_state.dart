part of 'news_bloc.dart';

sealed class NewsState extends Equatable {
  const NewsState();

  @override
  List<Object> get props => [];
}

final class NewsLoading extends NewsState {}

final class NewsSuccess extends NewsState {
  final List<NewsModel> newsList;

  const NewsSuccess({required this.newsList});
}

final class NewsFailure extends NewsState {
  final String errorMessage;
  final String? statusCode;

  const NewsFailure({required this.errorMessage, this.statusCode});
}

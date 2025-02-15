part of 'news_bloc.dart';

sealed class NewsEvent extends Equatable {
  const NewsEvent();

  @override
  List<Object> get props => [];
}

class NewsDataRequested extends NewsEvent {
  final int page;

  const NewsDataRequested({required this.page});
}

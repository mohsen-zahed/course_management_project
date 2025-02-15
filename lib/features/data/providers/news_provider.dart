import 'package:course_management_project/features/data/models/news_model.dart';
import 'package:flutter/material.dart';

class NewsProvider extends ChangeNotifier {
  List<NewsModel> newsList = [];
  updateNewsList(List<NewsModel> listInput) {
    if (newsList.isNotEmpty) {
      for (var news in newsList) {
        if (!newsList.any((element) => element.id == news.id)) {
          newsList.add(news);
        } else {
          final int index = newsList.indexOf(news);
          newsList.removeAt(index);
          newsList.insert(index, news);
        }
      }
    } else {
      newsList = listInput;
    }

    notifyListeners();
  }
}

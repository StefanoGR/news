import 'package:flutter/foundation.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:news/services/api.dart';

import 'article.dart';

class ArticlesHolder extends ChangeNotifier {

  ArticlesHolder(){
    Api().getHeadlines().then((value) => articles = value);
  }

  final List<Article> _articles = [];
  final Map<String, List<Article>> _articlesMap = Map();

  set articles(List<Article> news) {
    assert(news != null);
    _articles.clear();
    _articles.addAll(news);
    notifyListeners();
  }
  void addToArticlesMap(String key, List<Article> news) {
    assert(news != null);
    _articlesMap[key] = news;
    notifyListeners();
  }

  List<Article> getArticles(String category) => _articlesMap[category];

  List<Article> get articles => _articles;

}

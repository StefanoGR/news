import 'dart:async';

import 'package:news/services/api.dart';

import 'model/article.dart';

enum CategoriesEnum { main, business }

class NewsBloc {
  CategoriesEnum _marketDataEnum = CategoriesEnum.main;
  StreamController<CategoriesEnum> _screenController =
      new StreamController<CategoriesEnum>.broadcast();

  CategoriesEnum get marketDataEnum => _marketDataEnum;
  Function(CategoriesEnum mData) get _changeCategory => _screenController.sink.add;

  Stream<CategoriesEnum> get actualCategory => _screenController.stream;

  changeCategory(CategoriesEnum mData) {
    _marketDataEnum = mData;
    _changeCategory(_marketDataEnum);
  }

  dispose() {
    _screenController?.close();
    _articles?.close();
  }


  final Api _repository = Api();
  final StreamController<List<Article>> _articles =
  StreamController<List<Article>>();

  getNews() async {
    List<Article> response = await _repository.getHeadlines();
    _articles.sink.add(response);
  }

  StreamController<List<Article>> get articles => _articles;
}

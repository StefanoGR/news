import 'dart:async';

import 'package:news/services/api.dart';

import 'model/article.dart';

enum CategoriesEnum {
  general,
  business,
  entertainment,
  health,
  science,
  sports,
  technology
}

String categoryName(CategoriesEnum category) =>
    category.toString().split('.').last;

class NewsBloc {
  CategoriesEnum _actualCategory = CategoriesEnum.general;

  StreamController<CategoriesEnum> _screenController =
      new StreamController<CategoriesEnum>.broadcast();

  Function(CategoriesEnum mData) get _changeCategory =>
      _screenController.sink.add;

  Stream<CategoriesEnum> get actualCategory => _screenController.stream;

  changeCategory(int index) {
    _actualCategory = CategoriesEnum.values[index];
    _articles.sink.add(null);//Clear news
    _changeCategory(_actualCategory);
    getNews();
  }

  dispose() {
    _screenController?.close();
    _articles?.close();
  }

  final Api _repository = Api();
  final StreamController<List<Article>> _articles =
      StreamController<List<Article>>.broadcast();

  getNews() async {
    List<Article> response =
        await _repository.getHeadlines(category: categoryName(_actualCategory));
    _articles.sink.add(response);
  }

  Stream<List<Article>> get articles => _articles.stream;
}

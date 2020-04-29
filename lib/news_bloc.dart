import 'dart:async';

import 'package:hive/hive.dart';
import 'package:news/services/api.dart';
import 'package:news/services/db_repository.dart';

import 'model/article.dart';

enum AppScreen { main, favorites }

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
    category
        .toString()
        .split('.')
        .last;

class NewsBloc {
  final Api _repository = Api();
  final Db_Repository _dbRepository = Db_Repository();

  CategoriesEnum _actualCategory = CategoriesEnum.general;
  AppScreen _actualScreen = AppScreen.main;

  //Streams
  Stream<List<Article>> get articles => _articles.stream;

  Stream<CategoriesEnum> get actualCategory => _screenController.stream;

  Stream<AppScreen> get actualScreen => _actualScreenController.stream;

  final StreamController<CategoriesEnum> _screenController = StreamController<
      CategoriesEnum>.broadcast();
  final StreamController<List<Article>> _articles = StreamController<
      List<Article>>.broadcast();
  final StreamController<
      AppScreen> _actualScreenController = new StreamController<
      AppScreen>.broadcast();


  NewsBloc() {
    Hive.box<Article>(NewsBox).watch().forEach((element) {
      print(element.toString());
      _manageArticles();
    });
  }

  changeCategory(int index) {
    _actualCategory = CategoriesEnum.values[index];
    _articles.sink.add(null); //Clear news
    _screenController.sink.add(_actualCategory);
    getNews();
  }

  changeScreen(int index) {
    _actualScreen = AppScreen.values[index];
    _actualScreenController.sink.add(_actualScreen);
    _manageArticles();
  }

  _manageArticles(){

    if (AppScreen.favorites == _actualScreen) _articles.sink.add(
        _dbRepository.getArticles());
    else getNews();
  }
  getNews() async {
    List<Article> response =
    await _repository.getHeadlines(category: categoryName(_actualCategory));
    _articles.sink.add(response);
  }

  dispose() {
    _screenController?.close();
    _articles?.close();
    _actualScreenController?.close();
  }


}

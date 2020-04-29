import 'package:hive/hive.dart';
import 'package:news/model/article.dart';

const NewsBox = 'newsBox';

class Db_Repository {
  Box<Article> favoritesNews = Hive.box(NewsBox);

  addArticle(Article article) => favoritesNews.put(article.id, article);

  List<Article> getArticles(){
    return  favoritesNews.values.toList();
  }

  watch() => favoritesNews.watch();
}

import 'package:flutter/material.dart';
import 'package:news/news_bloc.dart';
import 'package:news/screens/news.dart';
import 'package:news/services/db_repository.dart';
import 'package:news/themes/theme.dart';
import 'package:provider/provider.dart';

import 'model/article.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ArticleAdapter());
  await Hive.openBox<Article>(NewsBox);
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<NewsBloc>(create: (_) => NewsBloc()),
      ],
      child: MaterialApp(
        title: 'News App',
        theme: appTheme,
        initialRoute: '/',
        routes: {
          '/': (context) => News(),
//          '/fav': (context) => FavNews(),
//          '/search': (context) => Search(),
        },
      ),
    );
  }
}

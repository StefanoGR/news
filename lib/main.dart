import 'package:flutter/material.dart';
import 'package:news/news_bloc.dart';
import 'package:news/screens/news.dart';
import 'package:news/themes/theme.dart';
import 'package:provider/provider.dart';

import 'model/articlesHolder.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ArticlesHolder()),
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

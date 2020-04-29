import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:news/news_bloc.dart';
import 'package:news/screens/newslist.dart';
import 'package:provider/provider.dart';

class Test {
  final String name;

  Test(this.name);

  Test.fromJson(Map<String, dynamic> json) : name = json['name'];

  Map<String, dynamic> toJson() => {
        'name': name,
      };
}

class News extends StatefulWidget {
  News() : super();

  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> with TickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: CategoriesEnum.values.length, vsync: this);
    _tabController.addListener(_handleTabSelection);

    final bloc = Provider.of<NewsBloc>(context, listen: false);
    bloc.getNews();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<NewsBloc>(context);
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(
          "NEWS",
          style: Theme.of(context).textTheme.headline1,
        ),
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(12.0),
            child: StreamBuilder<AppScreen>(
              stream: bloc.actualScreen,
              builder: (context, AsyncSnapshot<AppScreen> snapshot) {
                return topBar(snapshot.data);
              },
            )),
      ),
      body: NewsList(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.chrome_reader_mode),
            title: Text('Notizie'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            title: Text('Preferiti'),
          )
        ],
        onTap: (index) => bloc.changeScreen(index),
      ),
    ));
  }

  void _handleTabSelection() async {
    if (!_tabController.indexIsChanging) {
      final bloc = Provider.of<NewsBloc>(context, listen: false);
      bloc.changeCategory(_tabController.index);
    } else
      print("Tab is switching..from active to inactive");
  }

  get categories => CategoriesEnum.values
      .map((e) => Tab(text: categoryName(e).toUpperCase()))
      .toList();

  Widget topBar(AppScreen appScreen) {
    switch (appScreen) {
      case AppScreen.favorites:
        return Container();
      case AppScreen.main:
      default:
        return TabBar(
          isScrollable: true,
          labelColor: Colors.black,
          tabs: categories,
          controller: _tabController,
        );
    }
  }
}

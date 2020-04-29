import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:news/components/news_item.dart';
import 'package:news/model/article.dart';
import 'package:news/model/articlesHolder.dart';
import 'package:news/news_bloc.dart';
import 'package:news/services/api.dart';
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
    _tabController = TabController(length: CategoriesEnum.values.length, vsync: this);
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "NEWS",
          style: Theme.of(context).textTheme.headline1,
        ),
        bottom: TabBar(
          isScrollable: true,
          labelColor: Colors.black,
          tabs: categories,
          controller: _tabController,
        ),
      ),
      body: new Container(
          child: new Center(
        child: RefreshIndicator(
            onRefresh: () => _refresh(),
            child: StreamBuilder<List<Article>>(
                stream: bloc.articles,
                builder: (context, AsyncSnapshot<List<Article>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, position) =>
                            NewsItem(snapshot.data[position]));
                  } else
                    return CircularProgressIndicator();
                })),
      )),
    );
  }

  Future<bool> _refresh() async {
    _handleTabSelection();
    return true;
  }

  void _handleTabSelection() async {
    if (!_tabController.indexIsChanging) {
      final bloc = Provider.of<NewsBloc>(context, listen: false);
      bloc.changeCategory(_tabController.index);
    }else print("Tab is switching..from active to inactive");
  }

  get categories => CategoriesEnum.values
      .map((e) => Tab(text: categoryName(e).toUpperCase()))
      .toList();
}

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

  Test.fromJson(Map<String, dynamic> json)
      : name = json['name'];

  Map<String, dynamic> toJson() => {
    'name' : name,
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
    _tabController = getTabController();
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
          labelColor: Colors.black,
          tabs: [getTab("Headlines"), getTab("business")],
          controller: _tabController,
        ),
      ),
      body: new Container(
          child: new Center(
              child: TabBarView(controller: _tabController, children: [
        RefreshIndicator(
            onRefresh: () => _refresh(context),
            child: Consumer<ArticlesHolder>(
              builder: (context, holder, child) {
                return ListView.builder(
                    itemCount: holder.articles.length,
                    itemBuilder: (context, position) => Text(
                          holder.articles[position].title,
                          style: Theme.of(context).textTheme.headline1,
                        ));
              },
            )),
        RefreshIndicator(
            onRefresh: () => _refresh(context),
            child:

            StreamBuilder<List<Article>>(
              stream: bloc.articles.stream,
              builder: (context, AsyncSnapshot<List<Article>> snapshot) {
                if (snapshot.hasData) {
//                  if (snapshot.data.length > 0) {
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, position) =>
                            NewsItem(snapshot.data[position]));
//                  }
                }else
                  return Container();
              }))
      ]))),
    );
  }

  TabController getTabController() {
    return TabController(length: 2, vsync: this);
  }

  Tab getTab(String category) {
    return Tab(
      text: category,
    );
  }

  Future<bool> _refresh(BuildContext context) async {
    await Api().fetchArticles(context: context, category: "business");
    return true;
  }

  void _handleTabSelection() async {
    if (_tabController.index == 1)
      await Api().fetchArticles(context: context, category: "business");
  }
}

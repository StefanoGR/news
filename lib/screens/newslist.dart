import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:news/components/news_item.dart';
import 'package:news/model/article.dart';
import 'package:news/news_bloc.dart';
import 'package:news/services/api.dart';
import 'package:provider/provider.dart';

class NewsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<NewsBloc>(context);
    return Center(
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
            }));
  }
}

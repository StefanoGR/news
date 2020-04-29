import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news/model/article.dart';
import 'package:news/model/articlesHolder.dart';
import 'package:provider/provider.dart';

class NewsItem extends StatelessWidget {
  final Article article;

  NewsItem(this.article, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: CachedNetworkImage(
                imageUrl: article.urlToImage,
                placeholder: (context, url) =>
                    center(CircularProgressIndicator()),
                errorWidget: (context, url, error) => center(Icon(Icons.image)),
              ),
            ),
            Text(article.author != null ? article.author : ""),
            const SizedBox(
              height: 8,
            ),
            Text(article.title),
            const SizedBox(
              height: 8,
            ),
            Text(article.publishedAt)
          ],
        ));
  }

  center(Widget widget) => Container(height: 200,color: Colors.grey[200], child: Center(child: widget));
}

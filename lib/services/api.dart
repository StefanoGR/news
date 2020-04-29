import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:dio_flutter_transformer/dio_flutter_transformer.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:news/model/article.dart';
import 'package:news/model/articlesHolder.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

const String API = "https://newsapi.org/v2/";
const String TOP_HEADLINES = "top-headlines";
const String TOKEN = "cd6e66ea3fd84a6ea1583b6af5c30514";

class Api {
  final Dio dio = Dio();
  final DioCacheManager dioCache = DioCacheManager(CacheConfig(baseUrl: API));

  Api() {
    dio.options.baseUrl = API;
    dio.options.connectTimeout = 5000;
    dio.transformer = FlutterTransformer();
    if (!kIsWeb) dio.interceptors.add(dioCache.interceptor);

    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
      if (options.extra.isNotEmpty) {
        options.queryParameters.addAll(options.extra);
      }
      options.queryParameters['apiKey'] = TOKEN;
      options.queryParameters['country'] = "it";
      return options;
    }, onResponse: (Response response) async {
      // Do something with response data
      return response; // continue
    }, onError: (DioError e) async {
      // Do something with response error
      return e; //continue
    }));
  }

  Future<List<Article>> getHeadlines({String category, String query}) async {
    Response response = await dio.get(TOP_HEADLINES,
        options: buildCacheOptions(Duration(seconds: 120),
            options: Options(extra: createExtras(category, query))));
    return response.data['articles']
        .map<Article>((json) => Article.fromJson(json))
        .toList();
  }

  Map<String, dynamic> createExtras(String category, String query) {
    LinkedHashMap<String, dynamic> map = LinkedHashMap();
    if (category != null) map['category'] = category;
    if (query != null) map['q'] = query;
    return map;
  }
}

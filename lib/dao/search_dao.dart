import 'dart:convert';

import 'package:ctrip/model/search_model.dart';
import "package:http/http.dart" as http;

class SearchDao {
  static Future<SearchModel> fetch(String url, String text) async {
    final http.Response responese = await http.get(url);

    if (responese.statusCode == 200) {
      Utf8Decoder decoder = new Utf8Decoder();
      var res = json.decode(decoder.convert(responese.bodyBytes));

      // 优化: 比对关键字来处理请求竞态
      SearchModel model = SearchModel.fromJson(res);
      model.keyword = text;
      return model;
    } else {
      throw Exception("Failed to fetch search page");
    }
  }
}

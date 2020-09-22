import "dart:async";
import "dart:convert";
import "../model/home_model.dart";
import 'package:http/http.dart' as http;

const String HOME_URL =
    "https://www.devio.org/io/flutter_app/json/home_page.json";

class HomeDao {
  static Future<HomeModel> fetch() async {
    final http.Response response = await http.get(HOME_URL);
    if (response.statusCode == 200) {
      // fix中文乱码
      Utf8Decoder decoder = new Utf8Decoder();

      var res = json.decode(decoder.convert(response.bodyBytes));

      return HomeModel.fromJson(res);
    } else {
      throw Exception("Failed to fetch home page");
    }
  }
}

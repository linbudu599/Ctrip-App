import "dart:async";
import "dart:convert";
import "package:ctrip/model/travel_tab_model.dart";
import "package:ctrip/utils/constants.dart";
import 'package:http/http.dart' as http;

class TravelTabDao {
  static Future<TravelTabModel> fetch() async {
    final response = await http.get(TRAVEL_TABS);
    if (response.statusCode == 200) {
      Utf8Decoder utf8decoder = Utf8Decoder();
      var result = json.decode(utf8decoder.convert(response.bodyBytes));
      return TravelTabModel.fromJson(result);
    } else {
      throw Exception('Failed to load travel_page.json');
    }
  }
}

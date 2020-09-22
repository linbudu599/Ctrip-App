class ConfigModel {
  final String searchURL;

  ConfigModel({this.searchURL});

  factory ConfigModel.fromJson(Map<String, dynamic> json) {
    return ConfigModel(searchURL: json['searchURL']);
  }
}

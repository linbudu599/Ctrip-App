import "config_model.dart";
import "common_model.dart";
import "grid_nav_model.dart";
import "sales_box_model.dart";

class HomeModel {
  final ConfigModel config;
  final List<CommonModel> bannerList;
  final List<CommonModel> localNavList;
  final List<CommonModel> subNavList;
  final GridNavModel gridNav;
  final SalesBoxModel salesBox;

  HomeModel(
      {this.config,
      this.bannerList,
      this.localNavList,
      this.gridNav,
      this.subNavList,
      this.salesBox});

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    dynamic localNavListJSON = json["localNavList"] as List;
    dynamic bannerListJSON = json["bannerList"] as List;
    dynamic subNavListJSON = json["subNavList"] as List;

    List<CommonModel> localNavList =
        localNavListJSON.map((i) => CommonModel.fromJson(i)).toList();
    List<CommonModel> bannerList =
        bannerListJSON.map((i) => CommonModel.fromJson(i)).toList();
    List<CommonModel> subNavList =
        subNavListJSON.map((i) => CommonModel.fromJson(i)).toList();

    return HomeModel(
        localNavList: localNavList,
        bannerList: bannerList,
        subNavList: subNavList);
  }
}

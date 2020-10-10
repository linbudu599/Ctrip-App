import "package:flutter/material.dart";

const String HOME_URL =
    "https://www.devio.org/io/flutter_app/json/home_page.json";

const int APPBAR_SCROLL_OFFSET_MAX = 100;
const String SEARCH_BAR_DEFAULT_TEXT = '网红打卡地 景点 酒店 美食';

const String SEARCH_URL =
    'https://m.ctrip.com/restapi/h5api/globalsearch/search?source=mobileweb&action=mobileweb&keyword=';

const String TRAVEL_TABS =
    "https://www.devio.org/io/flutter_app/json/travel_page.json";

const String TRAVEL_URL =
    'https://m.ctrip.com/restapi/soa2/16189/json/searchTripShootListForHomePageV2?_fxpcqlniredt=09031014111431397988&__gw_appid=99999999&__gw_ver=1.0&__gw_from=10650013707&__gw_platform=H5';

const int TRAVEl_PAGE_COUNT = 10;

const String SEARCH_HINT = "搜索";

const String ACCOUNT_PAGE = "https://m.ctrip.com/webapp/myctrip/";

const List<String> TYPES = [
  'channelgroup',
  'channelgs',
  'channelplane',
  'channeltrain',
  'cruise',
  'district',
  'food',
  'hotel',
  'huodong',
  'shop',
  'sight',
  'ticket',
  'travelgroup'
];

const List<String> CHANNEL_TYPES = [
  'channelgroup',
  'channelgs',
  'channelplane',
  'channeltrain',
];

const List<Map<String, dynamic>> NAVIGATOR_ITEM = [
  {"title": "首页", "icon": Icons.home},
  {"title": "搜索", "icon": Icons.search},
  {"title": "旅拍", "icon": Icons.camera_alt},
  {"title": "我的", "icon": Icons.account_circle}
];

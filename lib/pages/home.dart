import "package:flutter/material.dart";
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:ctrip/pages/search.dart';

import 'package:ctrip/model/common_model.dart';
import 'package:ctrip/model/grid_nav_model.dart';
import 'package:ctrip/model/home_model.dart';
import 'package:ctrip/model/sales_box_model.dart';
import "package:ctrip/dao/home_dao.dart";

import "package:ctrip/widget/grid_nav.dart";
import "package:ctrip/widget/local_nav.dart";
import "package:ctrip/widget/sub_nav.dart";
import "package:ctrip/widget/sales_box.dart";
import "package:ctrip/widget/loading.dart";
import "package:ctrip/widget/search_bar.dart";
import 'package:ctrip/widget/webview.dart';

import "package:ctrip/utils/constants.dart";

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double appBarOpacity = 0;
  List<CommonModel> localNavList = [];
  List<CommonModel> bannerList = [];
  GridNavModel gridNavModel;
  List<CommonModel> subNavList = [];
  SalesBoxModel salesBox;

  bool _loading = true;

  // 顶部AppBar随着滚动透明度变化
  void _onScroll(double offset) {
    double alpha = offset / APPBAR_SCROLL_OFFSET_MAX;
    if (alpha < 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }

    setState(() {
      appBarOpacity = alpha;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchSync();
  }

  Future<Null> _fetchSync() async {
    try {
      HomeModel model = await HomeDao.fetch();
      setState(() {
        localNavList = model.localNavList;
        gridNavModel = model.gridNav;
        subNavList = model.subNavList;
        salesBox = model.salesBox;
        bannerList = model.bannerList;
      });
    } catch (e) {
      print(e.toString());
    } finally {
      setState(() {
        _loading = false;
      });
    }

    return null;
  }

  void _scrollTip({bool tipOnTop = true}) {
    Fluttertoast.showToast(
        msg: tipOnTop ? "下拉加载更多" : "到底了~",
        toastLength: Toast.LENGTH_SHORT,
        gravity: tipOnTop ? ToastGravity.TOP : ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.black38,
        textColor: Colors.white,
        fontSize: 14.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xfff2f2f2),
        body: LoadingContainer(
            isLoading: _loading,
            coverPage: false,
            child: Stack(
              children: <Widget>[
                MediaQuery.removePadding(
                    removeTop: true,
                    context: context,
                    child: RefreshIndicator(
                      onRefresh: _fetchSync,
                      child: NotificationListener(
                          onNotification: (scrollNotification) {
                            // 只监听最外层的ListView滚动(depth)且滚动条更新(滚动中)
                            if (scrollNotification
                                    is ScrollUpdateNotification &&
                                scrollNotification.depth == 0) {
                              _onScroll(scrollNotification.metrics.pixels);
                            }
                            if (scrollNotification is ScrollEndNotification &&
                                scrollNotification.metrics.extentAfter == 0) {
                              print("Scroll to Bottom");
                              _scrollTip(tipOnTop: false);
                            }
                            // TODO: Refresh Load More Tooltip
                            if (scrollNotification is ScrollEndNotification &&
                                scrollNotification.metrics.extentBefore == 0) {
                              print("Scroll to Top");
                              _scrollTip();
                            }

                            return true;
                          },
                          child: _listView),
                    )),
                _appBar
              ],
            )));
  }

  Widget get _banner {
    return Container(
        height: 160,
        child: Swiper(
          itemCount: bannerList.length,
          autoplay: true,
          itemBuilder: (BuildContext context, int idx) {
            String imgURL = bannerList[idx].icon;

            // avoid [Inscure Resources] warning
            if (imgURL.startsWith("http://")) {
              imgURL = imgURL.replaceAll("http://", "https://");
            }

            return GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  CommonModel model = bannerList[idx];
                  return WebView(
                    url: model.url,
                    title: model.title,
                    hideAppBar: model.hideAppBar,
                  );
                }));
              },
              child: Image.network(
                imgURL,
                fit: BoxFit.fill,
              ),
            );
          },
          pagination: SwiperPagination(),
        ));
  }

  Widget get _appBar {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              //AppBar 渐变遮罩背景
              colors: [Color(0x66000000), Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            height: 80.0,
            decoration: BoxDecoration(
              color:
                  Color.fromARGB((appBarOpacity * 255).toInt(), 255, 255, 255),
            ),
            child: SearchBar(
              searchBarType: appBarOpacity > 0.2
                  ? SearchBarType.homeLight
                  : SearchBarType.home,
              handleInputBoxClick: _jumpToSearch,
              handleSpeackClick: _jumpToSpeak,
              defaultText: SEARCH_BAR_DEFAULT_TEXT,
              handleLeftBtnClick: () {},
            ),
          ),
        ),
        // 滑动过程中的阴影
        Container(
            height: appBarOpacity > 0.2 ? 0.5 : 0,
            decoration: BoxDecoration(
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 0.5)]))
      ],
    );
  }

  Widget get _listView {
    return ListView(
      children: <Widget>[
        _banner,
        Padding(
          padding: EdgeInsets.fromLTRB(7, 4, 7, 4),
          child: LocalNav(localNavList: localNavList),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
          child: GridNav(gridNavModel: gridNavModel),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
          child: SubNav(subNavList: subNavList),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
          child: SalesBox(salesBox: salesBox),
        ),
        Container(height: 5)
      ],
    );
  }

  _jumpToSearch() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SearchPage()));
  }

  _jumpToSpeak() {}
}

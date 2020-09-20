import "package:flutter/material.dart";
import 'package:flutter_swiper/flutter_swiper.dart';

const int APPBAR_SCROLL_OFFSET_MAX = 100;

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double appBarOpacity = 0;

  List<String> _imageURLs = [
    "http://www.devio.org/io/flutter_app/img/banner/100h10000000q7ght9352.jpg",
    "https://dimg04.c-ctrip.com/images/300h0u000000j05rnD96B_C_500_280.jpg",
    "http://pages.ctrip.com/hotel/201811/jdsc_640es_tab1.jpg",
    "https://dimg03.c-ctrip.com/images/fd/tg/g1/M03/7E/19/CghzfVWw6OaACaJXABqNWv6ecpw824_C_500_280_Q90.jpg"
  ];

  void _onScroll(double offset) {
    print(offset);
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
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        MediaQuery.removePadding(
            removeTop: true,
            context: context,
            // 监听滚动
            child: NotificationListener(
              onNotification: (scrollNotification) {
                // 只监听最外层的ListView滚动
                if (scrollNotification is ScrollUpdateNotification &&
                    scrollNotification.depth == 0) {
                  _onScroll(scrollNotification.metrics.pixels);
                }
              },
              child: ListView(
                children: <Widget>[
                  Container(
                      height: 160,
                      child: Swiper(
                        itemCount: _imageURLs.length,
                        autoplay: true,
                        itemBuilder: (BuildContext context, int idx) {
                          return Image.network(_imageURLs[idx],
                              fit: BoxFit.fill);
                        },
                        pagination: SwiperPagination(),
                      )),
                  Container(height: 800, child: ListTile(title: Text("芜湖!")))
                ],
              ),
            )),
        Opacity(
            opacity: appBarOpacity,
            child: Container(
                height: 80,
                decoration: BoxDecoration(color: Colors.white),
                child: Center(
                    child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text("首页")))))
      ],
    ));
  }
}

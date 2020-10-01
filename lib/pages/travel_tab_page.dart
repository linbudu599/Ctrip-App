import "package:flutter/material.dart";

import 'package:ctrip/widget/loading.dart';
import 'package:ctrip/widget/webview.dart';

import "package:ctrip/utils/constants.dart";

import 'package:ctrip/model/travel_model.dart';
import 'package:ctrip/dao/travel_dao.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class TravelTabPage extends StatefulWidget {
  final String travelURL;
  final String groupChannelCode;

  TravelTabPage({Key key, this.travelURL, this.groupChannelCode})
      : super(key: key);

  @override
  _TravelTabPageState createState() => _TravelTabPageState();
}

class _TravelTabPageState extends State<TravelTabPage>
    // 缓存页面
    with
        AutomaticKeepAliveClientMixin {
  List<TravelItem> travelItems;
  int pageIdx = 1;
  bool isLoading = true;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _loadData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadData(loadMore: true);
      }
    });
    super.initState();
  }

  // 同时供下拉刷新与首屏数据获取使用
  Future<Null> _loadData({loadMore = false}) {
    if (loadMore) {
      pageIdx++;
    } else {
      pageIdx = 1;
    }
    TravelDao.fetch(widget.travelURL ?? TRAVEL_URL, params,
            widget.groupChannelCode, pageIdx, TRAVEl_PAGE_COUNT)
        .then((TravelItemModel model) {
      setState(() {
        List<TravelItem> items = _filterItems(model.resultList);
        travelItems == null ? travelItems = items : travelItems.addAll(items);
      });
    }).catchError((e) {
      print(e.toString());
    }).whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });
    return null;
  }

  Future<Null> _handleRefresh() async => _loadData();

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
        body: LoadingContainer(
            child: RefreshIndicator(
              onRefresh: _handleRefresh,
              child: MediaQuery.removePadding(
                context: context,
                child: StaggeredGridView.countBuilder(
                  controller: _scrollController,
                  crossAxisCount: 4,
                  itemCount: travelItems?.length ?? 0,
                  itemBuilder: (BuildContext context, int index) =>
                      TravelItemBuilder(index: index, item: travelItems[index]),
                  staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
                ),
              ),
            ),
            isLoading: isLoading,
            coverPage: true));
  }

  List<TravelItem> _filterItems(List<TravelItem> resultList) {
    if (resultList == null) {
      return [];
    }

    List<TravelItem> filteredItems = [];
    resultList.forEach((item) {
      if (item.article != null) {
        filteredItems.add(item);
      }
    });
    return filteredItems;
  }

  @override
  // 始终保活
  bool get wantKeepAlive => true;
}

class TravelItemBuilder extends StatelessWidget {
  final TravelItem item;
  final int index;

  const TravelItemBuilder({Key key, this.item, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (item.article.urls != null && item.article.urls.length > 0) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      WebView(url: item.article.urls[0].h5Url, title: "详情")));
        }
      },
      child: Card(
        child: PhysicalModel(
          color: Colors.transparent,
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.circular(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _itemImage(),
              Container(
                padding: EdgeInsets.all(6),
                child: Text(item.article.articleTitle,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14, color: Colors.black87)),
              ),
              _infoText()
            ],
          ),
        ),
      ),
    );
  }

  Widget _itemImage() {
    return Stack(
      children: <Widget>[
        Image.network(item.article.images[0]?.dynamicUrl),
        Positioned(
            bottom: 20,
            left: 10,
            child: Container(
              padding: EdgeInsets.fromLTRB(5, 1, 8, 3),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(right: 2),
                    child:
                        Icon(Icons.location_on, color: Colors.white, size: 14)),
                LimitedBox(
                  maxWidth: 130,
                  child: Text(_position(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white)),
                )
              ]),
            ))
      ],
    );
  }

  String _position() {
    List<Pois> pois = item.article.pois;

    return pois == null || pois.length == 0 ? "未知" : pois[0]?.poiName ?? "未知";
  }

  Widget _infoText() {
    return Container(
      padding: EdgeInsets.fromLTRB(6, 0, 6, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(children: <Widget>[
            // 头像框裁剪
            PhysicalModel(
                color: Colors.transparent,
                clipBehavior: Clip.antiAlias,
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                    item.article.author?.coverImage?.dynamicUrl,
                    width: 26,
                    height: 26)),
            Container(
              padding: EdgeInsets.all(5),
              width: 90,
              child: Text(
                item.article.author?.nickName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12),
              ),
            )
          ]),
          Row(
            children: <Widget>[
              Icon(
                Icons.thumb_up,
                size: 16,
                color: Colors.grey,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(3, 0, 2, 0),
                child: Text(
                  item.article.likeCount.toString(),
                  style: TextStyle(fontSize: 12),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

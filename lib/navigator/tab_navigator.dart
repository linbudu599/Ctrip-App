import "package:flutter/material.dart";
import "../pages/home.dart";
import "../pages/search.dart";
import "../pages/camera.dart";
import "../pages/account.dart";

class BotNavigationView extends StatefulWidget {
  BotNavigationView({Key key}) : super(key: key);

  @override
  _BotNavigationViewState createState() => _BotNavigationViewState();
}

class _BotNavigationViewState extends State<BotNavigationView>
    with SingleTickerProviderStateMixin {
  final Color _defaultColor = Colors.grey;
  final Color _activeColor = Colors.blue;
  int _idx = 0;

  PageController _controller = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(BotNavigationView oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 用于页面间滚动的widget
      body: PageView(
        pageSnapping: false,
        reverse: false,
        onPageChanged: (int i) {
          // print(i);
        },
        controller: _controller,
        children: <Widget>[
          HomePage(),
          SearchPage(hideLeft: true),
          CameraPage(),
          MyPage(),
        ],
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _idx,
          onTap: (int i) {
            _controller.jumpToPage(i);
            setState(() {
              _idx = i;
            });
          },
          type: BottomNavigationBarType.fixed,
          items: [
            // TODO: should be used like this
            // _buildItem(Icons.home, "首页", 0),
            _buildItem("首页", 0),
            _buildItem("搜索", 1),
            _buildItem("旅拍", 2),
            _buildItem("我的", 3),
          ]),
    );
  }

  BottomNavigationBarItem _buildItem(
    String title,
    int idx,
  ) {
    IconData defaultIcon;
    IconData activeIcon;
    bool isSelected = _idx == idx;

    switch (idx) {
      case 0:
        defaultIcon = Icons.home;
        break;
      case 1:
        defaultIcon = Icons.search;
        break;
      case 2:
        defaultIcon = Icons.camera_alt;
        break;
      case 3:
        defaultIcon = Icons.account_circle;
        break;
    }
// FIXME: 直接传入IconData数据不起作用
    return BottomNavigationBarItem(
      icon: Icon(defaultIcon,
          // color: _defaultColor, size: isSelected ? 22.0 : 34.0),
          color: _defaultColor),
      activeIcon: Icon(defaultIcon, color: _activeColor),
      title: Text(title,
          style: TextStyle(color: !isSelected ? _defaultColor : _activeColor)),
    );
  }
}

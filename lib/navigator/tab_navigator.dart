import "package:flutter/material.dart";
import "package:ctrip/pages/home.dart";
import "package:ctrip/pages/search.dart";
import "package:ctrip/pages/account.dart";
import "package:ctrip/pages/travel.dart";

/*
 * 常用的路由方案: 使用PageController的实例进行控制 
 * 在PageView中注册页面后, 使用jumpToPage(i)进行控制
 * 基于pageCount(下面的_idx)与PageController来使得保持同步
 * 使用SingleTickerProviderStateMixin来实现动画切换效果
 * 这样的话只会允许同时间一处setState重绘请求
 */

class BotNavigationView extends StatefulWidget {
  BotNavigationView({Key key}) : super(key: key);

  @override
  _BotNavigationViewState createState() => _BotNavigationViewState();
}

class _BotNavigationViewState extends State<BotNavigationView>
    with SingleTickerProviderStateMixin {
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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        pageSnapping: false,
        reverse: false,
        onPageChanged: (int i) {},
        controller: _controller,
        children: <Widget>[
          HomePage(),
          SearchPage(hideLeft: true),
          TravelPage(),
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
            _buildItem("首页", 0, icon: Icons.home),
            _buildItem("搜索", 1, icon: Icons.search),
            _buildItem("旅拍", 2, icon: Icons.camera_alt),
            _buildItem("我的", 3, icon: Icons.account_circle),
          ]),
    );
  }

  BottomNavigationBarItem _buildItem(String title, int idx, {IconData icon}) {
    final Color _defaultColor = Colors.grey;
    final Color _activeColor = Colors.blue;
    // bool isSelected = _idx == idx;
    return BottomNavigationBarItem(
      icon: Icon(icon, color: _defaultColor),
      activeIcon: Icon(icon, color: _activeColor),
      label: title,
    );
  }
}

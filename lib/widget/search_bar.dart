import "package:flutter/material.dart";

// mormal 搜索状态
enum SearchBarType { home, normal, homeLight }

class SearchBar extends StatefulWidget {
  // 是否禁止
  final bool enable;
  final bool hideLeft;
  final SearchBarType searchBarType;
  // 提示文案
  final String hint;
  final String defaultText;
  final void Function() handleLeftBtnClick;
  final void Function() handleRightBtnClick;
  final void Function() handleSpeackClick;
  final void Function() handleInputBoxClick;
  // typedef ValueChanged<T> = void Function(T value)
  // 内容变化回调
  final ValueChanged<String> onChanged;

  SearchBar(
      {Key key,
      this.enable = true,
      this.hideLeft,
      this.searchBarType = SearchBarType.normal,
      this.hint,
      this.defaultText,
      this.handleLeftBtnClick,
      this.handleRightBtnClick,
      this.handleSpeackClick,
      this.handleInputBoxClick,
      this.onChanged})
      : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  bool showClearButton = false;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    if (widget.defaultText != null) {
      setState(() {
        // 设置进入时的默认文字
        _controller.text = widget.defaultText;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.searchBarType == SearchBarType.normal
        ? _normalSearchBarGener()
        : _homeSearchBarGener();
  }

  _tapWrapper(Widget child, void Function() cb) {
    return GestureDetector(
      onTap: () {
        if (cb != null) cb();
      },
      child: child,
    );
  }

  Widget _inputBox() {
    Color inputBoxColor;
    Color iconColor;
    bool isNormal = widget.searchBarType == SearchBarType.normal;

    inputBoxColor = isNormal ? Colors.white : Color(int.parse("0xffEDEDED"));
    iconColor = isNormal ? Color(0xffA9A9A9) : Colors.blue;

    return Container(
      height: 30,
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      decoration: BoxDecoration(
          color: inputBoxColor,
          borderRadius: BorderRadius.circular(isNormal ? 5 : 15)),
      child: Row(
        children: <Widget>[
          Icon(Icons.search, size: 20, color: iconColor),
          Expanded(
              flex: 1,
              child: isNormal
                  ? TextField(
                      controller: _controller,
                      onChanged: _onChanged,
                      autofocus: true,
                      style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black,
                          fontWeight: FontWeight.w300),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                          border: InputBorder.none,
                          hintText: widget.hint ?? "",
                          hintStyle: TextStyle(fontSize: 15)))
                  : _tapWrapper(
                      Container(
                        child: Text(widget.defaultText,
                            style: TextStyle(fontSize: 13, color: Colors.grey)),
                      ),
                      widget.handleInputBoxClick)),
          showClearButton
              ? _tapWrapper(Icon(Icons.clear, size: 22, color: Colors.grey),
                  () {
                  setState(() {
                    _controller.clear();
                  });
                  _onChanged("");
                })
              : _tapWrapper(
                  Icon(Icons.mic,
                      size: 22, color: isNormal ? Colors.blue : Colors.grey),
                  widget.handleSpeackClick)
        ],
      ),
    );
  }

  Widget _normalSearchBarGener() {
    return Container(
      child: Row(
        children: <Widget>[
          _tapWrapper(
              Container(
                  padding: EdgeInsets.fromLTRB(6, 5, 10, 5),
                  child: widget?.hideLeft ?? false
                      ? null
                      : Icon(Icons.arrow_back_ios,
                          color: Colors.grey, size: 26)),
              widget.handleLeftBtnClick),
          Expanded(
            flex: 1,
            child: _inputBox(),
          ),
          _tapWrapper(
              Container(
                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: Icon(Icons.comment, color: _homeFrontColor(), size: 26),
              ),
              widget.handleRightBtnClick)
        ],
      ),
    );
  }

  Widget _homeSearchBarGener() {
    return Container(
      padding: EdgeInsets.fromLTRB(6, 5, 5, 5),
      child: Row(
        children: <Widget>[
          _tapWrapper(
              Container(
                  padding: EdgeInsets.fromLTRB(6, 5, 10, 5),
                  child: Row(
                    children: <Widget>[
                      Text(
                        "上海",
                        style:
                            TextStyle(color: _homeFrontColor(), fontSize: 14),
                      ),
                      Icon(Icons.expand_more,
                          color: _homeFrontColor(), size: 22)
                    ],
                  )),
              widget.handleLeftBtnClick),
          Expanded(
            flex: 1,
            child: _inputBox(),
          ),
          _tapWrapper(
              Container(
                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: Text("搜索",
                    style: TextStyle(fontSize: 17, color: Colors.blue)),
              ),
              widget.handleRightBtnClick)
        ],
      ),
    );
  }

  void _onChanged(String text) {
    setState(() {
      showClearButton = text.length > 0;
    });

    if (widget.onChanged != null) {
      widget.onChanged(text);
    }
  }

// 前景色
  Color _homeFrontColor() {
    return widget.searchBarType == SearchBarType.homeLight
        ? Colors.black54
        : Colors.white;
  }
}

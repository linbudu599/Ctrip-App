import "package:flutter/material.dart";

class LoadingContainer extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final bool coverPage;

  const LoadingContainer(
      {Key key,
      @required this.child,
      this.isLoading = false,
      @required this.coverPage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return coverPage
        ? (Stack(
            children: <Widget>[child, isLoading ? _loadingView : Container()],
          ))
        : (isLoading ? _loadingView : child);
  }

  Widget get _loadingView {
    return Center(child: CircularProgressIndicator());
  }
}

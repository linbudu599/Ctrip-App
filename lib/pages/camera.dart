import "package:flutter/material.dart";

class CameraPage extends StatefulWidget {
  CameraPage({Key key}) : super(key: key);

  @override
  CameraPageState createState() => CameraPageState();
}

class CameraPageState extends State<CameraPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Text("旅拍"),
    ));
  }
}

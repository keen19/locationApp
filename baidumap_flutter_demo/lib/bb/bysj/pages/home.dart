import 'package:flutter/material.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin{
  @override
  Widget build(BuildContext context) {
    return Text("首页");
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

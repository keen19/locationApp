import 'package:flutter/material.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage>with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return Text("分类");
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}



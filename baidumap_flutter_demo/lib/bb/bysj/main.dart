import 'package:flutter/material.dart';
import 'pages/settings.dart';
import 'pages/category.dart';
import 'pages/home.dart';
import '../basic.dart';
import 'monitor.dart';



class Tables extends StatefulWidget {
  //Tables({Key key}) : super(key: key);
 /* String username;
  Tables(this.username);*/

  @override
  _TablesState createState() => _TablesState();
}

class _TablesState extends State<Tables> {

  /*String username='';
  _TablesState(this.username);*/

  int _currentIndex = 0;

  ///定义底部按钮
  final items = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: "首页",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      label: "呼救",
    ),

  ];

  final pageController = PageController();

  void onTap(int index){
    pageController.jumpToPage(index);
  }
  void onPageChanged(int index){
    setState(() {
      _currentIndex=index;
    });
  }

  final _pageList = [
    LocDemo(),
    //BasicMap(),
    //ShowUserLoationPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
//    return HomeContent();
    return Scaffold(
      /*appBar: AppBar(
        title: Text("老人监控"),
      ),*/
      //body: this._pageList[this._currentIndex],
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        children: _pageList,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTap,
        iconSize: 20,
        type: BottomNavigationBarType.fixed,
        items:items,
      ),
    );
  }
}

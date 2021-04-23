import 'package:flutter/material.dart';
import 'showMonitor.dart';
import 'showAll.dart';
import 'addMonitor.dart';
import 'addOldMan.dart';

void main() => runApp(AdminTables());


class AdminTables extends StatefulWidget {
  AdminTables({Key key}) : super(key: key);

  @override
  _AdminTablesState createState() => _AdminTablesState();
}

class _AdminTablesState extends State<AdminTables> {
  int _currentIndex = 0;

  ///定义底部按钮
  final items = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: "老人",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.category),
      label: "监护人",
    )

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
    ShowAllPeople(),
    ShowAllMonitor(),
  ];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
//    return HomeContent();
    return Scaffold(
      //body: this._pageList[this._currentIndex],
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        children: _pageList,
      ),
      floatingActionButton: Container(
        height: 60,
        width: 60,
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: Colors.white,
        ),
        child: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: (){
            showDialog(context: context,builder: (context){

              return SimpleDialog(
                title: Text('提示!'),
                children: <Widget>[
                  Container(
                    height: 80,
                    alignment: Alignment.center,
                    child: Text('请选择要添加的信息:',style: TextStyle(fontSize: 20, ),),
                  ),
                  Divider(height: 1,color: Colors.black,),
                  AddOldMan(),
                  Divider(height: 1,color: Colors.black,),
                  AddMonitor(),
                ],
              );
            });
            //
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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

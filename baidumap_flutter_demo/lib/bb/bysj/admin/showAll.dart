import 'dart:async';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sqljocky5/sqljocky.dart' hide Row;
import 'addMonitor.dart';
import 'addOldMan.dart';
import '../messagePush/messagePush.dart';

void main() => runApp(ShowAllPeople());



class ShowAllPeople extends StatefulWidget {
  @override
  ShowAllPeopleState createState() => ShowAllPeopleState();
}

class ShowAllPeopleState extends State<ShowAllPeople> with AutomaticKeepAliveClientMixin,MessagePush{
  List list = List();

  Map<String, List> map = Map();


  @override
  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = new IOSInitializationSettings();
    var initSetttings = new InitializationSettings(android: android, iOS: iOS);
    flutterLocalNotificationsPlugin.initialize(initSetttings, onSelectNotification: onSelectNotification);
    getConnection();
    //showAll();

    Timer.periodic(Duration(milliseconds: 1000), (timer) { showAll();});

  }
  Future onSelectNotification(String payload) {
    debugPrint("payload : $payload");
    showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        title: new Text('Notification'),
        content: new Text('$payload'),
      ),
    );
  }

  MySqlConnection conn;

  getConnection() async {
    conn = await MySqlConnection.connect(ConnectionSettings(
        host: 'rm-wz9zt03rn0864rz8uho.mysql.rds.aliyuncs.com',
        port: 3306,
        user: 'keen',
        password: "Zxc000222",
        db: 'demo1'));
    await showAll();
  }

  Future<void> showAll() async {
    //刷新界面清空widget
    await widgetClear();
    //清空list
    await listClear();
    //执行查询
    Results result = await (await conn.execute(
            "select username,sex,age,latitude,longitude,address,guardian,state,emergency,bed,id from user"))
        .deStream();
    result.forEach((element) {
      list.add(element);
    });
    if(mounted){
      setState(() {
        widgetss = createListView();
      });
    }

  }

  deleteUser(String username,String monitorName) async {
    conn.execute("delete from user where username = '$username' && guardian='$monitorName'");
  }

  updateUser(String username,String sex,String age,String monitorScope,String address,String emergency,String bed,String monitorName,int id) async{
    String sql="update  user set username=?,sex=?,age=?,state=?,address=?,emergency=?,bed=?,guardian=? where id=?";
    List<StreamedResults> results2=await(await conn.preparedWithAll(sql, [['$username','$sex','$age','$monitorScope','$address','$emergency','$bed','$monitorName','$id']])).toList();

  }

  Future<void> listClear() async {
    list = List();
  }


  List<Widget> createListView() {
    TextEditingController oldManNameController = new TextEditingController();
    TextEditingController oldManSexController = new TextEditingController();
    TextEditingController oldManAgeController = new TextEditingController();
    TextEditingController oldManMonitorScopeController = new TextEditingController();
    TextEditingController oldManMonitorNameController = new TextEditingController();
    TextEditingController oldManMonitorAddressController = new TextEditingController();
    TextEditingController oldManEmergencyController = new TextEditingController();
    TextEditingController oldManBedController = new TextEditingController();

    GlobalKey<FormState> _formKey = GlobalKey();
    var a = Colors.black12;
    var b = Colors.grey;

    List<Widget> sortList = List();


    for (int i = 0; i < list.length; i++) {
      if(list[i][7] == 'n' || list[i][8]=='n'){
        //推送消息
        if(list[i][7] == 'n'){
          showNotification(list[i][0]);
        }else{
          showEmergencyNotification(list[i][0],list[i][9]);
        }
        sortList.insert(0, InkWell(
          onTap: () {
            return showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Container(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        //crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Row(
                            //mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "姓名:",
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(
                                "${list[i][0]}",
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          Row(
                            //mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "性别:",
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(
                                "${list[i][1]}",
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          Row(
                            //mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "年龄:",
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(
                                "${list[i][2]}",
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          Row(
                            //mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "纬度:",
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(
                                "${list[i][3]}",
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          Row(
                            //mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "经度:",
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(
                                "${list[i][4]}",
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          Row(
                            //mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "地址:",
                                style: TextStyle(fontSize: 20),
                              ),
                              Expanded(child: Text(
                                "${list[i][5]}",
                                style: TextStyle(fontSize: 20),
                              ))
                              ,
                            ],
                          ),
                          Row(
                            //mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "监护人:",
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(
                                "${list[i][6]}",
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          Row(
                            //mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "处于监控范围:",
                                style: TextStyle(fontSize: 20),
                              ),
                              Icon(Icons.circle,
                                  color: list[i][7] == 'y' ? Colors.green : Colors.red),
                            ],
                          ),
                          Row(
                            //mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "发生紧急情况:",
                                style: TextStyle(fontSize: 20),
                              ),
                              Icon(Icons.circle,
                                  color: list[i][8] == 'y' ? Colors.green : Colors.red),
                            ],
                          ),
                          Row(
                            //mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "床号:",
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(
                                "${list[i][9]}",
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                });
          },
          child: Container(
            height: 50,
            child: Row(
              children: <Widget>[
                Padding(padding: EdgeInsets.fromLTRB(5, 0, 0, 0)),
                Container(width: 60,child: Center(child: Text(list[i][0]),),),
                Container(width: 60,child: Center(child: Text(list[i][6]),),),
                Container(width: 80,child: Center(child: Text(list[i][5]),),),
                SizedBox(
                  width: 10,
                ),
                //修改
                InkWell(
                  onTap: () {
                    oldManNameController.text = '${list[i][0]}';
                    oldManSexController.text = '${list[i][1]}';
                    oldManAgeController.text = '${list[i][2]}';
                    oldManMonitorScopeController.text =  '${list[i][7]}';
                    oldManMonitorNameController.text =  '${list[i][6]}';
                    oldManMonitorAddressController.text =  '${list[i][5]}';
                    oldManEmergencyController.text =  '${list[i][8]}';
                    oldManBedController.text = '${list[i][9]}';
                     String sql="select username,sex,age,latitude,longitude,address,guardian,state,emergency,bed from user";
                    showModalBottomSheet(
                      isScrollControlled: true,
                        context: context,
                        builder: (context) {
                          return Container(
                            height: 650,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(20.0, 0, 20, 0),
                              child: Container(
                                height: 1400,
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(
                                        height: 20,
                                      ),
                                      //用户名输入框
                                      TextFormField(
                                        controller: oldManNameController,
                                        //添加装饰盒显示图标
                                        decoration: InputDecoration(
                                          fillColor: Color(0x30cccccc),
                                          filled: true,
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0x00FF0000)),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(100))),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0x00000000)),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(100))),
                                          labelText: "用户名:",
                                        ),
                                        validator: (String value) {
                                          if (value.length >= 2 &&
                                              value.length <= 16) {
                                            return null;
                                          } else {
                                            return '只能输入2-16个字符';
                                          }
                                        },
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      TextFormField(
                                        controller: oldManSexController,
                                        //添加装饰盒显示图标
                                        decoration: InputDecoration(
                                          fillColor: Color(0x30cccccc),
                                          filled: true,
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0x00FF0000)),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(100))),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0x00000000)),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(100))),
                                          labelText: "性别:",
                                        ),
                                        validator: (String value) {
                                          return value == 'nan' || value == 'nv'
                                              ? null
                                              : '请正确输入';
                                        },
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      TextFormField(
                                        controller: oldManAgeController,
                                        //添加装饰盒显示图标
                                        decoration: InputDecoration(
                                          fillColor: Color(0x30cccccc),
                                          filled: true,
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0x00FF0000)),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(100))),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0x00000000)),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(100))),
                                          labelText: "年龄:",
                                        ),
                                        validator: (String value) {
                                          return value.length > 0 &&
                                              value.length < 3
                                              ? null
                                              : '只能输入2-3个字符';
                                        },
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      //修改处于监控范围内
                                      TextFormField(
                                        controller: oldManMonitorScopeController,
                                        //添加装饰盒显示图标
                                        decoration: InputDecoration(
                                          fillColor: Color(0x30cccccc),
                                          filled: true,
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0x00FF0000)),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(100))),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0x00000000)),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(100))),
                                          labelText: "处于监控范围:",
                                        ),
                                        validator: (String value) {
                                          return value=='y' ||value=='n'
                                              ? null
                                              : '请输入y或n,y为yes,n为no';
                                        },
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      //修改监控地址
                                      TextFormField(
                                        controller: oldManMonitorAddressController,
                                        //添加装饰盒显示图标
                                        decoration: InputDecoration(
                                          fillColor: Color(0x30cccccc),
                                          filled: true,
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0x00FF0000)),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(100))),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0x00000000)),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(100))),
                                          labelText: "监控地址:",
                                        ),
                                        validator: (String value) {
                                          return value.length > 0
                                              ? null
                                              : '内容不能为空';
                                        },
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      //修改紧急情况
                                      TextFormField(
                                        controller: oldManEmergencyController,
                                        //添加装饰盒显示图标
                                        decoration: InputDecoration(
                                          fillColor: Color(0x30cccccc),
                                          filled: true,
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0x00FF0000)),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(100))),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0x00000000)),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(100))),
                                          labelText: "紧急情况:",
                                        ),
                                        validator: (String value) {
                                          return value=='y' ||value=='n'
                                              ? null
                                              : '请输入y或n,y为yes,n为no';
                                        },
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      //修改床号
                                      TextFormField(
                                        controller: oldManBedController,
                                        //添加装饰盒显示图标
                                        decoration: InputDecoration(
                                          fillColor: Color(0x30cccccc),
                                          filled: true,
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0x00FF0000)),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(100))),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0x00000000)),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(100))),
                                          labelText: "床号:",
                                        ),
                                        validator: (String value) {
                                          return value.length > 0
                                              ? null
                                              : '内容不能为空';
                                        },
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      //修改监护人
                                      TextFormField(
                                        controller: oldManMonitorNameController,
                                        //添加装饰盒显示图标
                                        decoration: InputDecoration(
                                          fillColor: Color(0x30cccccc),
                                          filled: true,
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0x00FF0000)),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(100))),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0x00000000)),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(100))),
                                          labelText: "监护人:",
                                        ),
                                        validator: (String value) {
                                          return value.length > 0
                                              ? null
                                              : '内容不能为空';
                                        },
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          ElevatedButton(
                                            child: Text("取消"),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          ElevatedButton(
                                            child: Text("修改"),
                                            onPressed: () async {
                                              if(_formKey.currentState.validate()){
                                                await updateUser(oldManNameController.text, oldManSexController.text, oldManAgeController.text, oldManMonitorScopeController.text, oldManMonitorAddressController.text, oldManEmergencyController.text, oldManBedController.text, oldManMonitorNameController.text,list[i][10]);
                                                Navigator.pop(context);
                                                Fluttertoast.showToast(msg: "修改成功");
                                                await showAll();
                                              }else{
                                                Fluttertoast.showToast(msg: "修改失败");
                                              }
                                            },
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );

                        });
                  },
                  child: Container(
                      padding: EdgeInsets.fromLTRB(10, 5, 5, 5),
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Color.fromARGB(255, 34, 150, 243)),
                      height: 30,
                      width: 50,
                      child: Text(
                        "修改",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      )),
                ),
                //删除
                InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (ctx) {
                          return AlertDialog(
                            title: Text("提示信息!"),
                            content: Text("您确定要删除吗?"),
                            actions: <Widget>[
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("取消")),
                              ElevatedButton(
                                  onPressed: () async {
                                    await deleteUser(list[i][0],list[i][6]);
                                    if(mounted){
                                      setState(() {
                                        //sortList.removeAt(0);
                                        widgetss.remove(this);
                                        // showAll();
                                      });
                                    }

                                    Navigator.pop(context);
                                  },
                                  child: Text("确定")),
                            ],
                          );
                        });
                  },
                  child: Container(
                      padding: EdgeInsets.fromLTRB(10, 5, 5, 5),
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Color.fromARGB(255, 34, 150, 243)),
                      height: 30,
                      width: 50,
                      child: Text(
                        "删除",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      )),
                ),
                Icon(Icons.circle,
                    color: list[i][7] == 'y' && list[i][8]=='y' ? Colors.green : Colors.red),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                  color: Colors.black87,
                ),
              ],
            ),
          ),
        ));
      }else{
        sortList.add(InkWell(
          onTap: () {
            return showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Container(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        //crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Row(
                            //mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "姓名:",
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(
                                "${list[i][0]}",
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          Row(
                            //mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "性别:",
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(
                                "${list[i][1]}",
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          Row(
                            //mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "年龄:",
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(
                                "${list[i][2]}",
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          Row(
                            //mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "纬度:",
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(
                                "${list[i][3]}",
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          Row(
                            //mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "经度:",
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(
                                "${list[i][4]}",
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "地址:",
                            style: TextStyle(fontSize: 20),
                          ),
                          Expanded(child: Text(
                            "${list[i][5]}",
                            style: TextStyle(fontSize: 20),
                          ))
                          ,
                        ],
                      ),
                          Row(
                            //mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "监护人:",
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(
                                "${list[i][6]}",
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          Row(
                            //mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "处于监控范围:",
                                style: TextStyle(fontSize: 20),
                              ),
                              Icon(Icons.circle,
                                  color: list[i][7] == 'y' ? Colors.green : Colors.red),
                            ],
                          ),
                          Row(
                            //mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "发生紧急情况:",
                                style: TextStyle(fontSize: 20),
                              ),
                              Icon(Icons.circle,
                                  color: list[i][8] == 'y' ? Colors.green : Colors.red),
                            ],
                          ),
                          Row(
                            //mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "床号:",
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(
                                "${list[i][9]}",
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                });
          },
          child: Container(
            height: 50,
            child: Row(
              children: <Widget>[
                Padding(padding: EdgeInsets.fromLTRB(5, 0, 0, 0)),
                Container(width: 60,child: Center(child: Text(list[i][0]),),),
                Container(width: 60,child: Center(child: Text(list[i][6]),),),
                Container(width: 80,child: Center(child: Text(list[i][5]),),),
                SizedBox(
                  width: 10,
                ),
                //修改
                InkWell(
                  onTap: () {
                    oldManNameController.text = '${list[i][0]}';
                    oldManSexController.text = '${list[i][1]}';
                    oldManAgeController.text = '${list[i][2]}';
                    oldManMonitorScopeController.text =  '${list[i][7]}';
                    oldManMonitorNameController.text =  '${list[i][6]}';
                    oldManMonitorAddressController.text =  '${list[i][5]}';
                    oldManEmergencyController.text =  '${list[i][8]}';
                    oldManBedController.text = '${list[i][9]}';
                    String sql="select username,sex,age,latitude,longitude,address,guardian,state,emergency,bed from user";
                    showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (context) {
                          return Container(
                            height: 650,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(20.0, 0, 20, 0),
                              child: Container(
                                height: 1400,
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(
                                        height: 20,
                                      ),
                                      //用户名输入框
                                      TextFormField(
                                        controller: oldManNameController,
                                        //添加装饰盒显示图标
                                        decoration: InputDecoration(
                                          fillColor: Color(0x30cccccc),
                                          filled: true,
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0x00FF0000)),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(100))),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0x00000000)),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(100))),
                                          labelText: "用户名:",
                                        ),
                                        validator: (String value) {
                                          if (value.length >= 2 &&
                                              value.length <= 16) {
                                            return null;
                                          } else {
                                            return '只能输入2-16个字符';
                                          }
                                        },
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      TextFormField(
                                        controller: oldManSexController,
                                        //添加装饰盒显示图标
                                        decoration: InputDecoration(
                                          fillColor: Color(0x30cccccc),
                                          filled: true,
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0x00FF0000)),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(100))),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0x00000000)),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(100))),
                                          labelText: "性别:",
                                        ),
                                        validator: (String value) {
                                          return value == 'nan' || value == 'nv'
                                              ? null
                                              : '请正确输入';
                                        },
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      TextFormField(
                                        controller: oldManAgeController,
                                        //添加装饰盒显示图标
                                        decoration: InputDecoration(
                                          fillColor: Color(0x30cccccc),
                                          filled: true,
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0x00FF0000)),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(100))),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0x00000000)),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(100))),
                                          labelText: "年龄:",
                                        ),
                                        validator: (String value) {
                                          return value.length > 0 &&
                                              value.length < 3
                                              ? null
                                              : '只能输入2-3个字符';
                                        },
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      //修改处于监控范围内
                                      TextFormField(
                                        controller: oldManMonitorScopeController,
                                        //添加装饰盒显示图标
                                        decoration: InputDecoration(
                                          fillColor: Color(0x30cccccc),
                                          filled: true,
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0x00FF0000)),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(100))),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0x00000000)),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(100))),
                                          labelText: "处于监控范围:",
                                        ),
                                        validator: (String value) {
                                          return value=='y' ||value=='n'
                                              ? null
                                              : '请输入y或n,y为yes,n为no';
                                        },
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      //修改监控地址
                                      TextFormField(
                                        controller: oldManMonitorAddressController,
                                        //添加装饰盒显示图标
                                        decoration: InputDecoration(
                                          fillColor: Color(0x30cccccc),
                                          filled: true,
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0x00FF0000)),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(100))),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0x00000000)),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(100))),
                                          labelText: "监控地址:",
                                        ),
                                        validator: (String value) {
                                          return value.length > 0
                                              ? null
                                              : '内容不能为空';
                                        },
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      //修改紧急情况
                                      TextFormField(
                                        controller: oldManEmergencyController,
                                        //添加装饰盒显示图标
                                        decoration: InputDecoration(
                                          fillColor: Color(0x30cccccc),
                                          filled: true,
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0x00FF0000)),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(100))),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0x00000000)),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(100))),
                                          labelText: "紧急情况:",
                                        ),
                                        validator: (String value) {
                                          return value=='y' ||value=='n'
                                              ? null
                                              : '请输入y或n,y为yes,n为no';
                                        },
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      //修改床号
                                      TextFormField(
                                        controller: oldManBedController,
                                        //添加装饰盒显示图标
                                        decoration: InputDecoration(
                                          fillColor: Color(0x30cccccc),
                                          filled: true,
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0x00FF0000)),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(100))),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0x00000000)),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(100))),
                                          labelText: "床号:",
                                        ),
                                        validator: (String value) {
                                          return value.length > 0
                                              ? null
                                              : '内容不能为空';
                                        },
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      //修改监护人
                                      TextFormField(
                                        controller: oldManMonitorNameController,
                                        //添加装饰盒显示图标
                                        decoration: InputDecoration(
                                          fillColor: Color(0x30cccccc),
                                          filled: true,
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0x00FF0000)),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(100))),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0x00000000)),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(100))),
                                          labelText: "监护人:",
                                        ),
                                        validator: (String value) {
                                          return value.length > 0
                                              ? null
                                              : '内容不能为空';
                                        },
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          ElevatedButton(
                                            child: Text("取消"),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          ElevatedButton(
                                            child: Text("修改"),
                                            onPressed: () async {
                                              if(_formKey.currentState.validate()){
                                                updateUser(oldManNameController.text, oldManSexController.text, oldManAgeController.text, oldManMonitorScopeController.text, oldManMonitorAddressController.text, oldManEmergencyController.text, oldManBedController.text, oldManMonitorNameController.text,list[i][10]);
                                                Navigator.pop(context);
                                                Fluttertoast.showToast(msg: "修改成功");
                                                await showAll();
                                              }else{
                                                Fluttertoast.showToast(msg: "修改失败");
                                              }
                                            },
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );

                        });
                  },
                  child: Container(
                      padding: EdgeInsets.fromLTRB(10, 5, 5, 5),
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Color.fromARGB(255, 34, 150, 243)),
                      height: 30,
                      width: 50,
                      child: Text(
                        "修改",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      )),
                ),
                //删除
                InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (ctx) {
                          return AlertDialog(
                            title: Text("提示信息!"),
                            content: Text("您确定要删除吗?"),
                            actions: <Widget>[
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("取消")),
                              ElevatedButton(
                                  onPressed: () async {
                                    await deleteUser(list[i][0],list[i][6]);
                                    if(mounted){
                                      setState(() {
                                        sortList.removeAt(0);
                                        widgetss.remove(this);
                                        //  showAll();
                                      });
                                    }
                                    Navigator.pop(context);
                                  },
                                  child: Text("确定")),
                            ],
                          );
                        });
                  },
                  child: Container(
                      padding: EdgeInsets.fromLTRB(10, 5, 5, 5),
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Color.fromARGB(255, 34, 150, 243)),
                      height: 30,
                      width: 50,
                      child: Text(
                        "删除",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      )),
                ),
                Icon(Icons.circle,
                    color: list[i][7] == 'y' && list[i][8]=='y' ? Colors.green : Colors.red),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                  color: Colors.black87,
                ),
              ],
            ),
          ),
        ));
      }
    }

    ///排序修改颜色
    for(int i = 0;i<sortList.length;i++){
      widgetss.add(
        Container(
          color: i %2 != 0? a:b,
          child: sortList[i],
        )
      );
    }
    return widgetss;
  }

  List<Widget> widgetss = List();

  Widget createButtonContainer() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black
        ),
      ),
      child: Row(
        children: <Widget>[
          Container(width: 60,child: Center(child: Text("用户"),),),
          SizedBox(
            width: 1,
            height: 20,
            child: DecoratedBox(
              decoration: BoxDecoration(color: Colors.black87),
            ),
          ),
           //垂直分割线
          Container(width: 60,child: Center(child: Text("监护人"),),),
          SizedBox(
            width: 1,
            height: 20,
            child: DecoratedBox(
              decoration: BoxDecoration(color: Colors.black87),
            ),
          ),
          Expanded(child: Center(child: Text("实时地点"),),),
        ],
      ),
    );
  }

  Future<void> widgetClear() async {
    if (widgetss != null) {
      widgetss.clear();
    }
  }


  Widget returnFlexible(){
    return Flexible(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: widgetss,
        ),
      ),
    );
  }

  int count = 0;
  GlobalKey key = GlobalKey();
  bool offstage = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('老人信息'),
        ),
        body: Column(
          children: <Widget>[
            createButtonContainer(),
            returnFlexible(),
          ],
        ),
      ),
    );

  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

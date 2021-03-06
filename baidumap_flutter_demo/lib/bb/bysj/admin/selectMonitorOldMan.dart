import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sqljocky5/sqljocky.dart' hide Row;
import 'addMonitor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'addOldMan.dart';
import '../messagePush/messagePush.dart';





class ShowAllPeople extends StatefulWidget {
  String monitorName;
  ShowAllPeople(this.monitorName);
  @override
  ShowAllPeopleState createState() => ShowAllPeopleState(monitorName);
}

class ShowAllPeopleState extends State<ShowAllPeople> with  AutomaticKeepAliveClientMixin,MessagePush{
  List list = List();
  Map<String, List> map = Map();

  String monitorName;
  ShowAllPeopleState(this.monitorName);

  @override
   initState()  {
    super.initState();
     getConnection();
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = new IOSInitializationSettings();
    var initSetttings = new InitializationSettings(android: android, iOS: iOS);
    flutterLocalNotificationsPlugin.initialize(initSetttings, onSelectNotification: onSelectNotification);
    setState(() {
      _getName() ;
    });
    //showAll();
    startTimer();

  }
  Timer timer;
  startTimer(){
    if(mounted){
      timer=Timer.periodic(Duration(milliseconds: 1000), (timer) { showAll(monitorName);});
    }
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



  _getName() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String monitorName=  prefs.getString('monitorName');
    print(monitorName);
  }
  MySqlConnection conn;

  getConnection() async {
    conn = await MySqlConnection.connect(ConnectionSettings(
        host: 'rm-wz9zt03rn0864rz8uho.mysql.rds.aliyuncs.com',
        port: 3306,
        user: 'keen',
        password: "Zxc000222",
        db: 'demo1'));
    await showAll(monitorName);
  }

  Future<void> showAll(String monitorName) async {
    //??????????????????widget
    await widgetClear();
    //??????list
    await listClear();
    //????????????
    Results result = await (await conn.execute(
        "select username,sex,age,latitude,longitude,address,guardian,state,emergency,bed,id from user where guardian='$monitorName'"))
        .deStream();
    result.forEach((element) {
      list.add(element);
    });setState(() {
      widgetss = createListView();
    });
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
        //????????????
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
                                "??????:",
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
                                "??????:",
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
                                "??????:",
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
                                "??????:",
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
                                "??????:",
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
                                "??????:",
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
                                "?????????:",
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
                                "??????????????????:",
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
                                "??????????????????:",
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
                                "??????:",
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
                //??????
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
                                      //??????????????????
                                      TextFormField(
                                        controller: oldManNameController,
                                        //???????????????????????????
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
                                          labelText: "?????????:",
                                        ),
                                        validator: (String value) {
                                          if (value.length >= 2 &&
                                              value.length <= 16) {
                                            return null;
                                          } else {
                                            return '????????????2-16?????????';
                                          }
                                        },
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      TextFormField(
                                        controller: oldManSexController,
                                        //???????????????????????????
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
                                          labelText: "??????:",
                                        ),
                                        validator: (String value) {
                                          return value == 'nan' || value == 'nv'
                                              ? null
                                              : '???????????????';
                                        },
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      TextFormField(
                                        controller: oldManAgeController,
                                        //???????????????????????????
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
                                          labelText: "??????:",
                                        ),
                                        validator: (String value) {
                                          return value.length > 0 &&
                                              value.length < 3
                                              ? null
                                              : '????????????2-3?????????';
                                        },
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      //???????????????????????????
                                      TextFormField(
                                        controller: oldManMonitorScopeController,
                                        //???????????????????????????
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
                                          labelText: "??????????????????:",
                                        ),
                                        validator: (String value) {
                                          return value=='y' ||value=='n'
                                              ? null
                                              : '?????????y???n,y???yes,n???no';
                                        },
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      //??????????????????
                                      TextFormField(
                                        controller: oldManMonitorAddressController,
                                        //???????????????????????????
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
                                          labelText: "????????????:",
                                        ),
                                        validator: (String value) {
                                          return value.length > 0
                                              ? null
                                              : '??????????????????';
                                        },
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      //??????????????????
                                      TextFormField(
                                        controller: oldManEmergencyController,
                                        //???????????????????????????
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
                                          labelText: "????????????:",
                                        ),
                                        validator: (String value) {
                                          return value=='y' ||value=='n'
                                              ? null
                                              : '?????????y???n,y???yes,n???no';
                                        },
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      //????????????
                                      TextFormField(
                                        controller: oldManBedController,
                                        //???????????????????????????
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
                                          labelText: "??????:",
                                        ),
                                        validator: (String value) {
                                          return value.length > 0
                                              ? null
                                              : '??????????????????';
                                        },
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      //???????????????
                                      TextFormField(
                                        controller: oldManMonitorNameController,
                                        //???????????????????????????
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
                                          labelText: "?????????:",
                                        ),
                                        validator: (String value) {
                                          return value.length > 0
                                              ? null
                                              : '??????????????????';
                                        },
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          ElevatedButton(
                                            child: Text("??????"),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          ElevatedButton(
                                            child: Text("??????"),
                                            onPressed: () async {
                                              if(_formKey.currentState.validate()){
                                                Navigator.pop(context);Fluttertoast.showToast(msg: "????????????");
                                                await updateUser(oldManNameController.text,
                                                    oldManSexController.text, oldManAgeController.text,
                                                    oldManMonitorScopeController.text, oldManMonitorAddressController.text,
                                                    oldManEmergencyController.text, oldManBedController.text,
                                                    oldManMonitorNameController.text,list[i][10]);
                                                await showAll(monitorName);
                                              }else{
                                                Fluttertoast.showToast(msg: "????????????");
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
                        "??????",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      )),
                ),
                //??????
                InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (ctx) {
                          return AlertDialog(
                            title: Text("????????????!"),
                            content: Text("??????????????????????"),
                            actions: <Widget>[
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("??????")),
                              ElevatedButton(
                                  onPressed: () async {
                                    await deleteUser(list[i][0],list[i][6]);
                                    setState(() {
                                      //sortList.removeAt(0);
                                      widgetss.remove(this);
                                      // showAll();
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: Text("??????")),
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
                        "??????",
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
                                "??????:",
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
                                "??????:",
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
                                "??????:",
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
                                "??????:",
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
                                "??????:",
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
                                "??????:",
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
                                "?????????:",
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
                                "??????????????????:",
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
                                "??????????????????:",
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
                                "??????:",
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
                //??????
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
                                      //??????????????????
                                      TextFormField(
                                        controller: oldManNameController,
                                        //???????????????????????????
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
                                          labelText: "?????????:",
                                        ),
                                        validator: (String value) {
                                          if (value.length >= 2 &&
                                              value.length <= 16) {
                                            return null;
                                          } else {
                                            return '????????????2-16?????????';
                                          }
                                        },
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      TextFormField(
                                        controller: oldManSexController,
                                        //???????????????????????????
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
                                          labelText: "??????:",
                                        ),
                                        validator: (String value) {
                                          return value == 'nan' || value == 'nv'
                                              ? null
                                              : '???????????????';
                                        },
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      TextFormField(
                                        controller: oldManAgeController,
                                        //???????????????????????????
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
                                          labelText: "??????:",
                                        ),
                                        validator: (String value) {
                                          return value.length > 0 &&
                                              value.length < 3
                                              ? null
                                              : '????????????2-3?????????';
                                        },
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      //???????????????????????????
                                      TextFormField(
                                        controller: oldManMonitorScopeController,
                                        //???????????????????????????
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
                                          labelText: "??????????????????:",
                                        ),
                                        validator: (String value) {
                                          return value=='y' ||value=='n'
                                              ? null
                                              : '?????????y???n,y???yes,n???no';
                                        },
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      //??????????????????
                                      TextFormField(
                                        controller: oldManMonitorAddressController,
                                        //???????????????????????????
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
                                          labelText: "????????????:",
                                        ),
                                        validator: (String value) {
                                          return value.length > 0
                                              ? null
                                              : '??????????????????';
                                        },
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      //??????????????????
                                      TextFormField(
                                        controller: oldManEmergencyController,
                                        //???????????????????????????
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
                                          labelText: "????????????:",
                                        ),
                                        validator: (String value) {
                                          return value=='y' ||value=='n'
                                              ? null
                                              : '?????????y???n,y???yes,n???no';
                                        },
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      //????????????
                                      TextFormField(
                                        controller: oldManBedController,
                                        //???????????????????????????
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
                                          labelText: "??????:",
                                        ),
                                        validator: (String value) {
                                          return value.length > 0
                                              ? null
                                              : '??????????????????';
                                        },
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      //???????????????
                                      TextFormField(
                                        controller: oldManMonitorNameController,
                                        //???????????????????????????
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
                                          labelText: "?????????:",
                                        ),
                                        validator: (String value) {
                                          return value.length > 0
                                              ? null
                                              : '??????????????????';
                                        },
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          ElevatedButton(
                                            child: Text("??????"),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          ElevatedButton(
                                            child: Text("??????"),
                                            onPressed: () async {
                                              if(_formKey.currentState.validate()){
                                                Navigator.pop(context);Fluttertoast.showToast(msg: "????????????");
                                                await updateUser(oldManNameController.text, oldManSexController.text, oldManAgeController.text, oldManMonitorScopeController.text, oldManMonitorAddressController.text, oldManEmergencyController.text, oldManBedController.text, oldManMonitorNameController.text,list[i][10]);
                                                await showAll(monitorName);
                                              }else{
                                                Fluttertoast.showToast(msg: "????????????");
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
                        "??????",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      )),
                ),
                //??????
                InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (ctx) {
                          return AlertDialog(
                            title: Text("????????????!"),
                            content: Text("??????????????????????"),
                            actions: <Widget>[
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("??????")),
                              ElevatedButton(
                                  onPressed: () async {
                                    await deleteUser(list[i][0],list[i][6]);
                                    setState(() {
                                      sortList.removeAt(0);
                                      widgetss.remove(this);
                                      //  showAll();
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: Text("??????")),
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
                        "??????",
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

    ///??????????????????
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
          Container(width: 60,child: Center(child: Text("??????"),),),
          SizedBox(
            width: 1,
            height: 20,
            child: DecoratedBox(
              decoration: BoxDecoration(color: Colors.black87),
            ),
          ),
          //???????????????
          Container(width: 60,child: Center(child: Text("?????????"),),),
          SizedBox(
            width: 1,
            height: 20,
            child: DecoratedBox(
              decoration: BoxDecoration(color: Colors.black87),
            ),
          ),
          Expanded(child: Center(child: Text("????????????"),),),
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
          leading: IconButton(onPressed: () { Navigator.pop(context);
          timer.cancel();}, icon: Icon(Icons.arrow_back),),
          title: Text('??????????????????????????????'),
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

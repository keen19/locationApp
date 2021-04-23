import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sqljocky5/sqljocky.dart' hide Row;
import 'showAll.dart';
import '../database/ConnectionDB.dart';
import 'addMonitor.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Material App',
        home: Scaffold(
            appBar: AppBar(
              title: Text('管理员界面'),
            ),
            body: Container(
              child: Column(
                children: <Widget>[
                  ABC(),
                ],
              ),
            )));
  }
}

class ABC extends StatefulWidget {
  @override
  _ABCState createState() => _ABCState();
}

class _ABCState extends State<ABC> with ConnectionDb {
  GlobalKey<FormState> _formKey = GlobalKey();

  TextEditingController monitorNameController = new TextEditingController();
  TextEditingController monitorSexController = new TextEditingController();
  TextEditingController monitorAgeController = new TextEditingController();

  TextEditingController oldManNameController = new TextEditingController();
  TextEditingController oldManSexController = new TextEditingController();
  TextEditingController oldManAgeController = new TextEditingController();

  String oldManName;

  String _newValue = "男";

  MySqlConnection conn;
  List list = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getConnection();
  }

  Future<void> addMonitor(
      String monitorName, String monitorSex, String monitorAge) async {
    String sql = "insert into monitor (monitor_name,sex,age) values (?,?,?)";
    List<StreamedResults> results = await (await conn.preparedWithAll(sql, [
      ['$monitorName', '$monitorSex', '$monitorAge']
    ]))
        .toList();
  }

  selectMonitor(String monitorName) async {
    String selectSql =
        "select monitor_name from monitor where monitor_name = '$monitorName'";
    Results result = await (await conn.execute(selectSql)).deStream();
    if (result != null) {
      print("hahaahah");
      print(result);
    }
    Form.of(context).validate();

    result.forEach((element) {
      print(element);
      list.add(element);
    });
  }

  Future<void> registerMonitor(String monitorName) async {
    if (list.length == 0) {
      String sql = "insert into monitor (monitor_name) values (?)";
      List<StreamedResults> results = await (await conn.preparedWithAll(sql, [
        ['$monitorName']
      ]))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,

/*      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,*/
      //textDirection: ,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 5,
            ),
            ElevatedButton(
              child: Text('添加监护人'),
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Padding(
                        padding: EdgeInsets.fromLTRB(20.0, 0, 20, 0),
                        child: Container(
                          height: 400,
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 20,
                                ),
                                //用户名输入框
                                TextFormField(
                                  controller: monitorNameController,
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
                                  onSaved: (value) {
                                    oldManName = value;
                                  },
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
                                  controller: monitorSexController,
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
                                  onSaved: (value) {
                                    oldManName = value;
                                  },
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
                                  controller: monitorAgeController,
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
                                  onSaved: (value) {
                                    oldManName = value;
                                  },
                                  validator: (String value) {
                                    return value.length > 0 && value.length < 3
                                        ? null
                                        : '只能输入2-16个字符';
                                  },
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    ElevatedButton(
                                      child: Text("取消"),
                                      onPressed: () {
                                        //清空表单
                                        _formKey.currentState.reset();
                                        Navigator.pop(context);
                                      },
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    ElevatedButton(
                                      child: Text("添加"),
                                      onPressed: () {
                                        if (_formKey.currentState.validate()) {
                                          addMonitor(
                                              monitorNameController.text,
                                              monitorSexController.text,
                                              monitorAgeController.text);
                                          //清空表单
                                          _formKey.currentState.reset();
                                          Navigator.pop(context);
                                          Fluttertoast.showToast(msg: "添加成功");
                                        } else {
                                          Fluttertoast.showToast(msg: "添加失败");
                                        }
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              },
            ),
            SizedBox(
              width: 5,
            ),
            ElevatedButton(
              child: Text('添加老人'),
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Padding(
                        padding: EdgeInsets.fromLTRB(20.0, 0, 20, 0),
                        child: Container(
                          height: 400,
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 20,
                                ),
                                //用户名输入框
                                TextFormField(
                                  controller: monitorNameController,
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
                                  onSaved: (value) {
                                    oldManName = value;
                                  },
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
                                  controller: monitorSexController,
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
                                  onSaved: (value) {
                                    oldManName = value;
                                  },
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
                                  controller: monitorAgeController,
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
                                  onSaved: (value) {
                                    oldManName = value;
                                  },
                                  validator: (String value) {
                                    return value.length > 0 && value.length < 3
                                        ? null
                                        : '只能输入2-16个字符';
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
                                      child: Text("添加"),
                                      onPressed: () {
                                        if (_formKey.currentState.validate()) {
                                          addMonitor(
                                              monitorNameController.text,
                                              monitorSexController.text,
                                              monitorAgeController.text);
                                          Navigator.pop(context);
                                          Fluttertoast.showToast(msg: "添加成功");
                                        } else {
                                          Fluttertoast.showToast(msg: "添加失败");
                                        }
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              },
            ),
            SizedBox(
              width: 5,
            ),
            ElevatedButton(
              child: Text('查看所有人'),
              onPressed: () {
                try {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ShowAllPeople()));
                } catch (e) {
                  print(e);
                }
              },
            ),
          ],
        ),
        Divider(color: Colors.black,),
        Container(
          child: Row(
            children: <Widget>[
              Text("用户"),
              SizedBox(width: 10,child: Divider(),),
              Container(child: VerticalDivider(
                color: Colors.grey,
                width: 1,
                ),
              ),            //垂直分割线
              Text("监护人"),
              SizedBox(
                width: 1,
                height: 12,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Colors.grey),
                ),
              ),
              SizedBox(width: 10,),
              Text("实时地点"),
              SizedBox(width: 10,),
              ElevatedButton(onPressed: null, child: Text("修改")),
              ElevatedButton(onPressed: null, child: Text("删除")),
            ],
          ),
        ),
      ],
    );
  }
}

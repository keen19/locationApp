import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../database/ConnectionDB.dart';
import 'package:sqljocky5/sqljocky.dart' hide Row;

class AddOldMan extends StatefulWidget {
  @override
  _AddOldManState createState() => _AddOldManState();
}

class _AddOldManState extends State<AddOldMan> with ConnectionDb {
  TextEditingController addOldManNameController = new TextEditingController();
  TextEditingController addOldManAgeController = new TextEditingController();
  TextEditingController addOldManSexController = new TextEditingController();
  TextEditingController addOldManMonitorScopeController =
  new TextEditingController();
  TextEditingController addOldManAddressController =
  new TextEditingController();
  TextEditingController addOldManEmergencyController =
  new TextEditingController();
  TextEditingController addOldManBedController = new TextEditingController();
  TextEditingController addOldManMonitorNameController =
  new TextEditingController();
  TextEditingController addOldManPrivateKeyController =
  new TextEditingController();
  TextEditingController addOldManPasswordController =
  new TextEditingController();

  GlobalKey<FormState> addOldManKey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getConnection();
  }

  Future<void> addOldMan(String username,
      String sex,
      String age,
      String monitorScope,
      String address,
      String emergency,
      String bed,
      String monitorName,
      String privateKey,
      String password) async {
    String sql =
        "insert into user (username,password,privateKey,address,guardian,sex,age,state,emergency,bed) values (?,?,?,?,?,?,?,?,?,?)";
    List<StreamedResults> results = await (await conn.preparedWithAll(sql, [
      [
        '$username',
        '$password',
        '$privateKey',
        '$address',
        '$monitorName',
        '$sex',
        '$age',
        '$monitorScope',
        '$emergency',
        '$bed'
      ]
    ]))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text('老人'),
      onPressed: () {
        showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) {
              return Padding(
                padding: EdgeInsets.fromLTRB(20.0, 0, 20, 0),
                child: Container(
                  height: 600,
                  child: Form(
                    key: addOldManKey,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        //用户名输入框
                        Container(
                          height: 40,
                          child: TextFormField(
                            controller: addOldManNameController,
                            //添加装饰盒显示图标
                            decoration: InputDecoration(
                              fillColor: Color(0x30cccccc),
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Color(0x00FF0000)),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(100))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Color(0x00000000)),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(100))),
                              labelText: "用户名:",
                            ),
                            validator: (String value) {
                              if (value.length >= 2 && value.length <= 16) {
                                return null;
                              } else {
                                return '只能输入2-16个字符';
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(height: 40,
                          child: TextFormField(
                            controller: addOldManSexController,
                            //添加装饰盒显示图标
                            decoration: InputDecoration(
                              fillColor: Color(0x30cccccc),
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Color(0x00FF0000)),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(100))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Color(0x00000000)),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(100))),
                              labelText: "性别:",
                            ),
                            validator: (String value) {
                              return value == 'nan' || value == 'nv'
                                  ? null
                                  : '请正确输入';
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(height: 40,
                          child: TextFormField(
                            controller: addOldManAgeController,
                            //添加装饰盒显示图标
                            decoration: InputDecoration(
                              fillColor: Color(0x30cccccc),
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Color(0x00FF0000)),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(100))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Color(0x00000000)),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(100))),
                              labelText: "年龄:",
                            ),
                            validator: (String value) {
                              return value.length > 0 && value.length < 3
                                  ? null
                                  : '只能输入2-16个字符';
                            },
                          ),
                        ),
                        //密码
                        SizedBox(
                          height: 10,
                        ),
                        Container(height: 40,
                          child: TextFormField(
                            controller: addOldManPasswordController,
                            //添加装饰盒显示图标
                            decoration: InputDecoration(
                              fillColor: Color(0x30cccccc),
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Color(0x00FF0000)),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(100))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Color(0x00000000)),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(100))),
                              labelText: "密码:",
                            ),
                            validator: (String value) {
                              return value.length > 7 ? null : '最少输入8个字符';
                            },
                          ),
                        ),
                        //私密码
                        SizedBox(
                          height: 10,
                        ),
                        Container(height: 40,
                          child: TextFormField(
                            controller: addOldManPrivateKeyController,
                            //添加装饰盒显示图标
                            decoration: InputDecoration(
                              fillColor: Color(0x30cccccc),
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Color(0x00FF0000)),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(100))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Color(0x00000000)),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(100))),
                              labelText: "私密码:",
                            ),
                            validator: (String value) {
                              return value.length > 3 ? null : '最少输入4个字符';
                            },
                          ),
                        ),
                        //监控地址
                        SizedBox(
                          height: 10,
                        ),
                        Container(height: 40,
                          child: TextFormField(
                            controller: addOldManAddressController,
                            //添加装饰盒显示图标
                            decoration: InputDecoration(
                              fillColor: Color(0x30cccccc),
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Color(0x00FF0000)),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(100))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Color(0x00000000)),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(100))),
                              labelText: "监控地址:",
                            ),
                            validator: (String value) {
                              return value.length > 0 ? null : '不能为空';
                            },
                          ),
                        ),
                        //监护人姓名
                        SizedBox(
                          height: 10,
                        ),
                        Container(height: 40,
                          child: TextFormField(
                            controller: addOldManMonitorNameController,
                            //添加装饰盒显示图标
                            decoration: InputDecoration(
                              fillColor: Color(0x30cccccc),
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Color(0x00FF0000)),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(100))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Color(0x00000000)),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(100))),
                              labelText: "监护人:",
                            ),
                            validator: (String value) {
                              return value.length > 0 && value.length < 3
                                  ? null
                                  : '只能输入2-3个字符';
                            },
                          ),
                        ),
                        //处于监控范围
                        SizedBox(
                          height: 10,
                        ),
                        Container(height: 40,
                          child: TextFormField(
                            controller: addOldManMonitorScopeController,
                            //添加装饰盒显示图标
                            decoration: InputDecoration(
                              fillColor: Color(0x30cccccc),
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Color(0x00FF0000)),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(100))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Color(0x00000000)),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(100))),
                              labelText: "处于监控范围:",
                            ),
                            validator: (String value) {
                              return value == 'y' || value == 'n'
                                  ? null
                                  : '只能输入y或n';
                            },
                          ),
                        ),
                        //紧急情况
                        SizedBox(
                          height: 10,
                        ),
                        Container(height: 40,
                          child: TextFormField(
                            controller: addOldManEmergencyController,
                            //添加装饰盒显示图标
                            decoration: InputDecoration(
                              fillColor: Color(0x30cccccc),
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Color(0x00FF0000)),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(100))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Color(0x00000000)),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(100))),
                              labelText: "紧急情况:",
                            ),
                            validator: (String value) {
                              return value == 'y' || value == 'n'
                                  ? null
                                  : '只能输入y或n';
                            },
                          ),
                        ),
                        //床号
                        SizedBox(
                          height: 10,
                        ),
                        Container(height: 40,
                          child: TextFormField(
                            controller: addOldManBedController,
                            //添加装饰盒显示图标
                            decoration: InputDecoration(
                              fillColor: Color(0x30cccccc),
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Color(0x00FF0000)),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(100))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Color(0x00000000)),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(100))),
                              labelText: "床号:",
                            ),
                            validator: (String value) {
                              return value.length > 0 ? null : '至少输入一个数字';
                            },
                          ),
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
                                if (addOldManKey.currentState.validate()) {

                                  addOldMan(
                                    addOldManNameController.text,
                                    addOldManSexController.text,
                                    addOldManAgeController.text,
                                    addOldManMonitorScopeController.text,
                                    addOldManAddressController.text,
                                    addOldManEmergencyController.text,
                                    addOldManBedController.text,
                                    addOldManMonitorNameController.text,
                                    addOldManPrivateKeyController.text,
                                    addOldManPasswordController.text,
                                  );
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
    );
  }
}

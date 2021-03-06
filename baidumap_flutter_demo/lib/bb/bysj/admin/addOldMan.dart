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
      child: Text('??????'),
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
                        //??????????????????
                        Container(
                          height: 40,
                          child: TextFormField(
                            controller: addOldManNameController,
                            //???????????????????????????
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
                              labelText: "?????????:",
                            ),
                            validator: (String value) {
                              if (value.length >= 2 && value.length <= 16) {
                                return null;
                              } else {
                                return '????????????2-16?????????';
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
                            //???????????????????????????
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
                              labelText: "??????:",
                            ),
                            validator: (String value) {
                              return value == 'nan' || value == 'nv'
                                  ? null
                                  : '???????????????';
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(height: 40,
                          child: TextFormField(
                            controller: addOldManAgeController,
                            //???????????????????????????
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
                              labelText: "??????:",
                            ),
                            validator: (String value) {
                              return value.length > 0 && value.length < 3
                                  ? null
                                  : '????????????2-16?????????';
                            },
                          ),
                        ),
                        //??????
                        SizedBox(
                          height: 10,
                        ),
                        Container(height: 40,
                          child: TextFormField(
                            controller: addOldManPasswordController,
                            //???????????????????????????
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
                              labelText: "??????:",
                            ),
                            validator: (String value) {
                              return value.length > 7 ? null : '????????????8?????????';
                            },
                          ),
                        ),
                        //?????????
                        SizedBox(
                          height: 10,
                        ),
                        Container(height: 40,
                          child: TextFormField(
                            controller: addOldManPrivateKeyController,
                            //???????????????????????????
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
                              labelText: "?????????:",
                            ),
                            validator: (String value) {
                              return value.length > 3 ? null : '????????????4?????????';
                            },
                          ),
                        ),
                        //????????????
                        SizedBox(
                          height: 10,
                        ),
                        Container(height: 40,
                          child: TextFormField(
                            controller: addOldManAddressController,
                            //???????????????????????????
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
                              labelText: "????????????:",
                            ),
                            validator: (String value) {
                              return value.length > 0 ? null : '????????????';
                            },
                          ),
                        ),
                        //???????????????
                        SizedBox(
                          height: 10,
                        ),
                        Container(height: 40,
                          child: TextFormField(
                            controller: addOldManMonitorNameController,
                            //???????????????????????????
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
                              labelText: "?????????:",
                            ),
                            validator: (String value) {
                              return value.length > 0 && value.length < 3
                                  ? null
                                  : '????????????2-3?????????';
                            },
                          ),
                        ),
                        //??????????????????
                        SizedBox(
                          height: 10,
                        ),
                        Container(height: 40,
                          child: TextFormField(
                            controller: addOldManMonitorScopeController,
                            //???????????????????????????
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
                              labelText: "??????????????????:",
                            ),
                            validator: (String value) {
                              return value == 'y' || value == 'n'
                                  ? null
                                  : '????????????y???n';
                            },
                          ),
                        ),
                        //????????????
                        SizedBox(
                          height: 10,
                        ),
                        Container(height: 40,
                          child: TextFormField(
                            controller: addOldManEmergencyController,
                            //???????????????????????????
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
                              labelText: "????????????:",
                            ),
                            validator: (String value) {
                              return value == 'y' || value == 'n'
                                  ? null
                                  : '????????????y???n';
                            },
                          ),
                        ),
                        //??????
                        SizedBox(
                          height: 10,
                        ),
                        Container(height: 40,
                          child: TextFormField(
                            controller: addOldManBedController,
                            //???????????????????????????
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
                              labelText: "??????:",
                            ),
                            validator: (String value) {
                              return value.length > 0 ? null : '????????????????????????';
                            },
                          ),
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
                                  Fluttertoast.showToast(msg: "????????????");
                                } else {
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
              );
            });
      },
    );
  }
}

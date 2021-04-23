import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sqljocky5/sqljocky.dart' hide Row;
import '../../database//ConnectionDB.dart';
class ForgetPasswordPage extends StatefulWidget {
  @override
  _ForgetPasswordPageState createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> with ConnectionDb{
  List list = new List();

  ///设置表单key
  final _formKey = GlobalKey<FormState>();
  bool passwordVisible = true;
  bool samePasswordVisible = true;

  /// 设置用户名
  String name;
  String password;
  String samePassword;
  String privateKey;

  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController samePasswordController = new TextEditingController();
  TextEditingController privateKeyController = new TextEditingController();

  MySqlConnection conn;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getConnection();
  }



  Future<void> resetPassword(
      String username, String password, String privateKey) async {
    String sql = "update  user set password = ? where username = ?";
    //查询验证用户名和私密码
    Results result = await (await conn.execute(
            "select username,privateKey from user where username = '$username'"))
        .deStream();

    result.forEach((element) {
      list.add(element);
      //print(list);
    });

    if (list.length > 0 && list[0][0] == username && list[0][1] == privateKey) {
      await conn.prepared(sql, ['$password', '$username']);
      Fluttertoast.showToast(msg: "修改密码成功");
    } else {
      //list.removeAt(0);
      Fluttertoast.showToast(msg: "用户名或私密码错误");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("重置密码"),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Text("老人定位"),
              Padding(
                padding: EdgeInsets.fromLTRB(25, 0, 25, 25),
                child: Column(
                  children: <Widget>[
                    Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            //用户名输入框
                            TextFormField(
                              controller: usernameController,
                              //添加装饰盒显示图标
                              decoration: InputDecoration(
                                labelText: "用户名:",
                                icon: Icon(Icons.person),
                              ),
                              onSaved: (value) {
                                name = value;
                              },
                              validator: (String value) {
                                return value.length >= 2 && value.length <= 16
                                    ? null
                                    : '只能输入2-16个字符';
                              },
                            ),
                            //添加密码输出框
                            TextFormField(
                              controller: passwordController,
                              //隐藏密码显示
                              obscureText: passwordVisible,
                              //添加装饰盒显示图标
                              decoration: InputDecoration(
                                hintText: "字符不少于8个",
                                labelText: "重新设置的密码:",
                                icon: Icon(Icons.vpn_key),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      //设置是否显示密码
                                      passwordVisible
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: /*Theme.of(context).primaryColorDark*/
                                      Colors.black12,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        passwordVisible = !passwordVisible;
                                      });
                                    },
                                  )
                              ),
                              onSaved: (value) {
                                password = value;
                              },
                              validator: (String value) {
                                return value.length >= 8 ? null : '密码不能不少于8个字符';
                              },
                            ),
                            TextFormField(
                              controller: samePasswordController,
                              //隐藏密码显示
                              obscureText: samePasswordVisible,
                              //添加装饰盒显示图标
                              decoration: InputDecoration(
                                hintText: "两次密码必须相同",
                                labelText: "再次确认密码:",
                                icon: Icon(Icons.vpn_key),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      //设置是否显示密码
                                      samePasswordVisible
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: /*Theme.of(context).primaryColorDark*/
                                      Colors.black12,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        samePasswordVisible = !samePasswordVisible;
                                      });
                                    },
                                  )
                              ),
                              onSaved: (value) {
                                samePassword = value;
                              },
                              validator: (value) {
                                return passwordController.text == value
                                    ? null
                                    : '两次密码不同';
                              },
                            ),
                            TextFormField(
                              controller: privateKeyController,
                              //隐藏密码显示
                              obscureText: true,
                              //添加装饰盒显示图标
                              decoration: InputDecoration(
                                hintText: "字符不少于4个",
                                labelText: "用于找回密码的私密码:",
                                icon: Icon(Icons.attribution_outlined),
                              ),
                              onSaved: (value) {
                                privateKey = value;
                              },
                              validator: (String value) {
                                return value.length >= 4 ? null : '不能少于4个字符';
                              },
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (_formKey.currentState.validate()) {
                                        _formKey.currentState.save();
                                        resetPassword(
                                            usernameController.text,
                                            passwordController.text,
                                            privateKeyController.text);
                                      }
                                    },
                                    child: Text("修改密码"),
                                  ),
                                ),
                              ],
                            )
                          ],
                        )),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

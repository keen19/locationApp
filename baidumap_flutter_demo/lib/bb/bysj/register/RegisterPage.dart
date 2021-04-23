import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart' ;
import 'package:sqljocky5/sqljocky.dart' hide Row;
import '../database/ConnectionDB.dart';
class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with ConnectionDb{
  ///设置表单key
  final _formKey = GlobalKey<FormState>();

  /// 设置用户名
  String name;
  String password;
  String samePassword;
  String privateKey;

  bool passwordVisible = true;
  bool samePasswordVisible = true;
  
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


  Future<void> registerUser(String username,String password,String privateKey) async{
    String sql = "insert into user (username,password,privateKey) values (?,?,?)";
    List<StreamedResults> results=
        await(await conn.preparedWithAll(sql, [['$username','$password','$privateKey']])).toList();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('注册账号'),
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
                          controller:usernameController,
                          //添加装饰盒显示图标
                          decoration: InputDecoration(
                            hintText: "必须输入2-16个字符",
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
                            labelText: "密码:",
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
                            return passwordController.text==value ? null : '两次密码不同';
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
                                  if(_formKey.currentState.validate()){
                                    registerUser(usernameController.text,
                                        passwordController.text,
                                        privateKeyController.text);
                                    _formKey.currentState.save();
                                    _formKey.currentState.reset();
                                    Navigator.pop(context);
                                    Fluttertoast.showToast(msg: '注册成功');
                                  }
                                },
                                child: Text("注册"),
                              ),
                            ),
                          ],
                        )],
                    ),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

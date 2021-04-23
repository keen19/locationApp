import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sqljocky5/sqljocky.dart' hide Row;
import 'usersManage.dart' as u;
import '../database/ConnectionDB.dart';
import 'bottomNavigationBar.dart';

class AdminLoginPage extends StatefulWidget {
  @override
  _AdminLoginPageState createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> with ConnectionDb{
  List list = new List();
  TextEditingController adminController = TextEditingController();
  TextEditingController adminPasswordController = TextEditingController();

  //设置密码输入框初始不可查看
  bool passwordVisible = true;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getConnection();
  }


  ///登录验证
  adminLoginVerify(String admin, String password) async {
    /*Results result =
        await (await conn.execute("select * from adminInfo where admin_user = '$admin'")).deStream();*/
    Results result = await (await conn.execute(
            "select admin_user,admin_password from adminInfo where admin_user = '$admin'"))
        .deStream();
    result.forEach((element) {
      list.add(element);
      //print(a);
    });
    if (list.length > 0 && list[0][0] == admin && list[0][1] == password) {
      Navigator.of(context)
          /*.push(MaterialPageRoute(
                                  builder: (context) => a.MyApp()));*/
          .pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => AdminTables()),
              (route) => route == null);
          conn.close();
      Fluttertoast.showToast(msg: "登录成功");
    } else {
      Fluttertoast.showToast(msg: "用户名或密码错误");
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('管理员登录'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(25, 0, 25, 25),
              child: Form(
                child: Column(
                  children: <Widget>[
                    //用户名输入框
                    TextFormField(
                      controller: adminController,
                      //添加装饰盒显示图标
                      decoration: InputDecoration(
                        labelText: "用户名:",
                        icon: Icon(Icons.person),
                      ),
                    ),
                    //添加密码输出框
                    TextFormField(
                      controller: adminPasswordController,
                      //隐藏密码显示
                      obscureText: passwordVisible,
                      //添加装饰盒显示图标
                      decoration: InputDecoration(
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
                          )),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          width: 100,
                          child: ElevatedButton(
                            onPressed: () {
                              //调用查询方法
                              adminLoginVerify(adminController.text,
                                  adminPasswordController.text);
                            },
                            child: Text("登录"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

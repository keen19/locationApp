import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqljocky5/sqljocky.dart' hide Row;
import 'main.dart' as Tabss;
import 'pages/login/ForgetPasswordPage.dart';
import 'register/RegisterPage.dart';
import 'admin/adminLogin.dart';
import 'dart:async';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart'
    show BMFMapSDK, BMF_COORD_TYPE;
import 'dart:io' show Platform;
import 'database/ConnectionDB.dart';
import '../bysj/admin/selectMonitorOldMan.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Provider.debugCheckInvalidValueType = null;
//动态申请定位权限
  if (Platform.isIOS) {
    BMFMapSDK.setApiKeyAndCoordType(
        'S5RN3yHdFxy2PIhHPFsHgAil7zTxu6aK', BMF_COORD_TYPE.BD09LL);
  } else if (Platform.isAndroid) {
// Android 目前不支持接口设置Apikey,
// 请在主工程的Manifest文件里设置，详细配置方法请参考[https://lbsyun.baidu.com/ 官网][https://lbsyun.baidu.com/)demo
    BMFMapSDK.setCoordType(BMF_COORD_TYPE.BD09LL);
  }
  //LocationFlutterPlugin.setApiKey("S5RN3yHdFxy2PIhHPFsHgAil7zTxu6aK");
  //设置iOS端AK, Android端AK可以直接在清单文件中配置

  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '养老院老人监控',
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with ConnectionDb {
  List list = new List();

  TextEditingController userController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();

  MySqlConnection conn;
  bool passwordVisible = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getConnection();
  }

  ///登录验证
  Future<void> loginVerify(String username, String password) async {
    List list = List();

    //查询监护人数据库
    Results result2 = await (await conn.execute(
            "select monitor_name,password from monitor where monitor_name = '$username' and password = '$password' "))
        .deStream();
    //查询用户数据库
    Results result = await (await conn.execute(
            "select username,password,latitude,longitude,address from user where username = '$username' and password = '$password'"))
        .deStream();
    //判断是否登入用户或者监护人
    if (result2.length != 0) {
      result2.forEach((element) {
        list.add(element);
      });
      //验证成功 断开数据库连接
      conn.close();
      Navigator.of((context)).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => ShowAllPeople('$username')),
          (route) => route == null);
      Fluttertoast.showToast(msg: "登录成功");
    } else if (result.length != 0) {
      result.forEach((element) {
        list.add(element);
        print(list);
      });
      //验证成功 断开数据库连接
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('username', username);

      conn.close();
      Navigator.of((context)).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Tabss.Tables()),
          (route) => route == null);
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
        title: Text('老人定位监控系统'),
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
                      controller: userController,
                      //添加装饰盒显示图标
                      decoration: InputDecoration(
                        labelText: "用户名:",
                        icon: Icon(Icons.person),
                      ),
                    ),
                    //添加密码输出框
                    TextFormField(
                      controller: userPasswordController,
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
                              color: /*Theme.of(context).backgroundColor*/
                                  Colors.black12,
                            ),
                            onPressed: () {
                              setState(() {
                                passwordVisible = !passwordVisible;
                              });
                            },
                          )),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ForgetPasswordPage()));
                            },
                            child: Text(
                              "忘记密码?",
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Color.fromRGBO(250, 250, 250, 1.0)),
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.red),
                              textStyle: MaterialStateProperty.all(
                                  TextStyle(fontSize: 10)),
                              elevation: MaterialStateProperty.all(0),
                            ),
                          )
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 100,
                          child: OutlineButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => RegisterPage()));
                            },
                            child: Text("注册"),
                            textColor: Colors.blue,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          width: 100,
                          child: ElevatedButton(
                            onPressed: () {
                              loginVerify(userController.text,
                                  userPasswordController.text);
                            },
                            child: Text("登录"),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 80.0, 0.0, 0.0),
                      child: Column(
                        children: <Widget>[
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => AdminLoginPage()));
                            },
                            child: Text("管理员登录"),
                          )
                        ],
                      ),
                    )
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

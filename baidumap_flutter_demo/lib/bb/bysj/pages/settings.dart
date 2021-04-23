import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqljocky5/results/results.dart';
import '../database/ConnectionDB.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with AutomaticKeepAliveClientMixin, ConnectionDb {
  @override
  initState() {
    super.initState();
    getConnection();
    getUsername();
  }

  String username;

  getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString('username');
    print(username);
  }

  //更新监控状态
  updateState(String username) async {
    String sql = "update user set emergency = ? where username=?";
    List<StreamedResults> results2 = await (await conn.preparedWithAll(sql, [
      ['n', '$username']
    ]))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("请求呼救"),),
      body: Center(
        child: Container(
            height: 200,
            width: 200,
            child: ElevatedButton(
              onPressed: () {
                updateState(username);
              },
              child: Text("请求呼救",style: TextStyle(fontSize: 30),),
            )),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

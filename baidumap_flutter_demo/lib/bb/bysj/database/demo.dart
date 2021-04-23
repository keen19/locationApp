import 'dart:async';
import 'package:sqljocky5/sqljocky.dart';

 main() async {
  // Open a connection (testdb should already exist)
  final conn = await MySqlConnection.connect(ConnectionSettings(
      host: 'rm-wz9zt03rn0864rz8uho.mysql.rds.aliyuncs.com',
      port: 3306,
      user: 'keen',
      password: "Zxc000222",
      db: 'demo1'));


/*  //更新坐标地址
  updateLocation(String username,double latitude,double longitude,String address)async{
    String sql = "update user set  latitude=?,longitude= ?,address= ? where username=?";
    List<StreamedResults> results2=await(await conn.preparedWithAll(sql,
        [['$latitude','$longitude','$address','$username']])).toList();
  }*/
  //更新坐标地址
  updateLocation(String username,double latitude,double longitude,String address)async{
    String sql = "update user set latitude=?,longitude=?,address=? where username=? ";
    await conn.prepared(sql,
        [latitude,longitude,'$address','$username']);
  }
  await updateLocation('hqw', 23.45462178,113.48838122,'123123123');
   //createListView();

/*  Results resutls=await(await conn.execute("select monitor_name,monitor_sex,monitor_age,on_duty,off_duty,monitor_telephone,monitor_id from monitor")).deStream();
  print(resutls);
  updateUser(String username,String sex,String age,String monitorScope,String address,String emergency,String bed,String monitorName,int id) async{
   String sql="update  user set username=?,sex=?,age=?,state=?,address=?,emergency=?,bed=?,guardian=? where id=?";
   List<StreamedResults> results2=await(await conn.preparedWithAll(sql, [['$username','$sex','$age','$monitorScope','$address','$emergency','$bed','$monitorName','$id']])).toList();

  }
  updateMonitor(String monitorName,String monitorSex,String monitorAge,String onDuty,String offDuty,String monitorTelephone,int monitorId) async{
   String sql="update  user set monitor_name=?,monitor_sex=?,monitor_age=?,on_duty=?,off_duty=?,monitor_telephone=? where monitor_id = ?";
   List<StreamedResults> results2=await(await conn.preparedWithAll(sql, [['$monitorName','$monitorSex','$monitorAge','$onDuty','$offDuty','$monitorTelephone','$monitorId']])).toList();

  }
  updateMonitor('黄强辉', 'nan', '18', '15','24','13142354764',1);*/
  // print(results);
/*   Results result = await (await conn.execute(
       "select username,password from user where username = 'nihao'"))
       .deStream();
   result.forEach((element) {print(element);});*/
   /*Future<bool> selectAdmin(String admin, String password) async {
     var results =
     await conn.execute("select * from adminInfo where admin_user = '$admin'");
     results.forEach((element) {
       if (element[0] == admin && element[1] == password) {
          return true;
       }
     });
      return false;
   }

   Future<bool> demo() async{
     return true;
   }
   demo().then((value) => (){});
   print(selectAdmin('张三', '123456'));*/
  await conn.close();
}
/*class User{
  String username;
  String password;

  User(this.username,this.password);

  @override
  String toString() {
    // TODO: implement toString
    return "User{"+
   "username='"+username+"\'"+",password='"+password+"\'"+"}";
  }
}*/
/*void main() {
 var a =new LoginVerify();
 a.selectAll();
}

void main() => runApp(MyApp());*/
/*
class MyApp extends StatelessWidget {
 @override
 Widget build(BuildContext context) {
  return MaterialApp(
   title: 'Material App',
   home: Scaffold(
    appBar: AppBar(
     title: Text('Material App Bar'),
    ),
    body: Center(
     child: Container(
      child: Text(LoginVerify().selectAll()),
     ),
    ),
   ),
  );
 }
}

class LoginVerify  {
  MySqlConnection conn;
  LoginVerify(){
   init();
  }
  init() async {

  }
   selectAll (){
   var results = conn.query("select * from user");
   return results;
  }

}*/





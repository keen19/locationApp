
import 'package:sqljocky5/connection/connection.dart';

class ConnectionDb {
  MySqlConnection conn;

  getConnection() async {
    conn = await MySqlConnection.connect(ConnectionSettings(
        host: 'rm-wz9zt03rn0864rz8uho.mysql.rds.aliyuncs.com',
        port: 3306,
        user: 'keen',
        password: "Zxc000222",
        db: 'demo1'));
  }
}

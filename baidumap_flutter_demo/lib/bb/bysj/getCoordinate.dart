import 'database/ConnectionDB.dart';

class GetCoordinate with ConnectionDb{



  //上传坐标
  postCoordinate(double latitude,double longitude,String address)async{
    //连接数据库
    await getConnection();

    String sql = "update  user set latitude = ?,longitude=? where username=? values (?,?,?)";
    await conn.preparedWithAll(sql, [['$latitude','$longitude','$address']]);
  }
}
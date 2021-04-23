import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_utils/flutter_baidu_mapapi_utils.dart';
import 'package:flutter_bmflocation/bdmap_location_flutter_plugin.dart';
import 'package:flutter_bmflocation/flutter_baidu_location.dart';
import 'package:flutter_bmflocation/flutter_baidu_location_android_option.dart';
import 'package:flutter_bmflocation/flutter_baidu_location_ios_option.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:sensors/sensors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqljocky5/results/results.dart';
import 'database/ConnectionDB.dart';

import 'dart:io' show Platform;
import '../demo/GetLocationInfo.dart';
import '../basic.dart';

class LocDemo extends StatefulWidget {
  /*String username;

  LocDemo(this.username);*/

  @override
  LocDemoState createState() => LocDemoState();
}

class LocDemoState extends State<LocDemo>
    with AutomaticKeepAliveClientMixin, ConnectionDb,ChangeNotifier {
  //接收重力传感器数据
  List<StreamSubscription<dynamic>> _streamSubscriptions =
      <StreamSubscription<dynamic>>[];

  String username;
  double latitude;
  double longitude;
  String address;

/*
  LocDemoState(this.username);*/

  ///监控地址控制器
  static final TextEditingController monitorAddress = TextEditingController();

  Map<String, Object> locationResult;

  bool flag = false;

  GlobalKey buttonKey = GlobalKey();

  /// 定位结果
  BaiduLocation baiduLocation;

  LocationFlutterPlugin _locationPlugin = new LocationFlutterPlugin();

  ///定位监听器
  StreamSubscription<Map<String, Object>> _locationListener;

  getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString('username');
    print(username);
  }

  @override
  void initState() {
    super.initState();
    getUsername();
    getConnection();
    _locationPlugin.requestPermission();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (_locationListener != null) {
      _locationListener.cancel();
    }
    for (StreamSubscription<dynamic> subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  void _setLocOption() {
    /// android 端设置定位参数
    BaiduLocationAndroidOption androidOption = new BaiduLocationAndroidOption();
    androidOption.setCoorType("bd09ll"); // 设置返回的位置坐标系类型
    androidOption.setIsNeedAltitude(true); // 设置是否需要返回海拔高度信息
    androidOption.setIsNeedAddres(true); // 设置是否需要返回地址信息
    androidOption.setIsNeedLocationPoiList(false); // 设置是否需要返回周边poi信息
    androidOption.setIsNeedNewVersionRgc(true); // 设置是否需要返回最新版本rgc信息
    androidOption.setIsNeedLocationDescribe(true); // 设置是否需要返回位置描述
    androidOption.setOpenGps(true); // 设置是否需要使用gps
    androidOption.setLocationMode(LocationMode.Hight_Accuracy); // 设置定位模式
    androidOption.setScanspan(1000); // 设置发起定位请求时间间隔

    Map androidMap = androidOption.getMap();

    /// ios 端设置定位参数
    BaiduLocationIOSOption iosOption = new BaiduLocationIOSOption();
    iosOption.setIsNeedNewVersionRgc(true); // 设置是否需要返回最新版本rgc信息
    iosOption.setBMKLocationCoordinateType(
        "BMKLocationCoordinateTypeBMK09LL"); // 设置返回的位置坐标系类型
    iosOption.setActivityType("CLActivityTypeAutomotiveNavigation"); // 设置应用位置类型
    iosOption.setLocationTimeout(10); // 设置位置获取超时时间
    iosOption.setDesiredAccuracy("kCLLocationAccuracyBest"); // 设置预期精度参数
    iosOption.setReGeocodeTimeout(10); // 设置获取地址信息超时时间
    iosOption.setDistanceFilter(100); // 设置定位最小更新距离
    iosOption.setAllowsBackgroundLocationUpdates(true); // 是否允许后台定位
    iosOption.setPauseLocUpdateAutomatically(true); //  定位是否会被系统自动暂停

    Map iosMap = iosOption.getMap();

    ///配置Android端和iOS端定位参数
    _locationPlugin.prepareLoc(androidMap, iosMap);
  }

  void _startLocation() {
    _locationListener =
        _locationPlugin.onResultCallback().listen((Map<String, Object> result) {
      setState(() {
        locationResult = result;
        try {
          baiduLocation = BaiduLocation.fromMap(result);
          //print(baiduLocation);// 将原生端返回的定位结果信息存储在定位结果类中
        } catch (e) {
          print(e);
        }
      });
    });
    if (_locationPlugin != null) {
      _setLocOption();
      _locationPlugin.startLocation();
    }
  }

  void _stopLocation() {
    if (_locationPlugin != null) {
      _locationPlugin.stopLocation();
    }
  }

  //更新监控状态
  updateState(String username) async {
    String sql = "update user set state = ? where username=?";
    List<StreamedResults> results2 = await (await conn.preparedWithAll(sql, [
      ['n', '$username']
    ]))
        .toList();
  }
  //更新紧急状态
  updateEmergency(String username) async {
    String sql = "update user set emergency = ? where username=?";
    List<StreamedResults> results2 = await (await conn.preparedWithAll(sql, [
      ['n', '$username']
    ]))
        .toList();
  }

  //更新坐标地址
  updateLocation(String username, double latitude, double longitude,
      String address) async {
    String sql =
        "update user set latitude=?,longitude=?,address=? where username=? ";
    StreamedResults results = await conn
        .prepared(sql, [latitude, longitude, '$address', '$username']);
    //conn.close();
  }

  //计算两个坐标的距离
  calculateDistance(setLatitude, setLongitude) async {
    double distance;
    double scope = 50.0;
    await BMFCalculateUtils.getLocationDistance(
            BMFCoordinate(baiduLocation?.latitude, baiduLocation?.longitude),
            BMFCoordinate(setLatitude, setLongitude))
        .then((value) {
      distance = value;
      print(distance);
      print("aaaaa");
    });
    if (distance > scope) {
      updateState(username);
      print("$distance+米");
    }
    //print("$distance+米");
  }

  monitorFall() {
    double x;
    double y;
    double z;

    double count;

    double result = 35.0;

    ///不受重力影响的加速器
    _streamSubscriptions
        .add(userAccelerometerEvents.listen((UserAccelerometerEvent event) {
        x = event.x.abs();
        y = event.y.abs();
        z = event.z.abs();
        count = (x + y + z);
        if (count > result) {
          //list.add(Text("老人疑似摔倒"));
          //更新老人的状态为摔倒
          updateEmergency(username);
        }
    }));
  }

  double setLatitude;
  double setLongitude;
  String setAddress;
  Timer timer;

  Container _createButtonContainer() {
    return new Container(
        alignment: Alignment.center,
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new RaisedButton(
              onPressed: () {
                _startLocation();
              },
              child: new Text('开始定位'),
              color: Colors.blue,
              textColor: Colors.white,
            ),
            new Container(width: 20.0),
            new RaisedButton(
              key: buttonKey,
              onPressed: baiduLocation == null
                  ? null
                  : () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ShowUserLocationPage(
                                  baiduLocation?.latitude,
                                  baiduLocation?.longitude)));
                    },
              child: new Text('查看地图'),
              color: Colors.blue,
              textColor: Colors.white,
            ),
            Switch(
                value: flag,
                activeColor: Colors.red,
                onChanged: (value) async {
                  if (value == true) {
                    getConnection();
                    monitorFall();
                    //保存当前坐标为监控左边
                    setLatitude = baiduLocation?.latitude;
                    setLongitude = baiduLocation?.longitude;
                    setAddress = baiduLocation?.address;
                    //更新现在的坐标到数据库
                    await updateLocation(
                        username, setLatitude, setLongitude, setAddress);
                    timer = Timer.periodic(Duration(seconds: 30), (timer) {
                      calculateDistance(setLatitude, setLongitude);
                    });
                  } else {
                    //关闭数据库和计时器
                    timer.cancel();
                    conn.close();
                  }
                  setState(() {
                    this.flag = value;
                  });
                }),
            Text(
              "开启监控",
              style: TextStyle(
                color: Colors.red,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ));
  }

  // ignore: missing_return
  Widget _resultWidget(key, value) {
    return new Container(
      child: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text('$key:' ' $value'),
            ]),
      ),
    );
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    List<Widget> widgets = new List();

    if (locationResult != null) {
      locationResult.forEach((key, value) {
        if (key == 'latitude' ||
            key == 'address' ||
            key == 'longitude' ||
            key == 'locationDetail') {
          widgets.add(_resultWidget(key, value));
        }
        //widgets.add(_resultWidget(key, value));
      });
    }

    widgets.add(_createButtonContainer());
    return Scaffold(
      appBar: AppBar(title: Text("开启监控页面")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: widgets,
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_utils/flutter_baidu_mapapi_utils.dart';
import 'package:flutter_bmflocation/bdmap_location_flutter_plugin.dart';
import 'package:flutter_bmflocation/flutter_baidu_location.dart';
import 'package:flutter_bmflocation/flutter_baidu_location_android_option.dart';
import 'package:flutter_bmflocation/flutter_baidu_location_ios_option.dart';
import 'package:flutter_bmfmap_example/CustomWidgets/map_appbar.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart'
    show BMFCoordinate, BMFEdgeInsets, BMFMapSDK, BMFPoint, BMF_COORD_TYPE;


//import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //Provider.debugCheckInvalidValueType = null;
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

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Material App Bar'),
        ),
        body: GetLocationInfo(),
      ),
    );
  }
}

class GetLocationInfo extends StatefulWidget {
  @override
  _GetLocationInfoState createState() => _GetLocationInfoState();
}

class _GetLocationInfoState extends State<GetLocationInfo> {
  static LocationFlutterPlugin _locationPlugin = LocationFlutterPlugin();

  ///定位监听器
  StreamSubscription<Map<String, Object>> _locationListener;

  BaiduLocation baiduLocation;

  /// 我的位置
  BMFUserLocation _userLocation;

  //double latitude=LocDemo().createState().locationResult[latitude],longitude=LocDemo().createState().baiduLocation.longitude;
  /// 定位点样式
  BMFUserLocationDisplayParam _displayParam;

  Size screenSize;
  BMFMapOptions mapOptions;
  BMFMapController myMapController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _locationPlugin.requestPermission();

    _locationListener =
        _locationPlugin.onResultCallback().listen((Map<String, Object> result) {
      setState(() {
        try {
          // 将原生端返回的定位结果信息存储在定位结果类中
          baiduLocation = BaiduLocation.fromMap(result);
          mapOptions = BMFMapOptions(
              compassPosition: BMFPoint(0, 0),
              center: BMFCoordinate(
                  baiduLocation?.latitude ?? 0, baiduLocation?.longitude ?? 0),
              zoomLevel: 18,
              mapPadding:
                  BMFEdgeInsets(left: 30, top: 0, right: 30, bottom: 0));
        } catch (e) {
          print(e);
        }
      });
    });
    _setLocOption();
    _locationPlugin.startLocation();
  }

  /// 创建完成回调
  void onBMFMapCreated(BMFMapController controller) {
    myMapController = controller;

    /// 地图加载回调
    myMapController?.setMapDidLoadCallback(callback: () {
      print('mapDidLoad-地图加载完成');
    });

    ///展示图层
    myMapController?.showUserLocation(true);
  }

  /// 更新位置
  void updateUserLocation() {
    BMFCoordinate coordinate =
        BMFCoordinate(baiduLocation?.latitude, baiduLocation?.longitude);
    BMFLocation location = BMFLocation(
        coordinate: coordinate,
        altitude: 0,
        horizontalAccuracy: 5,
        verticalAccuracy: -1.0,
        speed: -1.0,
        course: -1.0);
    BMFUserLocation userLocation = BMFUserLocation(
      location: location,
    );
    _userLocation = userLocation;
    myMapController?.updateLocationData(_userLocation);
  }

  /// 更新定位图层样式
  void updateUserLocationDisplayParam() {
    BMFUserLocationDisplayParam displayParam = BMFUserLocationDisplayParam(
        locationViewOffsetX: 0,
        locationViewOffsetY: 0,
        accuracyCircleFillColor: Colors.red,
        accuracyCircleStrokeColor: Colors.blue,
        isAccuracyCircleShow: true,
        enableDirection: true,
        locationViewImage: 'Resources/animation_red.png',
        locationViewHierarchy:
            BMFLocationViewHierarchy.LOCATION_VIEW_HIERARCHY_BOTTOM);

    _displayParam = displayParam;
    myMapController?.updateLocationViewWithParam(_displayParam);
  }

  calculateDistance() {
    BMFCalculateUtils.getLocationDistance(BMFCoordinate(23.1288, 113.25898),
        BMFCoordinate(23.1091435, 113.319154)).then((value) =>
      print("两点之间的距离是:${value.toStringAsFixed(2)}米")
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (_locationListener != null) {
      _locationListener.cancel();
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
    androidOption.setScanspan(3000); // 设置发起定位请求时间间隔

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

  Widget generateMap() {
    return Container(
        height: screenSize.height,
        width: screenSize.width,
        child: StatefulBuilder(
          builder:
              (BuildContext context, void Function(void Function()) setState) {
            return BMFMapWidget(
              onBMFMapCreated: (controller) {
                setState(() {
                  onBMFMapCreated(controller);
                  updateUserLocation();
                  updateUserLocationDisplayParam();
                  calculateDistance();
                });
                // 经纬度BMFCoordinate构造方法
              },
              mapOptions: mapOptions,
            );
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return generateMap();
  }
}

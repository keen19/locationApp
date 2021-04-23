import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_bmfmap_example/CustomWidgets/map_appbar.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_bmfmap_example/CustomWidgets/map_raised_button.dart';
import 'package:flutter_bmfmap_example/DemoPages/Map/show_map_type_page.dart';
import 'package:flutter_bmfmap_example/constants.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';

/// 离线地图示例
class ShowOfflineMapPage extends StatefulWidget {
  ShowOfflineMapPage({Key key}) : super(key: key);

  @override
  _ShowOfflineMapPageState createState() => _ShowOfflineMapPageState();
}

class _ShowOfflineMapPageState extends State<ShowOfflineMapPage> {
  List<CityData> _hotCitys = []; // 热门城市
  List<CityData> _allCitys = []; // 全国城市
  List<UpdateData> _allUpdate = []; // 已下载城市

  OfflineController _offlineController = OfflineController(); // 离线地图管理类
  TextEditingController _cityController = TextEditingController();
  String _city = ""; // 城市名
  String _cityID = ""; // 城市id
  int _ratio = 0; // 下载进度
  int _segmentSelectedIdx = 0; // 城市列表 下载管理切换

  @override
  void initState() {
    super.initState();

    if (Platform.isAndroid) {
      requestPermiss();
    }

    /// 离线地图管理类初始化
    _offlineController.init();

    /// 离线地图管理类注册回调
    _offlineController.onGetOfflineMapStateBack(
        callback: _onGetOfflineMapStateBack);

    /// 获取热门城市
    _getHotCity();

    /// 获取全国城市
    _getOfflineCityList();

    ///
    _getAllUpdateInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: BMFAppBar(
        title: '离线地图示例',
      ),
      body: Container(
        padding: EdgeInsets.only(left: 10, right: 10, top: 5),
        child: Column(children: <Widget>[
          _searchBar(),
          _downloadBar(),
          _listSegmentedControl(),
          _segmentSelectedIdx == 0 ? _cityList() : _downloadList(),
        ]),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _offlineController?.destroyOfflineMap();
  }

  // -----------------------------------------------------------------
  /// 搜索
  void _onPressedSearch() async {
    List<BMFOfflineCityRecord> cityList;
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      _cityID = "";
      _ratio = 0;
    });

    if (_city != null) {
      cityList = await _offlineController?.searchCity(_city);
      int ratio = _getCityDownloadRatio(cityList[0].cityID);

      setState(() {
        _cityID = cityList[0].cityID.toString();
        _ratio = ratio;
      });
    }
  }

  /// 下载
  void _onPressedDownload() async {
    if (_cityID != null) {
      setState(() {
        _segmentSelectedIdx = 1;
      });
      await _offlineController?.startOfflineMap(int.parse(_cityID));
    }
  }

  /// 暂停
  void _onPressedPause() async {
    if (_cityID != null) {
      await _offlineController?.pauseOfflineMap(int.parse(_cityID));
    }
  }

  /// 删除
  void _onPressedDelete() async {
    if (_cityID.isNotEmpty) {
      await _offlineController?.removeOfflineMap(int.parse(_cityID));
      setState(() {
        _removeCityFromDownloaded(int.parse(_cityID));
      });
    }
  }

  /// 城市列表 下载管理
  void _listSegmentedOnValueChanged(int idx) {
    setState(() {
      _segmentSelectedIdx = idx;
    });
  }

  /// 下载回调
  void _onGetOfflineMapStateBack(int state, int cityID) {
    switch (state) {
      case OfflineController.TYPE_DOWNLOAD_UPDATE:
        _setUpdateInfo(cityID);
        // 处理下载进度更新提示
        break;

      case OfflineController.TYPE_NEW_OFFLINE:
        // 有新离线地图安装
        break;

      case OfflineController.TYPE_VER_UPDATE:
        // 版本更新提示
        // MKOLUpdateElement e = mOffline.getUpdateInfo(state);
        break;

      default:
        break;
    }
  }

  /// 选中城市
  void _onTapCityListItem(CityData cityData) {
    if (cityData == null) return;

    _cityController.text = cityData.cityName;
    _cityID = "${cityData.cityID}";
    _ratio = _getCityDownloadRatio(cityData.cityID);
    setState(() {});
  }

  /// 选中下载城市
  void _onTapDownloadListItem(UpdateData updateData) {
    _cityController.text = updateData.cityName;
    setState(() {
      _cityID = "${updateData.cityId}";
      _ratio = updateData.ratio;
    });
  }

  void _textFieldChanged(String str) {
    _city = str;
    if ((null == _city || "" == _city)) {
      setState(() {
        _ratio = 0;
        _cityID = "";
      });
    }
  }

  // -----------------------------------------------------------------

  void _setUpdateInfo(int cityID) async {
    if (!mounted) return;

    if (_offlineController == null) return;

    BMFUpdateElement updateInfo =
        await _offlineController.getUpdateInfo(cityID);

    if (updateInfo == null) return;

    bool updateRatio = false;
    if (_cityID.isNotEmpty) {
      updateRatio = updateInfo.cityID == int.parse(_cityID);
    }

    _updateDownloadInfo(updateInfo, updateRatio);
  }

  void _updateDownloadInfo(BMFUpdateElement update, bool updateRatio) {
    setState(() {
      if (update != null) {
        if (updateRatio) {
          _ratio = update.ratio;
        }

        int idx = _isCityDownloaded(update.cityID);
        if (idx != -1) {
          UpdateData updateData = _allUpdate[idx];
          updateData.ratio = update.ratio;
          updateData.size = update.size;
        } else {
          UpdateData updateData = UpdateData(update.cityName, update.ratio,
              update.size, update.cityID, update.geoPt);
          _allUpdate.add(updateData);
        }
      }
    });
  }

  int _getCityDownloadRatio(int cityID) {
    int idx = _isCityDownloaded(cityID);
    return idx != -1 ? _allUpdate[idx].ratio : 0;
  }

  int _isCityDownloaded(int cityID) {
    return _allUpdate.indexWhere((element) => element.cityId == cityID);
  }

  void _removeCityFromDownloaded(int cityID) {
    _allUpdate.removeWhere((element) => element.cityId == cityID);
    if (_ratio > 0) {
      setState(() {
        _ratio = 0;
      });
    }
    _cityID = "";
    _cityController.text = "";
  }

  String _getSizeStr(int size) {
    String sizeStr;
    if (size >= TBBounds) {
      sizeStr = (size / TBBounds).toStringAsFixed(1) + "T";
    } else if (size >= GBBounds) {
      sizeStr = (size / GBBounds).toStringAsFixed(1) + "G";
    } else if (size >= MBBounds) {
      sizeStr = (size / MBBounds).toStringAsFixed(1) + "M";
    } else if (size >= KBBounds) {
      sizeStr = (size / KBBounds).toStringAsFixed(1) + "K";
    } else {
      sizeStr = size.toString() + "Byte";
    }

    return sizeStr;
  }

  requestPermiss() async {
    Future<bool> isGranted = Permission.storage.isGranted;

    isGranted.then((value) => {
          if (null != value && false == value) {Permission.storage.request()}
        });
  }

  // -----------------------------------------------------------------

  /// 获取热门城市
  Future _getHotCity() async {
    List<BMFOfflineCityRecord> cityList =
        await _offlineController?.getHotCityList();
    if (null == cityList) {
      return;
    }
    for (var value in cityList) {
      CityData hotCityData =
          CityData(value.cityName, value.cityID, value.dataSize);
      _hotCitys.add(hotCityData);
    }

    setState(() {});
  }

  /// 获取全国城市
  Future _getOfflineCityList() async {
    List<BMFOfflineCityRecord> cityList =
        await _offlineController?.getOfflineCityList();
    if (null == cityList) {
      return;
    }

    for (var value in cityList) {
      CityData hotCityData =
          CityData(value.cityName, value.cityID, value.dataSize);
      _allCitys.add(hotCityData);
    }

    setState(() {});
  }

  /// 获取下载状态
  void _getAllUpdateInfo() async {
    List<BMFUpdateElement> update =
        await _offlineController?.getAllUpdateInfo();

    if (update == null) return;

    for (var value in update) {
      UpdateData updateData = UpdateData(
          value.cityName, value.ratio, value.size, value.cityID, value.geoPt);
      _allUpdate.add(updateData);
    }
    setState(() {});
  }

  // -----------------------------------------------------------------

  /// 搜索栏
  Widget _searchBar() {
    return Container(
      child: Column(
        children: <Widget>[
          Row(children: <Widget>[
            Expanded(
              child: Container(
                height: 35,
                child: TextField(
                  controller: _cityController,
                  autofocus: false,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 10.0),
                    hintText: '请输入下载城市',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(
                            color: Color(int.parse(Constants.btnColor)))),
                  ),
                  onChanged: _textFieldChanged,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                color: Color(int.parse(Constants.btnColor)),
                textColor: Colors.white,
                child: new Text("搜索"),
                onPressed: _onPressedSearch,
              ),
            )
          ]),
          Container(
            child: Row(
              children: <Widget>[
                Text("城市id:$_cityID"),
                SizedBox(width: 20),
                Text(" 已下载:$_ratio%"),
              ],
            ),
          )
        ],
      ),
    );
  }

  /// 下载控制栏
  Widget _downloadBar() {
    return Container(
      margin: EdgeInsets.only(top: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          BMFRaisedButton(
            title: "下载",
            onPressed: _onPressedDownload,
          ),
          BMFRaisedButton(
            title: "暂停",
            onPressed: _onPressedPause,
          ),
          BMFRaisedButton(
            title: "删除",
            onPressed: _onPressedDelete,
          ),
        ],
      ),
    );
  }

  /// 城市列表、下载管理
  Widget _listSegmentedControl() {
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      margin: EdgeInsets.only(top: 10, bottom: 10),
      child: CupertinoSlidingSegmentedControl(
        groupValue: _segmentSelectedIdx,
        children: {
          0: Text("城市列表"),
          1: Text("下载管理"),
        },
        onValueChanged: _listSegmentedOnValueChanged,
      ),
    );
  }

  /// 城市列表
  Widget _cityList() {
    return Container(
      child: Expanded(
        child: ListView.separated(
            shrinkWrap: true,
            itemBuilder: _cityListItemBuilder,
            separatorBuilder: _separatorBuilder,
            itemCount: _hotCitys.length + _allCitys.length + 2),
      ),
    );
  }

  /// 城市列表 item
  Widget _cityListItemBuilder(BuildContext context, int index) {
    if (index == 0) {
      return _cityListSectionItem("热门城市:");
    } else if (index == _hotCitys.length + 1) {
      return _cityListSectionItem("全国城市:");
    } else {
      CityData citydata;
      if (index <= _hotCitys.length) {
        citydata = _hotCitys[index - 1];
      } else {
        citydata = _allCitys[index - _hotCitys.length - 2];
      }

      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: 35.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Text(
                  "${citydata.cityName}" + "(${citydata.cityID})",
                  style: _cityListItemTitleStyle,
                ),
              ),
              Container(
                child: Text(
                  _getSizeStr(citydata.dateSize),
                  style: new TextStyle(fontSize: 18.0, color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          _onTapCityListItem(citydata);
        },
      );
    }
  }

  /// 城市列表 section header
  Widget _cityListSectionItem(String title) {
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: Text(title, style: _cityListSectionTitleStyle),
    );
  }

  /// 下载管理列表
  Widget _downloadList() {
    return Container(
      child: Expanded(
        child: ListView.separated(
          shrinkWrap: true,
          itemBuilder: _downloadListItemBuilder,
          separatorBuilder: _separatorBuilder,
          itemCount: _allUpdate.length,
        ),
      ),
    );
  }

  /// 下载管理列表item
  Widget _downloadListItemBuilder(BuildContext context, int index) {
    UpdateData updateData = _allUpdate[index];
    BMFCoordinate geoPt = updateData.geoPt;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 35.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: Text(
                "${updateData.cityName}" + "(${_getSizeStr(updateData.size)})",
                style: _cityListItemTitleStyle,
              ),
            ),
            Container(
              child: Text(
                "${updateData.ratio}%",
                style: new TextStyle(fontSize: 18.0, color: Colors.blue),
              ),
            ),
            BMFRaisedButton(
                title: "查看", onPressed: () => {_onOpenMapClick(geoPt)}),
          ],
        ),
      ),
      onTap: () {
        _onTapDownloadListItem(updateData);
      },
    );
  }

  void _onOpenMapClick(BMFCoordinate geoPt) {
    BMFMapOptions mapOptions = BMFMapOptions(
        mapType: BMFMapType.Standard,
        zoomLevel: 13,
        maxZoomLevel: 21,
        minZoomLevel: 4,
        showMapPoi: true,
        logoPosition: BMFLogoPosition.LeftBottom,
        mapPadding: BMFEdgeInsets(top: 0, left: 50, right: 50, bottom: 0),
        overlookEnabled: true,
        overlooking: -15,
        center: geoPt);

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => ShowMapTypePage(customMapOptions: mapOptions)),
    );
  }

  /// 列表分割线
  Widget _separatorBuilder(BuildContext context, int index) {
    return Divider(
      height: 1,
      indent: 0,
      endIndent: 0,
      color: Colors.black26,
    );
  }
}

class CityData {
  /// 城市名称
  String cityName;

  /// 城市id
  int cityID;

  /// 数据大小
  int dateSize;

  CityData(this.cityName, this.cityID, this.dateSize);
}

class UpdateData {
  /// 城市名称
  String cityName;

  /// 下载比率，100为下载完成
  int ratio;

  /// 已下载数据大小
  int size;

  /// 城市id
  int cityId;

  /// 城市经纬度
  BMFCoordinate geoPt;

  UpdateData(this.cityName, this.ratio, this.size, this.cityId, this.geoPt);
}

final _cityListItemTitleStyle = TextStyle(
  fontSize: 16.0,
  color: Colors.black,
);

final _cityListSectionTitleStyle = TextStyle(
  fontSize: 16.0,
  fontWeight: FontWeight.w600,
);

const int TBBounds = 1024 * 1024 * 1024 * 1024;
const int GBBounds = 1024 * 1024 * 1024;
const int MBBounds = 1024 * 1024;
const int KBBounds = 1024;

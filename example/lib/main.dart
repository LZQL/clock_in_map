import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:clock_in_map/clock_in_map.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'calculate_mylocation_usethislocation_distance_page.dart';
import 'system_screen_util.dart';
import 'navigator_util.dart';
import 'location_once_page.dart';
import 'locations_page.dart';
import 'calculate_line_distance_page.dart';
import 'image_button.dart';
import 'search_page.dart';
import 'toast_util.dart';

void main() {
  runApp(MyApp());
  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      home: MainRoute(),
    );
  }
}

class MainRoute extends StatefulWidget {
  @override
  _MainRouteState createState() => _MainRouteState();
}

class _MainRouteState extends State<MainRoute> {
  String _platformVersion = 'Unknown';
  String address = "";

  double centerPointLatitude; // 中心点 维度

  double centerPointLongitude; // 中心点 经度

  bool hasPermission = false;

  double clockInPointLatitude = 0;
  double clockInPointLongitude = 0;

  bool isLoadAddresss = true;

  ///=============================== 系统方法 =================================================

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getPermission();
    });

    initClockInPoint();
  }

  ///================================= 布局 =================================================

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('高德地图打卡Demo'),
            actions: <Widget>[
              PopupMenuButton(
                itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
                  PopupMenuItem<String>(
                    child: Text("单次定位"),
                    value: "locationOnce",
                  ),
                  PopupMenuItem<String>(
                    child: Text("连续定位"),
                    value: "locations",
                  ),
                  PopupMenuItem<String>(
                    child: Text("计算两点之间的距离"),
                    value: "calculateLineDistance",
                  ),
                  PopupMenuItem<String>(
                    child: Text("实时计算我的位置和使用此位置之间的距离"),
                    value: "CalculateMyLocationUseThisLocationDistance",
                  ),
                ],
                onSelected: (String action) {
                  switch (action) {
                    case "locationOnce":
                      goLoactionOncePage();
                      break;
                    case "locations":
                      goLoactionsPage();
                      break;
                    case "calculateLineDistance":
                      goCalculateLineDistancePage();
                      break;
                    case "CalculateMyLocationUseThisLocationDistance":
                      goCalculateMyLocationUseThisLocationDistancePage();
                      break;
                  }
                },
                onCanceled: () {
                  print("onCanceled");
                },
              )
            ],
          ),
          body: hasPermission
              ? Stack(
                  children: <Widget>[
                    /// 地图 Widge
                    CIMMapView(
                      onCenterPoint: onCenterPoint,
                      clockInLongitude: clockInPointLongitude,
                      clockInLatitude: clockInPointLatitude,
                    ),

                    /// 搜索 按钮
                    buildSearchButton(),

                    /// 地图 中心点 widget
                    buildMapCenterWidget(),

                    /// 我的位置 按钮
                    buildMyLocationButton(),

                    /// 使用此位置 按钮
                    buildUseThisLocationButton(),
                  ],
                )
              : Center(
                  child: Text('请赋予权限'),
                )),
    );
  }

  // 搜索按钮
  Widget buildSearchButton() {
    return Positioned(
      left: 16,
      right: 16,
      top: 10,
      child: Container(
        width: SystemScreenUtil.getInstance().screenWidth - 32,
        height: 33,
        decoration: BoxDecoration(
          border: Border.all(
            color: Color(0x14000000),
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(33),
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              color: Color(0x14000000),
              offset: Offset(0.5, 0.5),
            )
          ],
        ),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(33),
          child: InkWell(
            onTap: goSearchPage,
            child: Row(
              children: <Widget>[
                Padding(padding: EdgeInsets.only(left: 14)),
                Image.asset(
                  'assets/images/home_icon_search.png',
                  width: 13,
                  height: 13,
                  color: Color(0xFF999999),
                ),
                Padding(padding: EdgeInsets.only(left: 8)),
                Text(
                  '搜索地址',
                  style: TextStyle(fontSize: 13, color: Color(0xFF999999)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 地图 中心点 widget
  Widget buildMapCenterWidget() {
    return Positioned(
      bottom: (SystemScreenUtil.getInstance().screenHeight -
              SystemScreenUtil.getInstance().statusBarHeight -
              56 -
              SystemScreenUtil.getInstance().bottomBarHeight) /
          2,
      child: Container(
        width: SystemScreenUtil.getInstance().screenWidth,
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  '$address',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF333333),
                  ),
                  textAlign: TextAlign.center,
                )),
            Image.asset(
              'assets/images/project_img_setting_position.png',
              width: 20,
              height: 25,
            ),
          ],
        ),
      ),
    );
  }

  // 我的位置 按钮
  Widget buildMyLocationButton() {
    return Positioned(
      top: 83,
      right: 23,
      child: ImageButton(
        onPress: loactionClick,
        imagePath: 'assets/images/project_icon_mapposition.png',
        width: 50,
        height: 50,
        imageWidth: 32,
        imageHeight: 32,
      ),
    );
  }

  // 使用此位置 按钮
  Widget buildUseThisLocationButton() {
    return Positioned(
      bottom: 25,
      child: Container(
        width: SystemScreenUtil.getInstance().screenWidth - 40,
        height: 45,
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: RaisedButton(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.elliptical(20, 20),
                  bottomLeft: Radius.elliptical(20, 20),
                  bottomRight: Radius.circular(20)),
            ),
            onPressed: usetThisLocaiton,
            textColor: Colors.white,
            color: Theme.of(context).primaryColor,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text('使用此位置'),
            )),
      ),
    );
  }

  ///================================= 点击事件 ===============================================

  // 跳转到 单次定位 页面
  void goLoactionOncePage() {
    NavigagatorUtil.pushPage(context, LocationOncePage());
  }

  // 跳转到 连续定位 页面
  void goLoactionsPage() {
    NavigagatorUtil.pushPage(context, LocationsPage());
  }

  // 跳转到 计算两点之间的距离 页面
  void goCalculateLineDistancePage() {
    NavigagatorUtil.pushPage(context, CalculateLineDistancePage());
  }

  // 跳转到 实时计算 我的位置 和 上一个页面使用此位置所保存的地址 之间的距离 页面
  void goCalculateMyLocationUseThisLocationDistancePage() {
    NavigagatorUtil.pushPage(
        context, CalculateMyLocationUseThisLocationDistancePage());
  }

  // 跳转到 搜索 页面
  void goSearchPage() async {
    LatLng latLng = await NavigagatorUtil.pushPageResult(context, SearchPage());

    if (latLng != null) {
      CIMMap.moveCameraToPoint(latLng);
    }
  }

  // 使用此位置按钮
  void usetThisLocaiton() async {
    if (isLoadAddresss) {
      ToastUtil.showShort('请稍后，正在加载地址信息', context);
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('centerPointLatitude', centerPointLatitude);
      await prefs.setDouble('centerPointLongitude', centerPointLongitude);
      drawClockInPoint(centerPointLatitude, centerPointLongitude);
    }
  }

  // 定位按钮
  void loactionClick() {
//    print('loactionClick');

    CIMMap.getMyLocation();
  }

  ///================================= 逻辑方法 ===============================================

  // 请求权限
  void getPermission() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      PermissionStatus permission_location = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.location);
      PermissionStatus permission_photos = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.phone);
      PermissionStatus permission_storage = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.storage);

      if (permission_location != PermissionStatus.granted ||
          permission_photos != PermissionStatus.granted ||
          permission_storage != PermissionStatus.granted) {
        List<PermissionGroup> permissions = <PermissionGroup>[
          PermissionGroup.location,
          PermissionGroup.phone,
          PermissionGroup.storage
        ];
        Map<PermissionGroup, PermissionStatus> permissionRequestResult =
            await PermissionHandler().requestPermissions(permissions);

        PermissionStatus locationStatus =
            permissionRequestResult[PermissionGroup.location];
        PermissionStatus phoneStatus =
            permissionRequestResult[PermissionGroup.phone];
        PermissionStatus storageStatus =
            permissionRequestResult[PermissionGroup.storage];

        if (locationStatus == PermissionStatus.granted &&
            phoneStatus == PermissionStatus.granted &&
            storageStatus == PermissionStatus.granted) {
          print('请求权限成功');
          setState(() {
            hasPermission = true;
          });
        } else {
          print('请求权限失败');
          setState(() {
            hasPermission = false;
          });
        }
      } else {
        setState(() {
          hasPermission = true;
        });
      }
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      PermissionStatus permission_location = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.location);

      if (permission_location != PermissionStatus.granted) {
        List<PermissionGroup> permissions = <PermissionGroup>[
          PermissionGroup.location,
        ];
        Map<PermissionGroup, PermissionStatus> permissionRequestResult =
            await PermissionHandler().requestPermissions(permissions);

        PermissionStatus locationStatus =
            permissionRequestResult[PermissionGroup.location];

        if (locationStatus == PermissionStatus.granted) {
          print('请求权限成功');
          setState(() {
            hasPermission = true;
          });
        } else {
          print('请求权限失败');
          setState(() {
            hasPermission = false;
          });
        }
      } else {
        setState(() {
          hasPermission = true;
        });
      }
    }
  }

  // 初始化 打卡位置 图标
  void initClockInPoint() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    clockInPointLatitude = prefs.getDouble('centerPointLatitude');
    clockInPointLongitude = prefs.getDouble('centerPointLongitude');
    setState(() {});
  }

  // 画 打卡地点 标记
  void drawClockInPoint(centerPointLatitude, centerPointLongitude) {
    CIMMap.drawClockInPoint(
        new LatLng(centerPointLatitude, centerPointLongitude));
  }

  // 更新中心点 widget 的位置信息 回调
  void onCenterPoint(LocationModel centerPoint) {
    if (centerPoint.address == null) {
      isLoadAddresss = true;
      return;
    } else {
      isLoadAddresss = false;

      address = centerPoint.address;
      centerPointLatitude = centerPoint.latitude;
      centerPointLongitude = centerPoint.longitude;
      print('center:  $centerPointLatitude,$centerPointLongitude');
      setState(() {});
    }
  }
}

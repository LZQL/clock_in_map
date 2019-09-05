import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:clock_in_map/clock_in_map.dart';
/// 实时计算 我的位置 和 上一个页面使用此位置所保存的地址 之间的距离
class CalculateMyLocationUseThisLocationDistancePage extends StatefulWidget {
  @override
  _CalculateMyLocationUseThisLocationDistancePageState createState() =>
      _CalculateMyLocationUseThisLocationDistancePageState();
}

class _CalculateMyLocationUseThisLocationDistancePageState
    extends State<CalculateMyLocationUseThisLocationDistancePage> {
  double centerPointLatitude;
  double centerPointLongitude;
  double distance;

  LatLng useThisLocationLatLng;

  bool startCalculate = false;

  @override
  void initState() {
    super.initState();
    getUseThisLocation();
  }

  // 获取 打开 地址 信息
  void getUseThisLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    centerPointLatitude = prefs.getDouble('centerPointLatitude');
    centerPointLongitude = prefs.getDouble('centerPointLongitude');

    if (centerPointLatitude != null && centerPointLongitude != null) {
      startCalculate = true;
      useThisLocationLatLng = new LatLng(centerPointLatitude, centerPointLongitude);
      setState(() {});
      locations();
    }
  }

  //  实时定位
  void locations() async {
    CIMLocation.getLocations().listen((location){
      LatLng mylocationLatLng = LatLng(location.latitude, location.longitude);
      calculateLineDistance(mylocationLatLng);
    });
  }

  // 停止定位
  void stopLocation(){
    CIMLocation.stopLocation();
  }

  //  计算距离
  void calculateLineDistance(LatLng mylocationLatLng) async {

    CIMUtil.calculateLineDistance(useThisLocationLatLng, mylocationLatLng).then((d) {
      setState(() {
        distance = double.tryParse(d.toStringAsFixed(2));
      });
      print(distance);
    });
  }

  @override
  void dispose() {
    stopLocation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('实时计算距离'),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Text(
            '实时计算 我的位置 和 上一个页面使用此位置所保存的地址 之间的距离',
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            '上个页面使用此位置保存的地址是：Latitude：$centerPointLatitude,Longitude:$centerPointLongitude',
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            startCalculate
                ? '$distance米'
                : '请先去上一个页面 设置一个打卡地点 ，点击使用此位置进行保存 打卡地址',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

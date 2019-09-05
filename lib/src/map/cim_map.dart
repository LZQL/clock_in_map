import 'dart:convert';

import 'package:flutter/services.dart';

import '../../clock_in_map.dart';

class CIMMap {
  static const _cimMapCenterEventChannel = EventChannel('cim/map_center_event');

  // 获取地图中间位置 的 地址信息
  static Stream<LocationModel> getMapCenterAddress() {
    return _cimMapCenterEventChannel
        .receiveBroadcastStream()
        .map((result) => result as String)
        .map((resultJson) => LocationModel.fromJson(jsonDecode(resultJson)));
  }

  static const _cimMapMethodChannel = MethodChannel('cim/map_center');

  // 我的位置
  static void getMyLocation() {
    _cimMapMethodChannel.invokeMethod('map#getMyLocation');
  }

  // 移动到指定位置
  static void moveCameraToPoint(LatLng latLng){
    Map<String, dynamic> params = {
      "point": latLng.toJson(),
    };

    _cimMapMethodChannel.invokeMethod('map#moveCamera',params);
  }

  // 绘制 打卡地点 图标
  static void drawClockInPoint(LatLng latLng){
    Map<String, dynamic> params = {
      "point": latLng.toJson(),
    };

    _cimMapMethodChannel.invokeMethod('map#drawClockInPoint',params);
  }
}

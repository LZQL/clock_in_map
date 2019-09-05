import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:clock_in_map/src/model/location_model.dart';

///  定位相关

class CIMLocation {
  static const MethodChannel _cimLocationChannel =
      const MethodChannel('cim/location');
  static const _cimLocationEventChannel =
      EventChannel('cim/location_event');

  // 单次定位
  static Future<LocationModel> getLocationOnce() {
    _cimLocationChannel.invokeMethod('location#getLocationOnce');

    return _cimLocationEventChannel
        .receiveBroadcastStream()
        .map((result) => result as String)
        .map((resultJson) => LocationModel.fromJson(jsonDecode(resultJson)))
        .first;
  }

  // 连续定位
  static Stream<LocationModel> getLocations() {
    _cimLocationChannel.invokeMethod('location#getLocations');

    return _cimLocationEventChannel
        .receiveBroadcastStream()
        .map((result) => result as String)
        .map((resultJson) => LocationModel.fromJson(jsonDecode(resultJson)));
  }

  // 停止定位
  static void stopLocation() {
    _cimLocationChannel.invokeMethod('location#stopLocation');
  }


}

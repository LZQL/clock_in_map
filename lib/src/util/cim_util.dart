import 'package:flutter/services.dart';

import '../../clock_in_map.dart';

class CIMUtil {

  static const MethodChannel _cimUtilsChannel =
      const MethodChannel('cim/util');


  // 计算两点之间的距离
  static Future<double> calculateLineDistance(LatLng latLng1, LatLng latLng2) async{

    Map<String, dynamic> params = {
      "p1": latLng1.toJson(),
      "p2": latLng2.toJson(),
    };

    double length = await _cimUtilsChannel.invokeMethod('util#calculateLineDistance',params);

    return length;
  }

}

import 'dart:convert';

import 'package:flutter/services.dart';

import '../../clock_in_map.dart';

class CIMSearch {
  static const MethodChannel _cimSearchChannel =
      const MethodChannel('cim/search');

  static Future<List<Tip>> searchAddress(String keyword) async {
    Map<String, String> params = {
      "keyword": keyword,
    };
    List<Tip> tips = new List();
    String tipJsonStr =
        await _cimSearchChannel.invokeMethod('search#searchAddress', params);
    (json.decode(tipJsonStr) as List).forEach((value) {
      tips.add(Tip.fromJson(value));
    });
//    List<Tip> tips
    return tips;
  }
}

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../clock_in_map.dart';

class CIMMapView extends StatefulWidget {
  final Function(LocationModel) onCenterPoint;
  final double clockInLatitude; // 已经设置的 打卡地点 维度
  final double clockInLongitude; // 已经设置的 打卡地点 经度

  const CIMMapView(
      {Key key,
      this.onCenterPoint,
      this.clockInLatitude,
      this.clockInLongitude})
      : super(key: key);

  @override
  _CIMMapViewState createState() => _CIMMapViewState();
}

class _CIMMapViewState extends State<CIMMapView> {
  EventChannel mapCenterEventChannel;

  MethodChannel methodChannel;

  Future<dynamic> handleMethod(MethodCall call) async {
    if (call.method == "map#getCenterPoint") {
      Map args = call.arguments;
      String centerPointJson = args["centerPointJson"];
      LocationModel locationModel =
          LocationModel.fromJson(json.decode(centerPointJson));
      widget.onCenterPoint(locationModel);
    }

    return new Future.value("");
  }

  _onPlatformViewCreated(id){
    print('onPlatformViewCreated:$id');
    methodChannel = MethodChannel('cim/map_center');
    methodChannel.setMethodCallHandler(handleMethod);
  }

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: "cim/mapview",
        onPlatformViewCreated: _onPlatformViewCreated,
        creationParams: _CreationParams.fromWidget(widget).toMap(),
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
//      return UiKitView(
//        viewType: "cim/mapview",
//        onPlatformViewCreated: _onPlatformViewCreated,
//        creationParams: _CreationParams.fromWidget(widget).toMap(),
//        creationParamsCodec: const StandardMessageCodec(),
//      );
      return Text('IOS 暂未支持');
    }

    return Text('该平台暂未支持');
  }
}

/// 需要更多的初始化配置，可以在此处添加
class _CreationParams {
  final double clockInLatitude;
  final double clockInLongitude;

  _CreationParams({this.clockInLatitude, this.clockInLongitude});

  static _CreationParams fromWidget(CIMMapView widget) {
    return _CreationParams(
      clockInLatitude: widget.clockInLatitude,
      clockInLongitude: widget.clockInLongitude,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'clockInLatitude': clockInLatitude,
      'clockInLongitude': clockInLongitude,
    };
  }
}

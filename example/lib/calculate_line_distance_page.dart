import 'package:flutter/material.dart';
import 'package:clock_in_map/clock_in_map.dart';

/// 计算两点之间的距离

class CalculateLineDistancePage extends StatefulWidget {
  @override
  _CalculateLineDistancePageState createState() =>
      _CalculateLineDistancePageState();
}

class _CalculateLineDistancePageState extends State<CalculateLineDistancePage> {
//  LocationModel locationModel;

  double distance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('计算两点之间的距离'),
      ),
      body: Column(
        children: <Widget>[
          RaisedButton(
            child: Text(
                '开始计算 目前我的这两个点的位置是写死的，分别是 39.92421, 116.39786  和  39.92379, 116.39774'
                    '(这个可以和连续定位配合，实时计算打卡地点和你的位置的距离)'),
            onPressed: calculateLineDistance,
          ),
          distance != null ? Text('$distance米') : Container()
        ],
      ),
    );
  }

  void calculateLineDistance() async {
    LatLng l1 = new LatLng(39.92421, 116.39786);
    LatLng l2 = new LatLng(39.92379, 116.39774);

    CIMUtil.calculateLineDistance(l1, l2).then((d) {
      setState(() {
        distance = double.tryParse(d.toStringAsFixed(2));
      });
    });
  }
}

import 'package:flutter/material.dart';
import 'package:clock_in_map/clock_in_map.dart';
/// 单次定位
class LocationOncePage extends StatefulWidget {
  @override
  _LocationOncePageState createState() => _LocationOncePageState();
}

class _LocationOncePageState extends State<LocationOncePage> {

  LocationModel locationModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('单次定位'),
      ),
      body: Column(
        children: <Widget>[
          RaisedButton(
            child: Text('开始定位'),
            onPressed: locationOnce,
          ),
          locationModel!=null?Text('${locationModel.toJson().toString()}'):Container()

        ],
      ),
    );
  }

  void locationOnce() async {
    LocationModel  location = await CIMLocation.getLocationOnce();
    setState(() {
      locationModel = location;
    });
  }
}

import 'package:flutter/material.dart';
import 'package:clock_in_map/clock_in_map.dart';
/// 连续定位
class LocationsPage extends StatefulWidget {
  @override
  _LocationsPageState createState() => _LocationsPageState();
}

class _LocationsPageState extends State<LocationsPage> {

  List<LocationModel> locationModels;

  @override
  void initState() {
    locationModels = new List();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('连续定位'),
      ),
      body: Column(
        children: <Widget>[
          RaisedButton(
            child: Text('开始 连续 定位'),
            onPressed: locations,
          ),
          RaisedButton(
            child: Text('停止 定位'),
            onPressed: stopLocation,
          ),
          Expanded(
            child: ListView.builder(padding: EdgeInsets.all(0.0),
              itemBuilder: (context, index) {
                return Text('${locationModels[index].toJson().toString()}');
              },
              itemCount:
              (null == locationModels ? 0 : locationModels.length),),
          )


        ],
      ),
    );
  }

  void locations() async {
    CIMLocation.getLocations().listen((location){
      locationModels.add(location);
      setState(() {});
    });
  }

  void stopLocation(){
    CIMLocation.stopLocation();
  }

  @override
  void dispose() {
    stopLocation();
    super.dispose();
  }
}

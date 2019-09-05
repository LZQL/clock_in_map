import 'latlng.dart';
/// 搜索结果
class Tip{

  String name;
  String address;
  LatLng latLonPoint;
  String district;

  Tip(
      {this.address,
        this.name,
        this.latLonPoint,
        this.district});

  Tip.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    address = json['address'];
    if(json['latLonPoint'] != null){
      latLonPoint = LatLng.fromJson(json['latLonPoint']);
    }
    district = json['district'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['address'] = this.address;
    if(this.latLonPoint != null){
      data['latLonPoint'] = this.latLonPoint;
    }
    data['district'] = this.district;
    return data;
  }
}
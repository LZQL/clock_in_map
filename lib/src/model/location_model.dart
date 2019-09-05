class LocationModel {
  String address;
  String city;
  String cityCode;
  String district;
  int errorCode;
  String errorInfo;
  double latitude;
  double longitude;
  String province;

  LocationModel(
      {this.address,
        this.city,
        this.cityCode,
        this.district,
        this.errorCode,
        this.errorInfo,
        this.latitude,
        this.longitude,
        this.province});

  LocationModel.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    city = json['city'];
    cityCode = json['cityCode'];
    district = json['district'];
    errorCode = json['errorCode'];
    errorInfo = json['errorInfo'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    province = json['province'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['city'] = this.city;
    data['cityCode'] = this.cityCode;
    data['district'] = this.district;
    data['errorCode'] = this.errorCode;
    data['errorInfo'] = this.errorInfo;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['province'] = this.province;
    return data;
  }
}

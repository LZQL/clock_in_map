package com.zeking.clock_in_map.model;

import com.amap.api.location.AMapLocation;

public class LocationModel {

    double latitude;  // 纬度
    double longitude; // 经度

    String province;  // 省
    String city;       // 城市
    String district;  // 区
    String cityCode;
    String address;

    int errorCode;
    String errorInfo;

    public LocationModel(){}

    public LocationModel(AMapLocation amapLocation) {
        province = amapLocation.getProvince();
        city = amapLocation.getCity();
        district = amapLocation.getDistrict();


        latitude = amapLocation.getLatitude();
        longitude = amapLocation.getLongitude();

        cityCode = amapLocation.getCityCode();
        address = amapLocation.getAddress();

        errorCode = amapLocation.getErrorCode();
        errorInfo = amapLocation.getErrorInfo();
    }


    public double getLatitude() {
        return latitude;
    }

    public void setLatitude(double latitude) {
        this.latitude = latitude;
    }

    public double getLongitude() {
        return longitude;
    }

    public void setLongitude(double longitude) {
        this.longitude = longitude;
    }

    public String getProvince() {
        return province;
    }

    public void setProvince(String province) {
        this.province = province;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getDistrict() {
        return district;
    }

    public void setDistrict(String district) {
        this.district = district;
    }

    public String getCityCode() {
        return cityCode;
    }

    public void setCityCode(String cityCode) {
        this.cityCode = cityCode;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public int getErrorCode() {
        return errorCode;
    }

    public void setErrorCode(int errorCode) {
        this.errorCode = errorCode;
    }

    public String getErrorInfo() {
        return errorInfo;
    }

    public void setErrorInfo(String errorInfo) {
        this.errorInfo = errorInfo;
    }
}

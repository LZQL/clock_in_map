package com.zeking.clock_in_map.model;

import com.amap.api.maps2d.model.LatLng;

public class TipModel {

    String name;
    String address;
    LatLng latLonPoint;
    String district;

    public TipModel(String name, String address, LatLng latLonPoint, String district) {
        this.name = name;
        this.address = address;
        this.latLonPoint = latLonPoint;
        this.district = district;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public LatLng getLatLonPoint() {
        return latLonPoint;
    }

    public void setLatLonPoint(LatLng latLonPoint) {
        this.latLonPoint = latLonPoint;
    }

    public String getDistrict() {
        return district;
    }

    public void setDistrict(String district) {
        this.district = district;
    }
}

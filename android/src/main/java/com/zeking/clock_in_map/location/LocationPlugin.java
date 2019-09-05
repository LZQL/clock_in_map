package com.zeking.clock_in_map.location;

import com.amap.api.location.AMapLocation;
import com.amap.api.location.AMapLocationClient;
import com.amap.api.location.AMapLocationClientOption;
import com.amap.api.location.AMapLocationListener;
import com.google.gson.Gson;
import com.zeking.clock_in_map.model.LocationModel;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

public class LocationPlugin implements MethodChannel.MethodCallHandler, AMapLocationListener {

    public PluginRegistry.Registrar registrar;

    EventChannel locationEventChannel;

    EventChannel.EventSink eventSink;

    private AMapLocationClient mlocationClient;

    public LocationPlugin(PluginRegistry.Registrar registrar) {
        this.registrar = registrar;
        init();
    }

    public void init() {

        locationEventChannel = new EventChannel(registrar.messenger(), "cim/location_event");
        locationEventChannel.setStreamHandler(new EventChannel.StreamHandler() {
            @Override
            public void onListen(Object o, EventChannel.EventSink sink) {
                eventSink = sink;
            }

            @Override
            public void onCancel(Object o) {

            }
        });


        mlocationClient = new AMapLocationClient(registrar.activity().getApplicationContext());

        //设置定位监听
        mlocationClient.setLocationListener(this);

    }

    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {

        if (methodCall.method.equals("location#getLocationOnce")) {
            getLocationOnce(result);
        } else if (methodCall.method.equals("location#getLocations")) {
            getLocations(result);
        } else if (methodCall.method.equals("location#stopLocation")) {
            stopLocation(result);
        } else {
            result.notImplemented();
        }
    }

    // 单次定位
    public void getLocationOnce(MethodChannel.Result result) {
        // 初始化定位参数
        AMapLocationClientOption mLocationOption = new AMapLocationClientOption();
        // 定位一次
        mLocationOption.setOnceLocation(true);
        // 设置定位模式为高精度模式，Battery_Saving为低功耗模式，Device_Sensors是仅设备模式
        mLocationOption.setLocationMode(AMapLocationClientOption.AMapLocationMode.Hight_Accuracy);

        mlocationClient.setLocationOption(mLocationOption);

        mlocationClient.startLocation();
        result.success("开始单次定位");
    }

    // 连续定位
    public void getLocations(MethodChannel.Result result) {
        // 初始化定位参数
        AMapLocationClientOption mLocationOption = new AMapLocationClientOption();
        // 定位一次
        mLocationOption.setOnceLocation(false);
        // 设置定位模式为高精度模式，Battery_Saving为低功耗模式，Device_Sensors是仅设备模式
        mLocationOption.setLocationMode(AMapLocationClientOption.AMapLocationMode.Hight_Accuracy);
        //设置定位间隔,单位毫秒,默认为2000ms
        mLocationOption.setInterval(2000);

        mlocationClient.setLocationOption(mLocationOption);

        mlocationClient.startLocation();
        result.success("开始连续定位");
    }

    // 停止定位
    public void stopLocation(MethodChannel.Result result) {
        mlocationClient.stopLocation();
        result.success("停止定位");
    }

    @Override
    public void onLocationChanged(AMapLocation aMapLocation) {
        LocationModel locationModel = new LocationModel(aMapLocation);
        String jsonString = new Gson().toJson(locationModel);
//        Log.i("sss", jsonString);
        eventSink.success(jsonString);
    }
}

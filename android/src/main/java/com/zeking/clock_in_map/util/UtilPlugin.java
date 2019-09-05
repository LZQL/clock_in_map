package com.zeking.clock_in_map.util;

import com.amap.api.maps2d.AMapUtils;
import com.amap.api.maps2d.model.LatLng;

import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class UtilPlugin implements MethodChannel.MethodCallHandler {

    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {

        if (methodCall.method.equals("util#calculateLineDistance")) {
            calculateLineDistance(methodCall, result);
        } else {
            result.notImplemented();
        }
    }

    // 计算两点之间的距离
    public void calculateLineDistance(MethodCall methodCall, MethodChannel.Result result) {
        Map<String, Double> p1 = methodCall.argument("p1");
        Map<String,Double> p2 = methodCall.argument("p2");

        LatLng l1 = new LatLng(p1.get("latitude"),p1.get("longitude"));
        LatLng l2 = new LatLng(p2.get("latitude"),p2.get("longitude"));

        result.success(AMapUtils.calculateLineDistance(l1,l2));
    }

}

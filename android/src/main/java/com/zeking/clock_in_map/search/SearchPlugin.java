package com.zeking.clock_in_map.search;

import com.amap.api.maps2d.AMapUtils;
import com.amap.api.maps2d.model.LatLng;
import com.amap.api.services.core.LatLonPoint;
import com.amap.api.services.geocoder.GeocodeSearch;
import com.amap.api.services.geocoder.RegeocodeAddress;
import com.amap.api.services.geocoder.RegeocodeQuery;
import com.amap.api.services.help.Inputtips;
import com.amap.api.services.help.InputtipsQuery;
import com.amap.api.services.help.Tip;
import com.google.gson.Gson;
import com.zeking.clock_in_map.common.Contans;
import com.zeking.clock_in_map.model.TipModel;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import io.flutter.Log;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

public class SearchPlugin implements MethodChannel.MethodCallHandler, Inputtips.InputtipsListener {

    public PluginRegistry.Registrar registrar;
    private MethodChannel.Result result;

    public SearchPlugin(PluginRegistry.Registrar registrar) {
        this.registrar = registrar;
    }

    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        this.result = result;
        if (methodCall.method.equals("search#searchAddress")) {
            searchAddress(methodCall, result);
        } else {
            result.notImplemented();
        }
    }

    // 搜索地址
    private void searchAddress(MethodCall methodCall, MethodChannel.Result result) {
        String keyword = methodCall.argument("keyword");

        InputtipsQuery inputquery = new InputtipsQuery(keyword, Contans.currentCity);
        Inputtips inputTips = new Inputtips(registrar.activity().getApplicationContext(), inputquery);
        inputTips.setInputtipsListener(this);
        inputTips.requestInputtipsAsyn();

    }

    @Override
    public void onGetInputtips(List<Tip> list, int i) {

        List<TipModel> tempList = new ArrayList<>();

        for (Tip tip : list) {
            tempList.add(new TipModel(
                    tip.getName(),
                    tip.getAddress(),
                    new LatLng(tip.getPoint().getLatitude(), tip.getPoint().getLongitude()),
                    tip.getDistrict()));
        }


        Gson gson = new Gson();
        String resultJson = gson.toJson(tempList);
//        Log.i("sss", resultJson);
        result.success(resultJson);
    }

//    // 坐标 转 地址
//    private void getAddressFromPoint(MethodCall methodCall, MethodChannel.Result result) {
//        String keyword = methodCall.argument("keyword");
//
//        GeocodeSearch geocodeSearch = new GeocodeSearch(registrar.activity().getApplicationContext());
//        LatLonPoint point = new LatLonPoint(latLng.latitude,
//                latLng.longitude);
//        RegeocodeQuery regeocodeQuery = new RegeocodeQuery(
//                point, 200, GeocodeSearch.AMAP);
//        RegeocodeAddress address = null;
//        try {
//            address = geocodeSearch
//                    .getFromLocation(regeocodeQuery);
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        if (null == address) {
//            return;
//        }
//
//    }
}

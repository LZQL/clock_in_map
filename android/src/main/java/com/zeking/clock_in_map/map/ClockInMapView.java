package com.zeking.clock_in_map.map;

import android.content.Context;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.os.SystemClock;
import android.util.Log;
import android.view.View;
import android.widget.Toast;

import com.amap.api.location.AMapLocation;
import com.amap.api.location.AMapLocationClient;
import com.amap.api.location.AMapLocationClientOption;
import com.amap.api.location.AMapLocationListener;
import com.amap.api.maps2d.AMap;
import com.amap.api.maps2d.CameraUpdateFactory;
import com.amap.api.maps2d.LocationSource;
import com.amap.api.maps2d.MapView;
import com.amap.api.maps2d.model.BitmapDescriptorFactory;
import com.amap.api.maps2d.model.CameraPosition;
import com.amap.api.maps2d.model.LatLng;
import com.amap.api.maps2d.model.Marker;
import com.amap.api.maps2d.model.MarkerOptions;
import com.amap.api.maps2d.model.MyLocationStyle;
import com.amap.api.services.core.LatLonPoint;
import com.amap.api.services.geocoder.GeocodeSearch;
import com.amap.api.services.geocoder.RegeocodeAddress;
import com.amap.api.services.geocoder.RegeocodeQuery;
import com.google.gson.Gson;
import com.zeking.clock_in_map.R;
import com.zeking.clock_in_map.common.Contans;
import com.zeking.clock_in_map.model.LocationModel;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.platform.PlatformView;


public class ClockInMapView implements PlatformView, LocationSource, AMapLocationListener, AMap.OnCameraChangeListener, MethodChannel.MethodCallHandler {


    private MapView mAMap2DView;
    private AMap aMap;
    private OnLocationChangedListener mListener;
    private AMapLocationClient mLocationClient;

    private final Context context;

    private final Handler platformThreadHandler;

    private Runnable postMessageRunnable;
    MethodChannel methodChannel;

    private double tempCentPointLatitude;
    private double tempCentPointLongitude;
    private Marker clockInPointMarker;

    private double clockInLatitude;
    private double clockInLongitude;

    ClockInMapView(final Context context, PluginRegistry.Registrar registrar, Map<String, Object> params) {
        this.context = context;
        platformThreadHandler = new Handler(context.getMainLooper());
        methodChannel = new MethodChannel(registrar.messenger(), "cim/map_center");
        methodChannel.setMethodCallHandler(this);

        createMap(context);
        setUpMap();
        mAMap2DView.onResume();


        if (params.containsKey("clockInLatitude")) {
            if (params.get("clockInLatitude") != null) {
                clockInLatitude = (double) params.get("clockInLatitude");
            }

        }
        if (params.containsKey("clockInLongitude")) {
            if (params.get("clockInLongitude") != null) {
                clockInLongitude = (double) params.get("clockInLongitude");
            }
        }

        if (clockInLatitude != 0 && clockInLongitude != 0) {
            LatLng latLng = new LatLng(clockInLatitude, clockInLongitude);
            drawClockInPoint(latLng);
        }
    }

    private void createMap(Context context) {
        mAMap2DView = new MapView(context);
        // 创建地图
        mAMap2DView.onCreate(new Bundle());
        // 初始化地图控制器对象
        if (aMap == null) {
            aMap = mAMap2DView.getMap();
        }
    }

    private void setUpMap() {
        CameraUpdateFactory.zoomTo(32);
//        aMap.setOnMapClickListener(this);
        // 设置定位监听
        aMap.setLocationSource(this);
        // 设置默认定位按钮是否显示
        aMap.getUiSettings().setMyLocationButtonEnabled(false);
        aMap.getUiSettings().setZoomControlsEnabled(false);
        aMap.getUiSettings().setZoomGesturesEnabled(true);
        MyLocationStyle myLocationStyle = new MyLocationStyle();
        myLocationStyle.strokeWidth(1f);
        myLocationStyle.strokeColor(Color.parseColor("#8052A3FF"));
        myLocationStyle.radiusFillColor(Color.parseColor("#3052A3FF"));
        myLocationStyle.showMyLocation(true);
        myLocationStyle.anchor(0.5f, 0.5f);
        myLocationStyle.myLocationIcon(BitmapDescriptorFactory.fromResource(R.drawable.project_img_myposition));
        myLocationStyle.myLocationType(MyLocationStyle.LOCATION_TYPE_LOCATE);
        aMap.setMyLocationStyle(myLocationStyle);
        // 设置为true表示显示定位层并可触发定位，false表示隐藏定位层并不可触发定位，默认是false
        aMap.setMyLocationEnabled(true);
    }


    @Override
    public View getView() {
        return mAMap2DView;
    }

    @Override
    public void dispose() {
        mAMap2DView.onDestroy();
    }

    @Override
    public void onLocationChanged(AMapLocation aMapLocation) {
        if (mListener != null && aMapLocation != null) {
            if (aMapLocation.getErrorCode() == 0) {
                // 显示系统小蓝点
                mListener.onLocationChanged(aMapLocation);

                if (tempCentPointLatitude != aMapLocation.getLatitude() ||
                        tempCentPointLongitude != aMapLocation.getLongitude()) {
                    Contans.currentCity = aMapLocation.getCity();
                    tempCentPointLatitude = aMapLocation.getLatitude();
                    tempCentPointLongitude = aMapLocation.getLongitude();
                    LatLng latLng = new LatLng(tempCentPointLatitude, tempCentPointLongitude);

//                    Log.i("sss", "getLatitude:" + tempCentPointLatitude + "  getLongitude:" + tempCentPointLongitude);
                    aMap.moveCamera(CameraUpdateFactory.changeLatLng(latLng));
                    aMap.moveCamera(CameraUpdateFactory.zoomTo(16));

                }

                if (mLocationClient != null) {
                    mLocationClient.stopLocation();
                }
                aMap.setOnCameraChangeListener(this);

            } else {
                Toast.makeText(context, "定位失败，请检查GPS是否开启！", Toast.LENGTH_SHORT).show();
                if (mLocationClient != null) {
                    mLocationClient.stopLocation();
                }
            }
        }
    }


    @Override
    public void activate(OnLocationChangedListener onLocationChangedListener) {
        mListener = onLocationChangedListener;
        if (mLocationClient == null) {
            mLocationClient = new AMapLocationClient(context);
            AMapLocationClientOption locationOption = new AMapLocationClientOption();
            mLocationClient.setLocationListener(this);
            //设置为高精度定位模式
            locationOption.setLocationMode(AMapLocationClientOption.AMapLocationMode.Hight_Accuracy);
            //设置定位参数
            mLocationClient.setLocationOption(locationOption);
            mLocationClient.startLocation();

        }
    }

    @Override
    public void deactivate() {
        mListener = null;
        if (mLocationClient != null) {
            mLocationClient.stopLocation();
            mLocationClient.onDestroy();
        }
        mLocationClient = null;
    }


    @Override
    public void onCameraChange(CameraPosition cameraPosition) {

    }

    private String centerPointJsonStr;

    @Override
    public void onCameraChangeFinish(final CameraPosition cameraPosition) {
        final LatLng latLng = cameraPosition.target;

        LocationModel locationModel = new LocationModel();
        centerPointJsonStr = new Gson().toJson(locationModel);
        Map<String, String> map = new HashMap<>(2);
        map.put("centerPointJson", centerPointJsonStr);

        methodChannel.invokeMethod("map#getCenterPoint", map);

        new Thread(new Runnable() {
            @Override
            public void run() {
                GeocodeSearch geocodeSearch = new GeocodeSearch(context);
                LatLonPoint point = new LatLonPoint(latLng.latitude,
                        latLng.longitude);
                RegeocodeQuery regeocodeQuery = new RegeocodeQuery(
                        point, 200, GeocodeSearch.AMAP);
                RegeocodeAddress address = null;
                try {
                    address = geocodeSearch
                            .getFromLocation(regeocodeQuery);
                } catch (Exception e) {
                    e.printStackTrace();
                }
                if (null == address) {
                    return;
                }


                LocationModel locationModel = new LocationModel();

                locationModel.setProvince(address.getProvince());
                locationModel.setCity(address.getCity());
                locationModel.setDistrict(address.getDistrict());

                locationModel.setLatitude(cameraPosition.target.latitude);
                locationModel.setLongitude(cameraPosition.target.longitude);

                locationModel.setCityCode(address.getCityCode());
                locationModel.setAddress(address.getFormatAddress());

                centerPointJsonStr = new Gson().toJson(locationModel);

                postMessageRunnable = new Runnable() {
                    @Override
                    public void run() {
                        Map<String, String> map = new HashMap<>(2);
                        map.put("centerPointJson", centerPointJsonStr);

                        methodChannel.invokeMethod("map#getCenterPoint", map);
                    }
                };
                if (platformThreadHandler.getLooper() == Looper.myLooper()) {
                    postMessageRunnable.run();
                } else {
                    platformThreadHandler.post(postMessageRunnable);
                }


            }
        }).start();
    }

    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        // 将地图移动到指定的点
        if (methodCall.method.equals("map#moveCamera")) {
            Map<String, Double> point = methodCall.argument("point");

            LatLng latLng = new LatLng(point.get("latitude"), point.get("longitude"));

            aMap.moveCamera(CameraUpdateFactory.changeLatLng(latLng));

        } else if (methodCall.method.equals("map#getMyLocation")) { // 我的位置

            if (mLocationClient != null) {
                // 自定义 我的位置 按钮 优化，先定位到之前的位置，再去更新最新位置，如果有变化的话在移动过去
                LatLng latLng = new LatLng(tempCentPointLatitude, tempCentPointLongitude);
                aMap.moveCamera(CameraUpdateFactory.changeLatLng(latLng));
                aMap.moveCamera(CameraUpdateFactory.zoomTo(16));

                mLocationClient.startLocation();
            }
        } else if (methodCall.method.equals("map#drawClockInPoint")) {  // 绘制 选择的 打卡地点


            Map<String, Double> point = methodCall.argument("point");

            LatLng latLng = new LatLng(point.get("latitude"), point.get("longitude"));

            drawClockInPoint(latLng);
        }
    }


    public void drawClockInPoint(LatLng latLng) {
        if (clockInPointMarker != null) {
            clockInPointMarker.remove();
        }

        MarkerOptions markerOption = new MarkerOptions();
        markerOption.position(latLng);
        markerOption.draggable(false);//设置Marker可拖动
        markerOption.icon(BitmapDescriptorFactory.fromResource(R.drawable.project_img_tag_position));
        clockInPointMarker = aMap.addMarker(markerOption);
    }
}

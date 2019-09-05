package com.zeking.clock_in_map;

import com.zeking.clock_in_map.location.LocationPlugin;
import com.zeking.clock_in_map.map.ClockInMapFactory;
import com.zeking.clock_in_map.search.SearchPlugin;
import com.zeking.clock_in_map.util.UtilPlugin;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * ClockInMapPlugin
 */
public class ClockInMapPlugin {
    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {

//        registrar.addRequestPermissionsResultListener();

        // 添加权限回调监听
//        final ClockInMapDelegate delegate = new ClockInMapDelegate(registrar.activity());
//        registrar.addRequestPermissionsResultListener(delegate);

        // 地图 view
        registrar.platformViewRegistry().registerViewFactory("cim/mapview",
                new ClockInMapFactory(registrar));

        // 定位
        final MethodChannel location_channel = new MethodChannel(registrar.messenger(), "cim/location");
        location_channel.setMethodCallHandler(new LocationPlugin(registrar));

        // util ： 计算两者之间的距离
        final MethodChannel util_channel = new MethodChannel(registrar.messenger(), "cim/util");
        util_channel.setMethodCallHandler(new UtilPlugin());

        // 搜索
        final MethodChannel search_channel = new MethodChannel(registrar.messenger(), "cim/search");
        search_channel.setMethodCallHandler(new SearchPlugin(registrar));

    }

}

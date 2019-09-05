//package com.zeking.clock_in_map;
//
//import android.Manifest;
//import android.app.Activity;
//import android.content.pm.PackageManager;
//
//import androidx.annotation.NonNull;
//import androidx.core.app.ActivityCompat;
//import io.flutter.plugin.common.PluginRegistry;
//
//
//public class ClockInMapDelegate implements PluginRegistry.RequestPermissionsResultListener {
//
//    private static final int REQUEST_PERMISSION = 6666;
//
//    private final String[] permission = {
//        Manifest.permission.ACCESS_COARSE_LOCATION,
//        Manifest.permission.ACCESS_FINE_LOCATION,
//        Manifest.permission.READ_PHONE_STATE
//    };
//
//    interface PermissionManager {
//        /**
//         * 是否授予权限
//         * @return 是否授予权限
//         */
//        boolean isPermissionGranted();
//
//        /**
//         * 请求权限
//         */
//        void askForPermission();
//    }
//
//    interface RequestPermission {
//        /**
//         * 权限请求成功
//         */
//        void onRequestPermissionSuccess();
//        /**
//         * 权限请求失败
//         */
//        void onRequestPermissionFailure();
//    }
//
//    private RequestPermission mRequestPermission;
//
//    private final PermissionManager permissionManager;
//
//    ClockInMapDelegate(final Activity activity){
//
//        permissionManager = new PermissionManager() {
//            @Override
//            public boolean isPermissionGranted() {
//                for (String s : permission) {
//                    if (ActivityCompat.checkSelfPermission(activity, s) != PackageManager.PERMISSION_GRANTED) {
//                        return false;
//                    }
//                }
//                return true;
//            }
//
//            @Override
//            public void askForPermission() {
//                ActivityCompat.requestPermissions(activity, permission, REQUEST_PERMISSION);
//            }
//        };
//    }
//
//    void requestPermissions(@NonNull RequestPermission mRequestPermission){
//        this.mRequestPermission = mRequestPermission;
//        if (!permissionManager.isPermissionGranted()) {
//            permissionManager.askForPermission();
//        }else {
//            mRequestPermission.onRequestPermissionSuccess();
//        }
//    }
//
//    @Override
//    public boolean onRequestPermissionsResult(int requestCode, String[] strings, int[] ints) {
//        if (requestCode == REQUEST_PERMISSION){
//            boolean permissionGranted = true;
//            for (int i : ints) {
//                if (i != PackageManager.PERMISSION_GRANTED) {
//                    permissionGranted = false;
//                }
//            }
//            if (permissionGranted){
//                mRequestPermission.onRequestPermissionSuccess();
//            }else {
//                mRequestPermission.onRequestPermissionFailure();
//            }
//            return true;
//        }else {
//            return false;
//        }
//    }
//}
//

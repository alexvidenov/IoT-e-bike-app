package com.example.ble_app

import io.flutter.app.FlutterApplication;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback;
import io.flutter.plugins.androidalarmmanager.AlarmService;
import io.flutter.plugins.androidalarmmanager.AndroidAlarmManagerPlugin;

class Application : FlutterApplication(), PluginRegistry.PluginRegistrantCallback {
    override fun registerWith(reg: PluginRegistry?) {
        AndroidAlarmManagerPlugin.registerWith(
            reg?.registrarFor("io.flutter.plugins.androidalarmmanager.AndroidAlarmManagerPlugin"));
    }
}
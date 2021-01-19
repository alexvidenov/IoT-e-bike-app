package com.example.ble_app

import io.flutter.app.FlutterApplication;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback;
import io.flutter.plugins.androidalarmmanager.AlarmService;
import io.flutter.plugins.androidalarmmanager.AndroidAlarmManagerPlugin;
import io.flutter.plugins.firebasemessaging.FlutterFirebaseMessagingService;
import io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin;
import com.tekartik.sqflite.SqflitePlugin;

class Application : FlutterApplication(), PluginRegistry.PluginRegistrantCallback {
    override fun onCreate() {
        super.onCreate()
        FlutterFirebaseMessagingService.setPluginRegistrant(this)
    }

    override fun registerWith(reg: PluginRegistry?) {
        AndroidAlarmManagerPlugin.registerWith(
                reg?.registrarFor("io.flutter.plugins.androidalarmmanager.AndroidAlarmManagerPlugin"))
        FirebaseMessagingPlugin.registerWith(reg?.registrarFor("io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin"))
        SqflitePlugin.registerWith(reg?.registrarFor("com.tekartik.sqflite.SqflitePlugin"))
        //io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin.registerWith(reg?.registrarFor("io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin"));
    }
}
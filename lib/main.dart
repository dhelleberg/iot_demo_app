import 'package:flutter/material.dart';
import 'package:iot_app/appconfig.dart';
import 'package:iot_app/settings.dart';
import 'package:iot_app/sensors.dart';

import 'dart:async';
import 'dart:convert';
import 'package:iot_app/ledcontrol.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  AppConfig appConfig = new AppConfig();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter IoT Control',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TabbedHomePage(appConfig),
    );
  }
}

class TabbedHomePage extends StatelessWidget {
  const TabbedHomePage(this.appConfig, {Key? key}) : super(key: key);
  final AppConfig appConfig;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('IOT-Control-App'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'LEDControl'),
              Tab(text: 'Sensor'),
              Tab(text: 'Settings'),
            ],
          ),
        ),
        body: SafeArea(
          bottom: false,
          child: TabBarView(
            children: [
              LEDControlPage(appConfig),
              SensorPage(appConfig),
              SettingsPage(appConfig),
            ],
          ),
        ),
      ),
    );
  }
}

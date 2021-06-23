import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:iot_app/appconfig.dart';
import 'package:iot_app/LED.dart';

class LEDControlPage extends StatefulWidget {
  LEDControlPage(this.appConfig, {Key? key}) : super(key: key);

  final AppConfig appConfig;

  @override
  _LEDControlPageState createState() => _LEDControlPageState(appConfig);
}

class _LEDControlPageState extends State<LEDControlPage> {
  LEDs currentLEDState = LEDs.unknown();
  final AppConfig appConfig;

  _LEDControlPageState(this.appConfig);

  void _switchOff() {
    setState(() {
      currentLEDState.allOFF();
      setLEDStatus(appConfig, currentLEDState);
    });
  }

  void _switchOn() {
    setState(() {
      currentLEDState.allON();
      setLEDStatus(appConfig, currentLEDState);
    });
  }

  @override
  void initState() {
    super.initState();
    fetchLEDsState(appConfig);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: () => _switchOn(),
            child: Text("On"),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            child: Text("Off"),
            onPressed: () => _switchOff(),
          ),
        ],
      ),
    );
  }

  Future<LEDs> fetchLEDsState(AppConfig appConfig) async {
    print("calling: " + appConfig.iot_controller_url + '/leds');
    final response =
        await http.get(Uri.parse(appConfig.iot_controller_url + '/leds'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      currentLEDState = LEDs.fromJSON(jsonDecode(response.body));
      return currentLEDState;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load LED state');
    }
  }

  Future<http.Response> setLEDStatus(AppConfig appConfig, LEDs led) {
    return http.put(
      Uri.parse(appConfig.iot_controller_url + '/leds'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: led.toJson(),
    );
  }
}

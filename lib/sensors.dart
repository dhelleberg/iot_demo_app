import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:iot_app/appconfig.dart';

class Sensors {
  final double temperature;
  final double humidity;

  Sensors({
    required this.temperature,
    required this.humidity,
  });

  factory Sensors.fromJson(Map<String, dynamic> json) {
    return Sensors(
        temperature: json['temperature'], humidity: json['humidity']);
  }
}

class SensorPage extends StatefulWidget {
  SensorPage(this.appConfig, {Key? key}) : super(key: key);

  final AppConfig appConfig;

  @override
  _SensorPageState createState() => _SensorPageState(appConfig);
}

class _SensorPageState extends State<SensorPage> {
  final AppConfig appConfig;
  late Future<Sensors> futureSensors;
  _SensorPageState(this.appConfig);

  @override
  void initState() {
    super.initState();
    futureSensors = fetchSensorState(appConfig);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<Sensors>(
        future: futureSensors,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data!.temperature.toString());
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          // By default, show a loading spinner.
          return CircularProgressIndicator();
        },
      ),
    );
  }

  Future<Sensors> fetchSensorState(AppConfig appConfig) async {
    final response =
        await http.get(Uri.parse(appConfig.iot_controller_url + '/sensors'));

    if (response.statusCode == 200) {
      return Sensors.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load sensor-data');
    }
  }
}

import 'package:flutter/material.dart';
import 'package:iot_app/AppConfig.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage(this.appConfig);
  final AppConfig appConfig;

  @override
  _SettingsState createState() => _SettingsState(appConfig);
}

class _SettingsState extends State<SettingsPage> {
  // of the TextField.
  var textController;

  final AppConfig appConfig;

  _SettingsState(this.appConfig) {
    textController = TextEditingController(text: appConfig.iot_controller_url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: textController,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // When the user presses the button, show an alert dialog containing
        // the text that the user has entered into the text field.
        onPressed: () {
          appConfig.iot_controller_url = textController.text;
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                // Retrieve the text the that user has entered by using the
                // TextEditingController.
                content: Text("Saved: " + textController.text),
              );
            },
          );
        },
        tooltip: 'Show me the value!',
        child: Icon(Icons.text_fields),
      ),
    );
  }
}

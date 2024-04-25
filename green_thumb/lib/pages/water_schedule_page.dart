import 'package:flutter/material.dart';
import '../models/plant.dart';
import '../services/database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class WateringSchedulePage extends StatefulWidget {
  final Plant plant;

  const WateringSchedulePage({required this.plant});

  @override
  WateringSchedulePageState createState() => WateringSchedulePageState();
}

class WateringSchedulePageState extends State<WateringSchedulePage> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final Database database = Database();
  String? selectedFrequency;

  @override
  void initState() {
    super.initState();
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('app_icon');

    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _scheduleNotification(String plantId, String frequency) async {
    database.setWateringSchedule(plantId, frequency);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Watering Schedule'),
      ),
      body: Column(
        children: [
          Text('Selected Plant: ${widget.plant.commonName}'),
          DropdownButton<String>(
            hint: const Text('Select Frequency'),
            value: selectedFrequency,
            onChanged: (newValue) {
              setState(() {
                selectedFrequency = newValue;
              });
            },
            items: ['Daily', 'Weekly', 'Bi-Weekly'].map((String frequency) {
              return DropdownMenuItem<String>(
                value: frequency,
                child: Text(frequency),
              );
            }).toList(),
          ),
          ElevatedButton(
            onPressed: () {
              if (selectedFrequency != null) {
                _scheduleNotification(
                    widget.plant.documentId, selectedFrequency!);
              }
            },
            child: const Text('Set Schedule'),
          ),
        ],
      ),
    );
  }
}

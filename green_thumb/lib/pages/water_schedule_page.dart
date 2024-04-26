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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  color: const Color.fromARGB(255, 44, 94, 46),
                  width: double.infinity,
                  child: Text(
                    'Selected Plant: ${widget.plant.commonName}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipOval(
                    child: Image.network(
                      widget.plant.imageUrl,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                DropdownButton<String>(
                  isExpanded: true,
                  hint: const Text('Select Frequency'),
                  value: selectedFrequency,
                  onChanged: (newValue) {
                    setState(() {
                      selectedFrequency = newValue;
                    });
                  },
                  items:
                      ['Daily', 'Weekly', 'Bi-Weekly'].map((String frequency) {
                    return DropdownMenuItem<String>(
                      value: frequency,
                      child: Text(frequency),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 50),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (selectedFrequency != null) {
                        _scheduleNotification(
                            widget.plant.documentId, selectedFrequency!);
                      }
                    },
                    child: const Text('Set Schedule'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../models/plant.dart';
import '../models/water_schedule.dart';
import '../services/database.dart';
import 'package:intl/intl.dart';

class PlantWateringPage extends StatefulWidget {
  @override
  PlantWateringPageState createState() => PlantWateringPageState();
}

class PlantWateringPageState extends State<PlantWateringPage> {
  final Database database = Database();
  List<Plant> plants = [];
  Map<String, WateringSchedule> schedules = {};

  @override
  void initState() {
    super.initState();
    _loadPlantsAndSchedules();
  }

  void _loadPlantsAndSchedules() async {
    plants = await database.getAllUserPlants();
    var loadedSchedules = await database.getAllUserWateringSchedules();

    loadedSchedules
        .sort((a, b) => a.nextWateringDate.compareTo(b.nextWateringDate));

    setState(() {
      for (var schedule in loadedSchedules) {
        schedules[schedule.plantId] = schedule;
      }
    });
  }

  void _waterPlant(Plant plant) {
    WateringSchedule? schedule = schedules[plant.documentId];
    database.setWateringSchedule(plant.documentId, schedule?.frequency ?? "");
    _loadPlantsAndSchedules();
  }

  String _formatTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd – HH:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plant Watering Schedule'),
      ),
      body: ListView.builder(
        itemCount: plants.length,
        itemBuilder: (context, index) {
          Plant plant = plants[index];
          WateringSchedule? schedule = schedules[plant.documentId];
          bool needsWatering = schedule != null &&
              schedule.nextWateringDate.isBefore(DateTime.now());
          return Card(
            child: ListTile(
              leading: needsWatering
                  ? const Icon(Icons.warning, color: Colors.red)
                  : null,
              title: Text(plant.commonName),
              subtitle: Text(needsWatering
                  ? 'This plant needs watering!'
                  : 'Next Water Date: ${_formatTime(schedule?.nextWateringDate ?? DateTime.now())}'),
              trailing: ElevatedButton(
                onPressed: () => _waterPlant(plant),
                child: const Text('Water'),
              ),
            ),
          );
        },
      ),
    );
  }
}

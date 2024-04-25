import 'package:flutter/material.dart';
import 'package:green_thumb/pages/water_schedule_page.dart';
import '../models/plant.dart';
import '../services/database.dart';

class PlantProfile extends StatefulWidget {
  @override
  _PlantProfileState createState() => _PlantProfileState();
}

class _PlantProfileState extends State<PlantProfile> {
  final Database database = Database();
  List<Plant> userPlants = [];

  @override
  void initState() {
    super.initState();
    _loadUserPlants();
  }

  _loadUserPlants() async {
    var plants = await database.getAllUserPlants();
    setState(() {
      userPlants = plants;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plant Profile'),
      ),
      body: ListView.builder(
        itemCount: userPlants.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      WateringSchedulePage(plant: userPlants[index]),
                ),
              );
            },
            child: PlantCard(
              plant: userPlants[index],
              onDeleted: () => _loadUserPlants(),
            ),
          );
        },
      ),
    );
  }
}

class PlantCard extends StatelessWidget {
  final Plant plant;
  final VoidCallback onDeleted;

  const PlantCard({Key? key, required this.plant, required this.onDeleted})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image.network(plant.imageUrl,
                fit: BoxFit.cover, height: 200, width: double.infinity),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plant.commonName,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        plant.scientificName,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete,
                      color: Color.fromARGB(255, 6, 90, 48)),
                  onPressed: () async {
                    await Database().deleteFromCollection(plant.documentId);
                    onDeleted();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

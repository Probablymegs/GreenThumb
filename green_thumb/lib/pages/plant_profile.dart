import 'package:flutter/material.dart';
import '../models/plant.dart';

class PlantProfile extends StatelessWidget {
  final List<Plant> plants = [
    Plant(
        commonName: 'Rose',
        scientificName: 'Rosa',
        imageUrl: 'https://example.com/rose.jpg',
        documentId: '1'),
    Plant(
        commonName: 'Sunflower',
        scientificName: 'Helianthus',
        imageUrl: 'https://example.com/sunflower.jpg',
        documentId: '2')
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Plant Profile'),
      ),
      body: ListView.builder(
        itemCount: plants.length,
        itemBuilder: (context, index) {
          return PlantCard(plant: plants[index]);
        },
      ),
    );
  }
}

class PlantCard extends StatelessWidget {
  final Plant plant;

  const PlantCard({Key? key, required this.plant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image.network(plant.imageUrl, fit: BoxFit.cover),
            Text(plant.commonName,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(plant.scientificName, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

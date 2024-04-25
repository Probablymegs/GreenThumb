import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:green_thumb/models/trefle_plant.dart';
import '../services/database.dart';

class PlantDetailPage extends StatelessWidget {
  final TreflePlant plant;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  PlantDetailPage({super.key, required this.plant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(plant.commonName ?? plant.scientificName),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              margin: const EdgeInsets.all(8),
              child: Column(
                children: [
                  plant.imageUrl.isNotEmpty
                      ? Image.network(plant.imageUrl, fit: BoxFit.cover)
                      : const Icon(Icons.image, size: 150, color: Colors.grey),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          plant.commonName ?? 'No common name available',
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Scientific Name: ${plant.scientificName}',
                          style: const TextStyle(
                              fontSize: 18, fontStyle: FontStyle.italic),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            Database().addToCollection(plant);
                          },
                          child: const Text('Add to My Collection'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

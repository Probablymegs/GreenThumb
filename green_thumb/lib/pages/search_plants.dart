// Fetch plants from Trefle
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:green_thumb/models/trefle_plant.dart';
import 'package:green_thumb/pages/plant_details.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

Future<List<TreflePlant>> fetchPlants(String query) async {
  final response = await http.get(Uri.parse(
      'https://trefle.io/api/v1/plants/search?token=${dotenv.env['TREFLE_TOKEN']}&q=$query'));

  if (response.statusCode == 200) {
    List<dynamic> plantsJson = jsonDecode(response.body)['data'];
    return plantsJson
        .where((json) =>
            (json['image_url'] != null && json['scientific_name'] != null))
        .map((json) => TreflePlant.fromJson(json))
        .toList();
  } else {
    throw Exception('Failed to load plants');
  }
}

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late List<TreflePlant> _plants = [];
  bool _isLoading = false;

  void _search(String query) async {
    setState(() {
      _isLoading = true;
    });
    _plants = await fetchPlants(query);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Plant Search")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onSubmitted: _search,
              decoration: const InputDecoration(
                labelText: 'Search for a plant',
                suffixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _plants.length,
                    itemBuilder: (context, index) {
                      var plant = _plants[index];
                      return Card(
                        margin: const EdgeInsets.all(8),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PlantDetailPage(plant: plant),
                              ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: plant.imageUrl.isNotEmpty
                                    ? Image.network(plant.imageUrl,
                                        height: 200, fit: BoxFit.cover)
                                    : const Icon(Icons.image, size: 200),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                child: Text(
                                  plant.commonName ?? plant.scientificName,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                  textAlign:
                                      TextAlign.center, // Center the text
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

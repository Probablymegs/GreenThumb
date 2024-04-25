class Plant {
  final String commonName;
  final String scientificName;
  final String imageUrl;
  final String documentId;

  Plant(
      {required this.commonName,
      required this.scientificName,
      required this.imageUrl,
      required this.documentId});

  factory Plant.fromJson(Map<String, dynamic> json, String id) {
    return Plant(
      commonName: json['commonName'],
      scientificName: json['scientificName'],
      imageUrl: json['imageUrl'],
      documentId: id,
    );
  }
}

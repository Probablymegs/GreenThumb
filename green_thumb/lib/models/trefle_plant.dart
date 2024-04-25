class TreflePlant {
  final String? commonName;
  final String imageUrl;
  final String scientificName;

  TreflePlant(
      {required this.commonName,
      required this.imageUrl,
      required this.scientificName});

  factory TreflePlant.fromJson(Map<String, dynamic> json) {
    return TreflePlant(
        commonName: json['common_name'],
        imageUrl: json['image_url'] ?? '',
        scientificName: json['scientific_name'] ?? 'No scientific name');
  }
}

class LocationFull {
  final String name;
  final String type;
  final String dimension;
  final List<String> residents;

  LocationFull({
    required this.name,
    required this.type,
    required this.dimension,
    required this.residents,
  });

  factory LocationFull.fromJson(Map<String, dynamic> json) {
    var residentsJson = json['residents'];
    List<String> residentsList = residentsJson.cast<String>();

    return LocationFull(
      name: json['name'],
      type: json['type'],
      dimension: json['dimension'],
      residents: residentsList
    );
  }
}
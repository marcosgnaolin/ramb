class Episode {
  final String name;
  final String episode;

  Episode({
    required this.name,
    required this.episode
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      name: json['name'],
      episode: json['episode']
    );
  }
}
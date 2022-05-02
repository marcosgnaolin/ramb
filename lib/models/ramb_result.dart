import 'package:ramb/models/ramb_location.dart';
import 'package:ramb/models/ramb_origin.dart';

class Result {
  final int id;
  final String name;
  final String image;
  final String species;
  final String status;
  final Origin origin;
  final Location location;
  final List<String> episodes;

  Result({
    required this.id,
    required this.name,
    required this.image,
    required this.species,
    required this.status,
    required this.origin,
    required this.location,
    required this.episodes
  });

  factory Result.fromJson(Map<String, dynamic> parsedJson) {
    var episodesJson = parsedJson['episode'];
    List<String> episodesList = episodesJson.cast<String>();

    return Result(
      id: parsedJson['id'],
      name: parsedJson['name'],
      image: parsedJson['image'],
      species: parsedJson['species'],
      status: parsedJson['status'],
      origin: Origin.fromJson(parsedJson['origin']),
      location: Location.fromJson(parsedJson['location']),
      episodes: episodesList
    );
  }
}
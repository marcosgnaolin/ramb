import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:ramb/models/ramb_info.dart';
import 'package:ramb/models/ramb_result.dart';
import '../network/ramb_webservice.dart';

class RambCharacter {
  final Info info;
  final List<Result> results;

  RambCharacter({
    required this.info,
    required this.results
  });

  factory RambCharacter.fromJson(Map<String, dynamic> json) {
    var jsonResultList = json['results'] as List;
    List<Result> resultList = jsonResultList.map((i) => Result.fromJson(i)).toList();

    return RambCharacter(
        info: Info.fromJson(json['info']),
        results: resultList
    );
  }

  static Resource<RambCharacter> get single {
    return Resource(
        url: 'https://rickandmortyapi.com/api/character',
        parse: (response) {
          final result = json.decode(response.body);
          return RambCharacter.fromJson(result);
        }
    );
  }
}
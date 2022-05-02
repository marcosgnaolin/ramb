import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ramb/models/ramb_character.dart';
import 'package:ramb/models/ramb_episode.dart';
import 'package:ramb/models/ramb_info.dart';
import 'package:ramb/models/ramb_result.dart';
import 'package:ramb/network/ramb_webservice.dart';

import '../models/ramb_location_full.dart';

class RickAndMortyListView extends StatefulWidget {
  const RickAndMortyListView({Key? key}) : super(key: key);

  @override
  State<RickAndMortyListView> createState() => _RickAndMortyListViewState();
}

class _RickAndMortyListViewState extends State<RickAndMortyListView> {
  RambCharacter _character = RambCharacter(info: Info(count: 0), results: []);

  @override
  void initState() {
    super.initState();
    _populateCharacters();
  }

  void _populateCharacters() {
    RambWebService().loadGet(RambCharacter.single).then((character) => {
          setState(() => {_character = character})
        });
  }

  Card _buildItemsForListView(BuildContext context, int index) {
    return Card(
      child: ListTile(
        contentPadding: EdgeInsets.all(12),
        leading: Image.network(_character.results[index].image),
        title: Text(_character.results[index].name,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(_character.results[index].species,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.normal)),
            const Divider(),
            Text("Status: " + _character.results[index].status,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.normal)),
          ],
        ),
        trailing: const Icon(Icons.keyboard_arrow_right),
        onTap: () => onTapped(_character.results[index]),
      ),
    );
  }

  void onTapped(Result singleResult) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ResultDetail(singleResult: singleResult)));
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: _character.results.length,
        itemBuilder: _buildItemsForListView);
  }
}

class ResultDetail extends StatelessWidget {
  final Result singleResult;

  ResultDetail({Key? key, required this.singleResult}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(singleResult.name),
        backgroundColor: Colors.indigo,
      ),
      body: SafeArea(
        child: ListView(
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.all(2),
          children: [
            SizedBox(
              width: double.infinity,
              height: 240,
              child: Image.network(
                singleResult.image,
                fit: BoxFit.cover,
              ),
            ),
            const Padding(
              padding:
                  EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
              child: Text(
                "Character Information",
                style:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(indent: 16.0, endIndent: 16.0, color: Colors.grey),
            Padding(
              padding:
                  const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Text("Name: " + singleResult.name),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Text("Species: " + singleResult.species),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Text("Status: " + singleResult.status),
            ),
            const Padding(
              padding:
                  EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
              child: Text(
                "Character Origin",
                style:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(indent: 16.0, endIndent: 16.0, color: Colors.grey),
            Padding(
              padding:
                  const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Text(singleResult.origin.name),
            ),
            const Padding(
              padding:
                  const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
              child: Text(
                "Character Location",
                style:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(indent: 16.0, endIndent: 16.0, color: Colors.grey),
            Padding(
              padding:
                  const EdgeInsets.only(left: 16.0, right: 16.0),
              child: (() {
                Future<LocationFull> flf = getLocationInfo(singleResult);

                return FutureBuilder<LocationFull>(
                  future: flf,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Location name: " + snapshot.data!.name),
                          Text("Type: " + snapshot.data!.type),
                          Text("Dimension: " + snapshot.data!.dimension),
                          Text("Residents: " + snapshot.data!.residents.length.toString()),
                        ],
                      );
                    } else {
                      return Text("");
                    }
                });
              })(),
            ),
            const Padding(
              padding:
                  EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
              child: Text(
                "Episodes",
                style:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(indent: 16.0, endIndent: 16.0, color: Colors.grey),
            Padding(
                padding:
                    const EdgeInsets.only(left: 16.0, right: 16.0),
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: singleResult.episodes.length,
                    itemBuilder: (BuildContext episodesContext, int index) {
                      Future<Episode> fr = getEpisodeName(singleResult.episodes[index]);

                      return FutureBuilder<Episode>(
                          future: fr,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Text(snapshot.data!.name);
                            } else {
                              return Text("");
                            }
                          });
                    })),
          ],
        ),
      ),
    );
  }

  Future<Episode> getEpisodeName(singleEpisode) async {
    final response = await http.get(Uri.parse(singleEpisode));
    if (response.statusCode == 200) {
      return Episode.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get episode');
    }
  }

  Future<LocationFull> getLocationInfo(Result singleResult) async {
    final response = await http.get(Uri.parse(singleResult.location.url));

    if (response.statusCode == 200) {
      return LocationFull.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get location info');
    }

  }
}

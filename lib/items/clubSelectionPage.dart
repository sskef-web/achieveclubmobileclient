import 'package:achieveclubmobileclient/data/club.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:achieveclubmobileclient/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ClubSelectionPage extends StatefulWidget {
  final Function(int) updateClubId;
  int clubId;


  ClubSelectionPage({
    super.key,
    required this.updateClubId,
    required this.clubId
  });

  @override
  _ClubSelectionPageState createState() => _ClubSelectionPageState();
}

class _ClubSelectionPageState extends State<ClubSelectionPage> {
  List<Club> _clubs = [];

  @override
  void initState() {
    super.initState();
    _fetchClubTitles();
  }

  Future<void> _fetchClubTitles() async {
    final response = await http.get(Uri.parse('${baseURL}api/clubs/titles'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<Club> clubs = [];
      for (final clubData in data) {
        clubs.add(Club(
          id: clubData['id'],
          title: clubData['title'],
          description: clubData['description'],
          address: clubData['address'],
          avgXp: 0,
          logoURL: clubData['logoURL']
        ));
      }
      setState(() {
        _clubs = clubs;
        widget.clubId = clubs.isNotEmpty ? clubs[0].id : 0;
      });
    } else {
      throw Exception(AppLocalizations.of(context)!.fetchClubsError);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.selectClub),
      ),
      body: Column(
        children: [
          SegmentedButton(
            segments: _clubs.map((club) {
              return ButtonSegment(
                value: club.id,
                label: Text(club.title),
                icon: const Icon(Icons.home),
              );
            }).toList(),
            selected: {widget.clubId},
            onSelectionChanged: (value) {
              setState(() {
                widget.clubId = value.first;
              });
              widget.updateClubId(widget.clubId);
            },
          ),
          const SizedBox(height: 16),
          Text('${AppLocalizations.of(context)!.clubId}: ${widget.clubId}'),
        ],
      ),
    );
  }
}
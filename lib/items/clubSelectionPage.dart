import 'package:achieveclubmobileclient/data/club.dart';
import 'package:achieveclubmobileclient/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ClubSelectionPage extends StatefulWidget {
  final Function(int) updateClubId;

  const ClubSelectionPage({Key? key, required this.updateClubId}) : super(key: key);

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
    final response = await http.get(Uri.parse('${baseURL}clubs/titles'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<Club> clubs = [];
      for (final clubData in data) {
        clubs.add(Club(
          id: clubData['id'],
          title: clubData['title'],
        ));
      }
      setState(() {
        _clubs = clubs;
        clubId = clubs.isNotEmpty ? clubs[0].id : 0;
      });
    } else {
      throw Exception('Failed to fetch club titles');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Club'),
      ),
      body: Column(
        children: [
          SegmentedButton(
            segments: _clubs.map((club) {
              return ButtonSegment(
                value: club.id,
                label: Text(club.title),
                icon: Icon(Icons.home),
              );
            }).toList(),
            selected: {clubId},
            onSelectionChanged: (value) {
              setState(() {
                clubId = value.first;
              });
              widget.updateClubId(clubId);
            },
          ),
          SizedBox(height: 16),
          Text('Selected Club ID: $clubId'),
        ],
      ),
    );
  }
}
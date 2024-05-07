import 'package:flutter/material.dart';

class ClubPage extends StatelessWidget {
  final int clubId;

  const ClubPage({Key? key, required this.clubId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final clubData = _fetchClubData(clubId);

    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text('Клуб\n"${clubData?['clubName']}"',textAlign: TextAlign.center,)
        ),
      ),
      body: clubData != null
          ? SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row (
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('# ${clubData['topPosition']}', textScaler: TextScaler.linear(5),),
                  const SizedBox(width: 15),
                  Container(
                    width: 200.0,
                    height: 200.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage('https://sskef.site/${clubData['clubLogo']}'),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('История клуба:', textScaler: TextScaler.linear(1.8),),
                    Text('${clubData['description']}'),
                    const SizedBox(height: 16,),
                    Text('${clubData['adress']}')
                  ],
              ),
              const SizedBox(height: 16),
              SizedBox(height: 16),
              ExpansionTile(
                title: Text(
                  'Топ 3 пользователей:',
                  style: TextStyle(fontSize: 24),
                ),
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: clubData['topUsers'].length,
                    itemBuilder: (context, index) {
                      final user = clubData['topUsers'][index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(user['avatar']),
                        ),
                        title: Row (
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(user['name']),
                            Text('${user['xp']} XP')
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      )
          : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Map<String, dynamic>? _fetchClubData(int clubId) {
    final clubData = {
      'clubName': 'Dvorec',
      'clubLogo': 'StaticFiles/avatars/193ea883-5369-449f-8701-c828ec00e3dd.jpeg',
      'xp': 150195,
      'topPosition': 1,
      'description': 'Господа, современная методология разработки не даёт нам иного выбора, кроме определения стандартных подходов. Высокий уровень вовлечения представителей целевой аудитории является четким доказательством простого факта: консультация с широким активом влечет за собой процесс внедрения и модернизации существующих финансовых и административных условий. ',
      'adress': 'Минск, ул. Долгобродская 24',
      'topUsers': [
        {
          'name': 'Name Surname1',
          'avatar': 'https://sskef.site/StaticFiles/avatars/193ea883-5369-449f-8701-c828ec00e3dd.jpeg',
          'xp': 5000,
        },
        {
          'name': 'Name Surname2',
          'avatar': 'https://sskef.site/StaticFiles/avatars/193ea883-5369-449f-8701-c828ec00e3dd.jpeg',
          'xp': 4500,
        },
        {
          'name': 'Name Surname3',
          'avatar': 'https://sskef.site/StaticFiles/avatars/193ea883-5369-449f-8701-c828ec00e3dd.jpeg',
          'xp': 4000,
        },
      ],
    };

    return clubData;
  }
}
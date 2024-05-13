import 'package:flutter/material.dart';



class ClubPage extends StatelessWidget {
  final int clubId;
  final String title;
  final String description;
  final String address;
  final String logoURL;
  final String position;

  const ClubPage({
    super.key,
    required this.clubId,
    required this.title,
    required this.logoURL,
    required this.address,
    required this.description,
    required this.position
  });

  LinearGradient getPositionColor(String position) {
    if (position == "1") {
      // Золотой цвет
      return const LinearGradient(
        colors: [Color(0xffedcf33), Color(0xffdaaa30)],
        stops: [0.25, 0.75],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    }
    else if (position == "2") {
      // Серебряный цвет
      return const LinearGradient(
        colors: [Color(0xff6a6a6a), Color(0xffd1d1cf)],
        stops: [0.25, 0.75],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    }
    else if (position == "3") {
      // Бронзовый цвет
      return const LinearGradient(
        colors: [Color(0xffe58f3f), Color(0xffbe7532)],
        stops: [0.25, 0.75],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    }
    else {
      return const LinearGradient(
        colors: [Color(0xffc9d6ff), Color(0xffe2e2e2)],
        stops: [0, 1],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
              'Клуб "${title}"',
              textAlign: TextAlign.center)
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  decoration: BoxDecoration(
                  gradient: getPositionColor(position),
                    borderRadius: BorderRadius.circular(25.0)
                  ),
                padding: const EdgeInsets.all(16.0),
                  child: Row (
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('# ${position}', textScaler: const TextScaler.linear(5),style: TextStyle(color: Colors.white),),
                      const SizedBox(width: 15),
                      Container(
                        width: 200.0,
                        height: 200.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage('https://sskef.site/${logoURL}'),
                          ),
                        ),
                      ),
                    ],
                  ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color.fromRGBO(11, 106, 108, 0.15)
                      : const Color.fromRGBO(11, 106, 108, 0.15),
                  borderRadius: BorderRadius.circular(8.0)
                ),
                padding: const EdgeInsets.all(16.0),
                  child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('История клуба:', textScaler: TextScaler.linear(1.8),),
                        Text('${description}', textAlign: TextAlign.justify,),
                        const SizedBox(height: 16,),
                        Text('${address}')
                      ],
                  ),
              ),
              const SizedBox(height: 16),
              /*ExpansionTile(
                title: const Text(
                  'Топ 3 пользователей:',
                  style: TextStyle(fontSize: 24),
                  textAlign: TextAlign.left,
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
              ),*/
            ],
          ),
        ),
      )
    );
  }
}
import 'package:flutter/material.dart';
import '../items/customDotIndicator.dart';

class Tab3Page extends StatefulWidget {
  @override
  _Tab3PageState createState() => _Tab3PageState();
}

class _Tab3PageState extends State<Tab3Page> {
  final PageController _pageController = PageController(viewportFraction: 0.8);
  final List<Map<String, dynamic>> data = [
    {
      'title': 'Выполнение достижений',
      'description':
          'Чтобы выполнить достижение вам нужно:\n'
              '• Выбрать желаемые достижения нажатием;\n'
              '• Нажать на кнопку QR-кода справа снизу;\n'
              '• Показать QR-код тренеру;',
      'icon': Icons.qr_code
    },
    {
      'title': 'Начисление XP за достижения',
      'description':
          'За каждое выполненное достижение вы будете получать опыт (XP), '
              'так же вы будете подниматься в топе по рейтингу. Вы можете '
              'мерится количеством опыта с другими студентами :)',
      'icon': Icons.assistant_rounded
    },
    {
      'title': 'Многоразовые достижения',
      'description':
          'Помимо обычных одноразовых достижений есть еще и многоразовые. \n'
              'Их вы можете выполнять столько раз, сколько вам захочется. \n'
              'После выполнения многоразового достижение оно будет отображаться отдельно от всех в вверху списка.\n'
              'Для выполнения многоразового достижения нужно на него нажать в этом списке.\n',
      'icon': Icons.auto_awesome_rounded
    },
    {
      'title': 'Топ пользователей',
      'description':
          'Вы можете перейти на страницу топа 100 пользователей и увидеть '
              'вашу позицию в топе. \nЧем выше вы в списке - тем вы круче. '
              '\n За места в топе можно получать какие-то призы от It_Dino :)',
      'icon': Icons.groups
    },
  ];
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: data.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.1,
                  horizontal: screenWidth * 0.05,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color.fromRGBO(11, 106, 108, 0.15)
                      : const Color.fromRGBO(11, 106, 108, 0.15),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        size: screenWidth * 0.3,
                        data[index]['icon'],
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        data[index]['title'],
                        style: TextStyle(
                          fontSize: screenWidth * 0.07,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        data[index]['description'],
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
              );
            },
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          Positioned(
            left: screenWidth * 0.1,
            bottom: screenHeight * 0.02,
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                _pageController.previousPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.ease,
                );
              },
            ),
          ),
          Positioned(
            right: screenWidth * 0.1,
            bottom: screenHeight * 0.02,
            child: IconButton(
              icon: Icon(Icons.arrow_forward_ios),
              onPressed: () {
                _pageController.nextPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.ease,
                );
              },
            ),
          ),
          Positioned(
            bottom: screenHeight * 0.04,
            left: 0.0,
            right: 0.0,
            child: CustomDotIndicator(
              itemCount: data.length,
              currentIndex: _currentIndex,
              onDotTapped: (index) {
                _pageController.animateToPage(
                  index,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.ease,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

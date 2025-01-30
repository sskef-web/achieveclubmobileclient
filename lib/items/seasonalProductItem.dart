import 'package:flutter/material.dart';

import '../pages/productPage.dart';

class SeasonalProductItem extends StatelessWidget {
  final List<String> imageUrls;
  final List<Color> colors;
  final String category;
  final String title;
  final String price;

  SeasonalProductItem({
    required this.imageUrls,
    required this.colors,
    required this.category,
    required this.title,
    required this.price,
  });

  int _selectedImageIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 160,
      margin: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 190,
            width: 160,
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20)
            ),
            child: Stack(
              children: [
                PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                      _selectedImageIndex = index;
                  },
                  children: imageUrls.map((url) {
                    return Image.network(
                      url,
                      fit: BoxFit.contain,
                    );
                  }).toList(),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(imageUrls.length, (index) {
                      return Container(
                        width: 10.0,
                        height: 10.0,
                        margin: EdgeInsets.symmetric(horizontal: 4.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colors[index],
                          border: Border.all(color: Colors.black, width: 1.0), // Тонкая черная обводка
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 2, left: 0,right: 16),
            child: Text(
              category,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 2, bottom: 4, left: 0,right: 16),
            child: Text(
              title,
              style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.normal),
            ),
          ),
          Container(
            width: 250,
            padding: EdgeInsets.only(top: 8),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(120, 125, 216, 1),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Text(
                '${price}xp',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          )
        ],
      ),
    );
  }
}
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../pages/Product_Page.dart';
import '../main.dart';

class ProductItem extends StatelessWidget {
  final int id;
  final List<dynamic> variants;
  final String type;
  final String title;
  final int price;
  final int balance;
  final bool available;

  ProductItem({
    required this.id,
    required this.variants,
    required this.type,
    required this.title,
    required this.price,
    required this.balance,
    required this.available
  });

  @override
  Widget build(BuildContext context) {

    bool isAvailable = balance >= price;
    int _selectedImageIndex = 0;

    List<String> imageUrls = variants.map<String>((variant) => variant['photo']).toList();
    List<Color> colors = variants.map<Color>((variant) => Color(int.parse('0xFF${variant['color']}'))).toList();
    final PageController _pageController = PageController(initialPage: 0);

    return Container(
      alignment: Alignment.center,
      width: 160,
      height: 350,
      margin: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 190,
            width: 160,
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Color(0xFFDEDEDE),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              children: [
                PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    _selectedImageIndex = index;
                  },
                  children: imageUrls.map((url) {
                    return CachedNetworkImage(
                      imageUrl: '$baseURL/$url',
                      fit: BoxFit.contain,
                      placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
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
                          border: Border.all(color: Colors.black, width: 1.0),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 2, left: 0, right: 16),
            child: Text(
              type,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 2, bottom: 4, left: 0, right: 16),
            child: Text(
              title,
              style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.normal),
            ),
          ),
          Container(
            width: 250,
            padding: EdgeInsets.only(top: 8),
            child: ElevatedButton(
              onPressed: isAvailable ? available ? ()  {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductPage(id: id)),
                );
              } : null : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(245, 110, 15, 1),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: available ? Text(
                '$price xp',
                style: TextStyle(fontSize: 16.0),
              ) : Text(
                'Нет в наличии',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

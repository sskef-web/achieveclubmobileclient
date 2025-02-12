import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../pages/Product_Page.dart';
import '../data/Seasonal_Variant.dart';

class SeasonalProductItem extends StatelessWidget {
  final String seasonColor;
  final int id;
  final List<SeasonalVariant> variants;
  final String type;
  final String title;
  final int price;

  SeasonalProductItem({
    required this.seasonColor,
    required this.id,
    required this.variants,
    required this.type,
    required this.title,
    required this.price,
  });

  int _selectedImageIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    final List<SeasonalVariant> availableVariants = variants.where((variant) => variant.available).toList();

    final List<String> imageUrls = availableVariants.map((variant) => variant.photo).toList();
    final List<Color> colors = availableVariants.map((variant) => Color(int.parse('0xFF${variant.color}'))).toList();

    final bool anyVariantAvailable = availableVariants.isNotEmpty;

    return Container(
      alignment: Alignment.center,
      width: 160,
      height: 350,
      margin: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 190,
                width: 160,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Color(0xFFDEDEDE),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Stack(
                  children: [
                    PageView.builder(
                      controller: _pageController,
                      itemCount: imageUrls.length,
                      itemBuilder: (context, index) {
                        return CachedNetworkImage(
                          imageUrl: '$baseURL/${imageUrls[index]}',
                          fit: BoxFit.contain,
                          placeholder: (context, url) => CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        );
                      },
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
                            margin: EdgeInsets.symmetric(horizontal: 8.0),
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProductPage(id: id)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(int.parse("0xFF$seasonColor")),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Text(
                    '$price xp',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../tabItems/shopTabs/productModal.dart';

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int _selectedColorIndex = 0;
  int _currentImageIndex = 0;

  final Map<Color, List<String>> _images = {
    Colors.black: [
      'https://netbox.by/image/cache/catalog/products_2020/Logitech-G102-LIGHTSYNC-01-417x417.jpg',
      'https://netbox.by/image/cache/catalog/products_2020/Logitech-G102-LIGHTSYNC-01-417x417.jpg',
      'https://netbox.by/image/cache/catalog/products_2020/Logitech-G102-LIGHTSYNC-01-417x417.jpg',
    ],
    Colors.deepPurpleAccent: [
      'https://netbox.by/image/cache/catalog/Logitech/logitech-g102-lightsync-purple-1-417x417.jpg',
      'https://netbox.by/image/cache/catalog/Logitech/logitech-g102-lightsync-purple-1-417x417.jpg',
      'https://netbox.by/image/cache/catalog/Logitech/logitech-g102-lightsync-purple-1-417x417.jpg',
    ],
    Colors.blue: [
      'https://maudio.by/image/cache/catalog/products/5884/logitech-g102-lightsync-goluboy-0-463x463.jpg',
      'https://maudio.by/image/cache/catalog/products/5884/logitech-g102-lightsync-goluboy-0-463x463.jpg',
      'https://maudio.by/image/cache/catalog/products/5884/logitech-g102-lightsync-goluboy-0-463x463.jpg',
    ],
  };

  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentImageIndex = _pageController.page?.round() ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    final List<Color> _colors = _images.keys.toList();
    final List<String>? selectedImages = _images[_colors[_selectedColorIndex]];

    return Scaffold(
      appBar: AppBar(
        title: Text('Магазин'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: 350,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: selectedImages?.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: Image.network(
                              selectedImages![index],
                              fit: BoxFit.contain,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    left: 16.0,
                    bottom: 16.0,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(width: 1, color: Color.fromRGBO(245,110, 15, 1)),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Text(
                        '${_currentImageIndex + 1}/${selectedImages?.length}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color.fromRGBO(245,110, 15, 1),
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Row(
                children: List.generate(_colors.length, (index) {
                  final isSelected = _selectedColorIndex == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedColorIndex = index;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.0),
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _colors[index],
                        shape: BoxShape.rectangle,
                        border: Border.all(
                          color: isSelected ? Color.fromRGBO(245,110, 15, 1) : Colors.transparent,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(10)
                      ),
                    ),
                  );
                }),
              ),
              SizedBox(height: 16.0),
              Text(
                'Игровая мышь',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'Logitech G102',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w100
                ),
              ),
              SizedBox(height: 16.0),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Интерфейс',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Беспроводная радио',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w900
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Тип сенсора',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Оптический',
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w900
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Макс. раз. сенсора',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '12 000 dpi',
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w900
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Макс. частота опроса',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '1000 Гц',
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w900
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ProductModal();
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      alignment: Alignment.center,
                      backgroundColor: Color.fromRGBO(245,110, 15, 1),
                      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Text(
                      '00000xp',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Colors.white
                      ),
                    )
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
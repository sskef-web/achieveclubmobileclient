import 'package:flutter/material.dart';

import '../../items/seasonalProductItem.dart';

class SeasonalTab extends StatelessWidget {
  final bool isAvailable;

  SeasonalTab({required this.isAvailable});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: isAvailable
          ? Padding(
        padding: EdgeInsets.all(16),
        child: Container(
          alignment: Alignment.center,
          child: ListView(
            children: [
              Container(
                height: 140,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/banner.png'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        width: 150,
                        child: Text(
                          'Сезон начался',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            height: 0.8
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 8,horizontal: 8),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(245,110, 15, 1),
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Text(
                            '01.04.2025 - 31.04.2025',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w900
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ),
              SizedBox(height: 8.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0), // Добавляем отступы по бокам
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  spacing: 16.0, // Отступы между элементами по горизонтали
                  runSpacing: 16.0, // Отступы между элементами по вертикали
                  children: [
                    SeasonalProductItem(
                      imageUrls: [
                        'https://netbox.by/image/cache/catalog/products_2020/Logitech-G102-LIGHTSYNC-01-417x417.jpg',
                        'https://netbox.by/image/cache/catalog/Logitech/logitech-g102-lightsync-purple-1-417x417.jpg',
                        'https://maudio.by/image/cache/catalog/products/5884/logitech-g102-lightsync-goluboy-0-463x463.jpg',
                      ],
                      colors: [
                        Colors.black,
                        Colors.deepPurpleAccent,
                        Colors.blue,
                      ],
                      category: 'Игровая мышь',
                      title: 'Logitech G102',
                      price: '00000',
                    ),
                    SeasonalProductItem(
                      imageUrls: [
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTeJoxvMYAk9tKCx0kVz6uPDbuWsyfiamNjBw&s',
                        'https://netbox.by/image/cache/catalog/Logitech/Logitech-G304-Lilac-1-417x417.jpg',
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTHm-YhPblwvhdEx7_zOUtmFuTFTzyeNSV7PQ&s',
                      ],
                      colors: [
                        Colors.black,
                        Colors.deepPurpleAccent,
                        Colors.blue,
                      ],
                      category: 'Игровая мышь',
                      title: 'Logitech G304',
                      price: '00000',
                    ),
                    SeasonalProductItem(
                      imageUrls: [
                        'https://img.5element.by/import/images/ut/goods/good_c5f19180-1dc4-11ef-8db4-005056012b6d/r65-green-sand-rk-chartreuse-provodnaya-klaviatura-royal-kludge-1_600.jpg',
                        'https://img.5element.by/import/images/ut/goods/good_a6561aed-a743-11ef-8db4-005056012b6d/r65-phantom-rk-brown-provodnaya-klaviatura-royal-kludge-1_600.jpg',
                      ],
                      colors: [
                        Color.fromRGBO(134, 165, 125, 1),
                        Colors.black
                      ],
                      category: 'Клавиатура',
                      title: 'Royal Kludge R65',
                      price: '00000',
                    ),
                    SeasonalProductItem(
                      imageUrls: [
                        'https://img.5element.by/import/images/ut/goods/good_863d505d-6d88-11ee-8db3-005056012b6d/981-001053-g435-igrovye-naushniki-logitech-chernyy-1_600.jpg',
                        'https://netbox.by/image/cache/catalog/Logitech/Logitech-G435-blue-1-min-417x417.jpg',
                        'https://netbox.by/image/catalog/Logitech/Logitech-G435-white-1-min.jpg',
                      ],
                      colors: [
                        Colors.black,
                        Colors.deepPurpleAccent,
                        Colors.blue,
                      ],
                      category: 'Наушники',
                      title: 'Logitech G335',
                      price: '00000',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
          :
          Container(
            height: double.infinity,
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.only(top: 64, left: 12, right: 12, bottom: 64),
            decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/banner-two.png'),
              fit: BoxFit.cover,
            ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  child: Text(
                    'Сезонный магазин\nбудет доступен',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        height: 0.8
                    ),
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8,horizontal: 8),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(245,110, 15, 1),
                      borderRadius: BorderRadius.circular(15)
                  ),
                  child: Text(
                    '01.04.2025 - 31.04.2025',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900
                    ),
                  ),
                )
              ],
            ),
          )
    );
  }
}

import 'package:achieveclubmobileclient/items/productItem.dart';
import 'package:flutter/material.dart';

class MainTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(16),
        child: Container(
          alignment: Alignment.center,
          child: ListView(
            children: [
              Container(
                  height: 140,
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(38, 38, 38, 1),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                       Container(
                         width: 100,
                         margin: EdgeInsets.only(right: 16),
                         padding: EdgeInsets.all(8),
                         decoration: BoxDecoration(
                           color: Colors.white,
                           borderRadius: BorderRadius.circular(8)
                         ),
                         child: Image.network('https://netbox.by/image/cache/catalog/products_2020/Logitech-G102-LIGHTSYNC-01-417x417.jpg'),
                       ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              textAlign: TextAlign.left,
                              'В пути',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: Colors.white
                              ),
                            ),
                            Text(
                              textAlign: TextAlign.left,
                              'Игровая мышь\nLogitech G304',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w100,
                                color: Colors.white,
                              ),
                              softWrap: true,
                            ),
                            Text(
                              textAlign: TextAlign.left,
                              'Ожидаем, 21.04.2025',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                                color: Color.fromRGBO(245, 110, 15, 1),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  )
              ),
              SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  spacing: 16.0,
                  runSpacing: 16.0,
                  children: [
                    ProductItem(
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
                    ProductItem(
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
                    ProductItem(
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
                    ProductItem(
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
                    ProductItem(
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
                    ProductItem(
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
                    ProductItem(
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
                    ProductItem(
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
    );
  }
}
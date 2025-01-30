import 'package:achieveclubmobileclient/items/productItem.dart';
import 'package:flutter/material.dart';

class MainTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0), // Добавляем отступы по бокам
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                spacing: 16.0, // Отступы между элементами по горизонтали
                runSpacing: 16.0, // Отступы между элементами по вертикали
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
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}
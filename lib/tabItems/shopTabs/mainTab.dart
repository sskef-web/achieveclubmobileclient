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
                    color: Theme.of(context).brightness == Brightness.dark ? Color.fromRGBO(38, 38, 38, 1) : Color(0xFFDEDEDE),
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
                                color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black
                              ),
                            ),
                            Text(
                              textAlign: TextAlign.left,
                              'Игровая мышь\nLogitech G304',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w100,
                                color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
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
                        'https://i.imgur.com/LDLcrux.png',
                        'https://i.imgur.com/gYxFQiv.png',
                        'https://i.imgur.com/rn3pexQ.png',
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
                        'https://i.imgur.com/nqtuM6y.png',
                        'https://i.imgur.com/fBxVVK5.png',
                        'https://i.imgur.com/4bjMCbT.png',
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
                        'https://i.imgur.com/j3PRh1k.png',
                        'https://i.imgur.com/AjdqlDj.png',
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
                        'https://i.imgur.com/5pL2bBn.png',
                        'https://i.imgur.com/xL62Lji.png',
                        'https://i.imgur.com/GesiWZb.png',
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
                        'https://i.imgur.com/LDLcrux.png',
                        'https://i.imgur.com/gYxFQiv.png',
                        'https://i.imgur.com/rn3pexQ.png',
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
                        'https://i.imgur.com/nqtuM6y.png',
                        'https://i.imgur.com/fBxVVK5.png',
                        'https://i.imgur.com/4bjMCbT.png',
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
                        'https://i.imgur.com/j3PRh1k.png',
                        'https://i.imgur.com/AjdqlDj.png',
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
                        'https://i.imgur.com/5pL2bBn.png',
                        'https://i.imgur.com/xL62Lji.png',
                        'https://i.imgur.com/GesiWZb.png',
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
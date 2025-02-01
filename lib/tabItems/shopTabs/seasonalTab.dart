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
                margin: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/season-mini-banner.png'),
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
                            height: 0.8,
                            color: Colors.white
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
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  spacing: 16.0,
                  runSpacing: 16.0,
                  children: [
                    SeasonalProductItem(
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
                    SeasonalProductItem(
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
                    SeasonalProductItem(
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
                    SeasonalProductItem(
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
                    SeasonalProductItem(
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
                    SeasonalProductItem(
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
                    SeasonalProductItem(
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
                    SeasonalProductItem(
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
          :
          Container(
            height: double.infinity,
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.only(top: 64, left: 12, right: 12, bottom: 64),
            decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/season-banner.png'),
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
                        height: 1,
                      color: Colors.white
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

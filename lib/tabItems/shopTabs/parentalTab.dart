import 'package:achieveclubmobileclient/items/productItem.dart';
import 'package:flutter/material.dart';

class ParentalTab extends StatelessWidget {
  final bool isAvailable;

  ParentalTab({required this.isAvailable});

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
                    margin: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('images/parental-mini-banner.jpg'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(12),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            width: 210,
                            child: Text(
                              'Подарки\nдля близких',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 28,
                                  color: Color.fromRGBO(245,110, 15, 1),
                                  fontWeight: FontWeight.w900,
                                  height: 1
                              ),
                            ),
                          ),
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
            :
        Container(
          height: double.infinity,
          margin: EdgeInsets.all(16),
          padding: EdgeInsets.only(top: 64, left: 12, right: 12, bottom: 64),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/parental-banner.jpg'),
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
                  'Магазин с подарками для близких',
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
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)
                ),
                child: Text(
                  'временно недоступен',
                  style: TextStyle(
                      color: Color.fromRGBO(245,110, 15, 1),
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
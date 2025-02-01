import 'package:achieveclubmobileclient/tabItems/shopTabs/buyResultModal.dart';
import 'package:flutter/material.dart';

class ProductModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: IntrinsicHeight (
          child:Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark ? Color.fromRGBO(38,38,38, 1) : Colors.white,
          borderRadius: BorderRadius.circular(40.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: Image.network(
                    'https://netbox.by/image/cache/catalog/products_2020/Logitech-G102-LIGHTSYNC-01-417x417.jpg',
                    width: 110,
                    height: 130,
                    fit: BoxFit.fitHeight,
                  ),
                ),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '00000xp',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Игровая мышь',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                        ),
                      ),
                      Text(
                        'Logitech G304',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                        ),
                      ),
                      Text(
                        'Цвет: Черный',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Приедет 21.04.2025',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Color.fromRGBO(245,110, 15, 1),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      // Действие при нажатии на кнопку "Отменить"
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).brightness == Brightness.dark ? Color.fromRGBO(38,38,38, 1) : Colors.white,
                      foregroundColor: Color.fromRGBO(245,110, 15, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        side: BorderSide(color: Color.fromRGBO(245,110, 15, 1)),
                      ),
                    ),
                    child: Text(
                        'Отменить',
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return BuyResultModal();
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color.fromRGBO(245,110, 15, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    child: Text('Заказать'),
                  ),
                ),
              ],
            ),
          ],
        ),
      )
      ),
    );
  }
}
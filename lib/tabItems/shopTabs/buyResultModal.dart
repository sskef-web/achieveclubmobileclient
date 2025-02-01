import 'package:flutter/material.dart';

class BuyResultModal extends StatelessWidget {

  final result = true;

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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    'Ваш заказ',
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w900
                  ),
                ),
                result ? Text(
                  'успешно оформлен',
                  style: TextStyle(
                      color: Color.fromRGBO(184, 207, 37, 1),
                      fontSize: 24,
                      fontWeight: FontWeight.w900
                  ),
                ) : Text(
                  'отклонен',
                  style: TextStyle(
                      color: Color.fromRGBO(215, 24, 29, 1),
                      fontSize: 24,
                      fontWeight: FontWeight.w900
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'Статус заказа отображается в профиле',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w100,
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(245,110, 15, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: BorderSide(color: Color.fromRGBO(245,110, 15, 1)),
                        ),
                      ),
                      child: Text(
                          'Вернуться в магазин',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          fontSize: 16
                        ),
                      )
                  ),
                )
              ],
            ),
          )
      ),
    );
  }
}
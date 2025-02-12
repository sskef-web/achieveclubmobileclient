import 'dart:io';

import 'package:achieveclubmobileclient/tabItems/shopTabs/Modal_Buy_Result.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../main.dart';

class ProductModal extends StatelessWidget {
  final int id;
  final int variantId;
  final int price;
  final String type;
  final String title;
  final String color;
  final String imageUrl;
  final int userBalance;


  ProductModal({
    required this.id,
    required this.variantId,
    required this.price,
    required this.type,
    required this.title,
    required this.color,
    required this.imageUrl,
    required this.userBalance
  });

  Future<String?> loadCookies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('cookies');
  }

  String? extractTokenFromCookies(String cookies) {
    var cookieList = cookies.split(';');
    for (var cookie in cookieList) {
      if (cookie.contains('X-Access-Token')) {
        var token = cookie.split('=')[1];
        return token;
      }
    }
    return null;
  }

  Future<void> _createOrder(BuildContext context) async {
    var cookies = await loadCookies();
    var token = extractTokenFromCookies(cookies!);
    final response = await http.post(
      Uri.parse('${baseURL}api/orders'),
      body: json.encode({
        'productId': id.toString(),
        'variantId': variantId.toString(),
      }),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 201) {
      debugPrint('Order created - ${response.body} (Status code - ${response.statusCode})');
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return BuyResultModal(result: true, errorMessage: '',);
        },
      );
    }
    else if (response.statusCode == 401) {
      refreshToken();
      _createOrder(context);
    }
    else {
      debugPrint('Order error - ${response.body} (Status code - ${response.statusCode})');
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return BuyResultModal(result: false, errorMessage: response.body);
        },
      );
    }
  }

  Future<void> saveCookies(String cookies) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('cookies', cookies);
  }


  Future<void> refreshToken() async {
    var refreshUrl = Uri.parse('${baseURL}api/auth/refresh');
    var cookies = await loadCookies();

    var response = await http.get(refreshUrl, headers: {
      'Cookie': cookies!,
    });

    if (response.statusCode == 200) {
      var newCookies = response.headers['set-cookie'];
      if (newCookies != null) {
        await saveCookies(newCookies);
      }
    }
    else {
      throw Exception(
          'Error token refresh (code: ${response.statusCode}');
    }
  }


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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: Image.network(
                    '${imageUrl}',
                    width: 110,
                    height: 130,
                    fit: BoxFit.contain,
                  ),
                ),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${price}xp',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        '$type',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                        ),
                      ),
                      Text(
                        '$title',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                        ),
                      ),
                      Text(
                        'Цвет: $color',
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
                      _createOrder(context);
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
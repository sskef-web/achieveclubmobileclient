import 'dart:io';

import 'package:achieveclubmobileclient/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:achieveclubmobileclient/items/productItem.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainTab extends StatefulWidget {
  final int id;

  MainTab({required this.id});

  @override
  _MainTabState createState() => _MainTabState();
}

class _MainTabState extends State<MainTab> {
  List<dynamic> _orders = [];
  List<dynamic> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
    _fetchOrders();
  }

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

  Future<void> _fetchOrders() async {
    var cookies = await loadCookies();
    var token = extractTokenFromCookies(cookies!);

    final response = await http.get(
      Uri.parse('${baseURL}api/orders'),
      headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      setState(() {
        _orders = json.decode(response.body);
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load orders');
    }
  }

  Future<void> _fetchProducts() async {
    final response = await http.get(Uri.parse('${baseURL}api/products?categoryId=${widget.id}'));

    if (response.statusCode == 200) {
      setState(() {
        _products = json.decode(response.body);
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          alignment: Alignment.center,
          child: ListView(
            children: [
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : Column(
                children: [
                  Container(
                    height: 160,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: _orders.map((order) {
                        return Container(
                          width: 310,
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Color.fromRGBO(38, 38, 38, 1)
                                : Color(0xFFDEDEDE),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: 100,
                                  height: 100,
                                  margin: EdgeInsets.only(right: 16),
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Image.network('${baseURL}/${order['photo']}'),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        order['deliveryStatus'],
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w900,
                                          color: Theme.of(context).brightness == Brightness.dark
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                      Text(
                                        '${order['productType']}\n${order['productTitle']}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w100,
                                          color: Theme.of(context).brightness == Brightness.dark
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                        softWrap: true,
                                      ),
                                      Text(
                                        'Ожидаем ${DateTime.parse(order['orderDate']).day.toString().padLeft(2, '0')}.${DateTime.parse(order['orderDate']).month.toString().padLeft(2, '0')}.${DateTime.parse(order['orderDate']).year}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w900,
                                          color: Color.fromRGBO(245, 110, 15, 1),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      spacing: 16.0,
                      runSpacing: 16.0,
                      children: _products.map((product) {
                        final List<dynamic> variants = product['variants'];
                        final bool anyVariantAvailable = variants.any((variant) => variant['available']);
                        final List<dynamic> availableVariants = variants.where((variant) => variant['available']).toList();

                        return Stack(
                          children: [
                            ProductItem(
                              id: product['id'],
                              variants: availableVariants,
                              type: product['type'],
                              title: product['title'],
                              price: product['price'],
                            ),
                            if (!anyVariantAvailable)
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(topRight: Radius.circular(25), topLeft: Radius.circular(25), bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Товара\nнет в наличии',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w100,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

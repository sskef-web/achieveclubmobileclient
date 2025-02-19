import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../data/Seasonal_Product.dart';
import '../data/Seasonal_Variant.dart';
import '../items/Product_Item.dart';
import '../items/Seasonal_Product_Item.dart';
import '../main.dart';

class ShopPage extends StatefulWidget {
  final int categoryId;
  final String? banner;
  final String? color;
  final String? startDate;
  final String? endDate;
  final bool available;

  ShopPage({
    required this.categoryId,
    required this.banner,
    required this.color,
    required this.startDate,
    required this.endDate,
    required this.available,
  });

  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  List<dynamic> _orders = [];
  List<dynamic> _products = [];
  List<SeasonalProduct> _seasonalProducts = [];
  bool _isLoading = true;
  int balance = 0;

  @override
  void initState() {
    super.initState();
    if (isSeasonal && isWithinSeason()) {
      _fetchSeasonalProducts();
    } else if (widget.available) {
      _fetchProducts();
    }
    _fetchOrders();
    fetchUserBalance();
  }

  bool get isSeasonal {
    return widget.startDate != null && widget.endDate != null;
  }

  bool isWithinSeason() {
    if (!isSeasonal) return false;
    DateTime now = DateTime.now();
    DateTime start = DateTime.parse(widget.startDate!);
    DateTime end = DateTime.parse(widget.endDate!);
    return now.isAfter(start) && now.isBefore(end);
  }

  Future<void> fetchUserBalance() async {
    var cookies = await loadCookies();
    var token = extractTokenFromCookies(cookies!);
    var url = Uri.parse('${baseURL}api/balance');

    var response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});
    debugPrint('${response.statusCode}');

    if (response.statusCode == 200) {
      setState(() {
        balance = int.parse(response.body);
      });
    } else if (response.statusCode == 401) {
      fetchUserBalance();
    } else {
      throw Exception('Fetch user balance error!');
    }
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
      headers: {'Authorization': 'Bearer $token'},
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
    final response = await http.get(
        Uri.parse('${baseURL}api/products?categoryId=${widget.categoryId}'));

    if (response.statusCode == 200) {
      setState(() {
        _products = json.decode(response.body);
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<void> _fetchSeasonalProducts() async {
    final response = await http.get(
        Uri.parse('${baseURL}api/products?categoryId=${widget.categoryId}'));

    if (response.statusCode == 200) {
      setState(() {
        _seasonalProducts = (json.decode(response.body) as List)
            .map((productJson) => SeasonalProduct.fromJson(productJson))
            .toList();
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load seasonal products');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.available) {
      return Scaffold(
        body: Center(
            child: Container(
          height: double.infinity,
          margin: EdgeInsets.all(16),
          padding: EdgeInsets.only(top: 64, left: 12, right: 12, bottom: 64),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage("$baseURL${widget.banner}"),
              fit: BoxFit.contain,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
        )),
      );
    }

    if (isSeasonal && !isWithinSeason()) {
      return Scaffold(
        body: Center(
          child: widget.banner != null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 200,
                      margin: EdgeInsets.all(16),
                      padding: EdgeInsets.only(
                          top: 64, left: 12, right: 12, bottom: 64),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage("${baseURL}${widget.banner}"),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            width: double.infinity,
                            child: Text(
                              'Сезонный магазин\nбудет доступен',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                                height: 1,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 8),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(245, 110, 15, 1),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              '${DateTime.parse(widget.startDate!).day.toString().padLeft(2, '0')}.${DateTime.parse(widget.startDate!).month.toString().padLeft(2, '0')}.${DateTime.parse(widget.startDate!).year} - ${DateTime.parse(widget.endDate!).day.toString().padLeft(2, '0')}.${DateTime.parse(widget.endDate!).month.toString().padLeft(2, '0')}.${DateTime.parse(widget.endDate!).year}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : Text('Сезонный магазин временно недоступен.'),
        ),
      );
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            if (widget.banner != null)
              Container(
                height: 140,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage('${baseURL}${widget.banner}'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            if (!isSeasonal)
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
                              child:
                                  Image.network('${baseURL}/${order['photo']}'),
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
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                  Text(
                                    '${order['productType']}\n${order['productTitle']}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w100,
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
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
            if (_isLoading)
              Center(child: CircularProgressIndicator())
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  spacing: 16.0,
                  runSpacing: 16.0,
                  children: isSeasonal
                      ? _seasonalProducts.map((product) {
                          final List<SeasonalVariant> variants =
                              product.variants;
                          final bool anyVariantAvailable =
                              variants.any((variant) => variant.available);
                          return SeasonalProductItem(
                            seasonColor: widget.color ?? '',
                            id: product.id,
                            variants: variants,
                            type: product.category,
                            title: product.title,
                            price: product.price,
                            balance: balance,
                            available: anyVariantAvailable,
                          );
                        }).toList()
                      : _products.map((product) {
                          final List<dynamic> variants = product['variants'];
                          final bool anyVariantAvailable =
                              variants.any((variant) => variant['available']);
                          return ProductItem(
                            id: product['id'],
                            variants: variants,
                            type: product['type'],
                            title: product['title'],
                            price: product['price'],
                            balance: balance,
                            available: anyVariantAvailable,
                          );
                        }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

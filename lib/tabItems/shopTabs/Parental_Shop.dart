import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:achieveclubmobileclient/items/Product_Item.dart';

import '../../main.dart';

class ParentalTab extends StatefulWidget {
  bool isAvailable;
  final int id;

  ParentalTab({required this.isAvailable, required this.id});

  @override
  _ParentalTabState createState() => _ParentalTabState();
}

class _ParentalTabState extends State<ParentalTab> {
  List<dynamic> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    if (widget.isAvailable) {
      _fetchProducts();
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchProducts() async {
    final response = await http.get(Uri.parse('${baseURL}api/products?categoryId=${widget.id}'));

    if (response.statusCode == 200) {
      setState(() {
        _products = json.decode(response.body);
        _isLoading = false;
        widget.isAvailable = _products.isNotEmpty;
      });
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: widget.isAvailable
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
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: 210,
                        child: Text(
                          'Подарки\nдля близких',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 28,
                            color: Color.fromRGBO(245, 110, 15, 1),
                            fontWeight: FontWeight.w900,
                            height: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8.0),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  spacing: 16.0,
                  runSpacing: 16.0,
                  children: _products.map((product) {
                    return ProductItem(
                      id: product['id'],
                      variants: product['variants'],
                      type: product['type'],
                      title: product['title'],
                      price: product['price'],
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      )
          : Container(
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
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                'временно недоступен',
                style: TextStyle(
                  color: Color.fromRGBO(245, 110, 15, 1),
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

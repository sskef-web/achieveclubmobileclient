import 'dart:io';

import 'package:achieveclubmobileclient/main.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../data/Product_Data.dart';
import '../data/Variant.dart';
import '../tabItems/shopTabs/Modal_Product.dart';

class ProductPage extends StatefulWidget {
  final int id;

  const ProductPage({required this.id});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  ProductData? _productData;
  bool _isLoading = true;
  int _selectedColorIndex = 0;
  int _currentImageIndex = 0;
  int userBalance = 0;

  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _fetchProductData();
    _pageController.addListener(() {
      setState(() async {
        _currentImageIndex = _pageController.page?.round() ?? 0;
        userBalance = await _fetchBalance();
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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

  Future<int> _fetchBalance() async {
    var cookies = await loadCookies();
    var token = extractTokenFromCookies(cookies!);
    final response = await http.get(Uri.parse('${baseURL}api/balance'), headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token'
    });

    if (response.statusCode == 200) {
      return int.parse(response.body);
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<void> _fetchProductData() async {
    final response = await http.get(Uri.parse('${baseURL}api/products/${widget.id}'));
    if (response.statusCode == 200) {
      setState(() {
        _productData = ProductData.fromJson(json.decode(response.body));
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load product data');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _productData == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Магазин'),
          centerTitle: true,
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final List<Variant> variants = _productData!.variants;
    final List<Color> colors = variants.map<Color>((variant) => Color(int.parse('0xFF${variant.color}'))).toList();
    final List<String>? selectedImages = variants[_selectedColorIndex].photos.map<String>((photo) => '$baseURL/${photo.url}').toList();
    final int variantId = variants[_selectedColorIndex].id;
    final bool anyVariantAvailable = variants.any((variant) => variant.isAvailable);

    return Scaffold(
      appBar: AppBar(
        title: Text('Магазин'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: 350,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Color(0xFFDEDEDE),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: selectedImages?.length,
                      itemBuilder: (context, index) {
                        return Container(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: CachedNetworkImage(
                              imageUrl: selectedImages![index],
                              fit: BoxFit.contain,
                              placeholder: (context, url) => CircularProgressIndicator(),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    left: 16.0,
                    bottom: 16.0,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(width: 1, color: Color.fromRGBO(245, 110, 15, 1)),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Text(
                        '${_currentImageIndex + 1}/${selectedImages?.length}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color.fromRGBO(245, 110, 15, 1),
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Row(
                children: List.generate(colors.length, (index) {
                  final isSelected = _selectedColorIndex == index;
                  final isAvailable = variants[index].isAvailable;
                  return GestureDetector(
                    onTap: () {
                      if (isAvailable) {
                        setState(() {
                          _selectedColorIndex = index;
                        });
                      }
                    },
                    child: Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 4.0),
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: colors[index],
                            shape: BoxShape.rectangle,
                            border: Border.all(
                              color: isSelected ? Color.fromRGBO(245, 110, 15, 1) : Colors.transparent,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        if (!isAvailable)
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 4.0),
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color.fromRGBO(245, 110, 15, 1),
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.close,
                                color: Color.fromRGBO(245, 110, 15, 1),
                                size: 20,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }),
              ),
              SizedBox(height: 16.0),
              Text(
                _productData!.type,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                _productData!.title,
                style: TextStyle(
                  fontSize: 20.0,
                  color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w100,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                _productData!.details,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 16.0),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: anyVariantAvailable
                      ? () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ProductModal(
                          id: _productData!.id,
                          variantId: variantId,
                          price: _productData!.price,
                          color: variants[_selectedColorIndex].title,
                          type: _productData!.type,
                          title: _productData!.title,
                          imageUrl: selectedImages!.first,
                          userBalance: userBalance,
                        );
                      },
                    );
                  }
                      : null,
                  style: ElevatedButton.styleFrom(
                    alignment: Alignment.center,
                    backgroundColor: Color.fromRGBO(245, 110, 15, 1),
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Text(
                    '${_productData!.price}xp',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

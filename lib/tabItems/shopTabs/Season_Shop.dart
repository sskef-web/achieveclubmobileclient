import 'package:achieveclubmobileclient/data/Seasonal_Variant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../data/Seasonal_Product.dart';
import '../../items/Seasonal_Product_Item.dart';
import '../../main.dart';

class SeasonalTab extends StatefulWidget {
  final bool isAvailable;
  final String color;
  final String startDate;
  final String endDate;
  final int id;

  SeasonalTab({
    required this.isAvailable,
    required this.color,
    required this.startDate,
    required this.endDate,
    required this.id,
  });

  @override
  _SeasonalTabState createState() => _SeasonalTabState();
}

class _SeasonalTabState extends State<SeasonalTab> {
  List<SeasonalProduct> _seasonalProducts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSeasonalProducts();
  }

  Future<void> _fetchSeasonalProducts() async {
    final response = await http.get(Uri.parse('${baseURL}api/products?categoryId=${widget.id}'));

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
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(245, 110, 15, 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${DateTime.parse(widget.startDate).day.toString().padLeft(2, '0')}.${DateTime.parse(widget.startDate).month.toString().padLeft(2, '0')}.${DateTime.parse(widget.startDate).year} - ${DateTime.parse(widget.endDate).day.toString().padLeft(2, '0')}.${DateTime.parse(widget.endDate).month.toString().padLeft(2, '0')}.${DateTime.parse(widget.endDate).year}',
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
                  children: _seasonalProducts.map((product) {
                    final List<SeasonalVariant> variants = product.variants;
                    final bool anyVariantAvailable = variants.any((variant) => variant.available);
                    final List<dynamic> availableVariants = variants.where((variant) => variant.available).toList();

                    return Stack(
                      children: [
                        SeasonalProductItem(
                            seasonColor: widget.color,
                            id: product.id,
                            variants: variants,
                            type: product.category,
                            title: product.title,
                            price: product.price
                        ),
                        if (!anyVariantAvailable)
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(25),
                                  topLeft: Radius.circular(25),
                                  bottomLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15),
                                ),
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
        ),
      )
          : Container(
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
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color.fromRGBO(245, 110, 15, 1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                '${DateTime.parse(widget.startDate).day.toString().padLeft(2, '0')}.${DateTime.parse(widget.startDate).month.toString().padLeft(2, '0')}.${DateTime.parse(widget.startDate).year} - ${DateTime.parse(widget.endDate).day.toString().padLeft(2, '0')}.${DateTime.parse(widget.endDate).month.toString().padLeft(2, '0')}.${DateTime.parse(widget.endDate).year}',
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
    );
  }
}

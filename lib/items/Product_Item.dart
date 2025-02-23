import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../pages/Product_Page.dart';
import '../main.dart';

class ProductItem extends StatefulWidget {
  final int id;
  final List<dynamic> variants;
  final String type;
  final String title;
  final int price;
  final int balance;
  final bool available;

  ProductItem({
    required this.id,
    required this.variants,
    required this.type,
    required this.title,
    required this.price,
    required this.balance,
    required this.available
  });

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  int _selectedImageIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedColor(_selectedImageIndex);
    });
  }

  void _scrollToSelectedColor(int index) {
    final double itemSize = 24.0;
    final double offset = index * itemSize;
    final double halfScreen = MediaQuery.of(context).size.width / 2;
    final double scrollOffset = offset - halfScreen + itemSize / 2;

    _scrollController.animateTo(
      scrollOffset.clamp(0.0, _scrollController.position.maxScrollExtent),
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isAvailable = widget.balance >= widget.price;

    List<String> imageUrls = widget.variants.map<String>((variant) {
      return variant['photo'] != null ? variant['photo']! : '';
    }).toList();

    List<Color> colors = widget.variants.map<Color>((variant) => Color(int.parse('0xFF${variant['color']}'))).toList();

    return Container(
      alignment: Alignment.center,
      width: 160,
      height: 360,
      margin: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 190,
            width: 160,
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Color(0xFFDEDEDE),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              children: [
                PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _selectedImageIndex = index;
                    });
                    _scrollToSelectedColor(index);
                  },
                  children: imageUrls.map((url) {
                    return CachedNetworkImage(
                      imageUrl: '$baseURL/$url',
                      fit: BoxFit.contain,
                      placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    );
                  }).toList(),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(imageUrls.length, (index) {
                        return Container(
                          width: 16.0,
                          height: 16.0,
                          margin: EdgeInsets.symmetric(horizontal: 4.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colors[index],
                            border: Border.all(
                              color: _selectedImageIndex == index ? Colors.black : Colors.transparent,
                              width: 2.0,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 2, left: 0, right: 16),
            child: Text(
              widget.type,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 2, bottom: 4, left: 0, right: 16),
            child: Text(
              widget.title,
              style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal),
            ),
          ),
          Container(
            width: 250,
            padding: EdgeInsets.only(top: 8),
            child: ElevatedButton(
              onPressed: isAvailable ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductPage(id: widget.id)),
                );
              } : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(245, 110, 15, 1),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Text(
                '${widget.price} xp',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

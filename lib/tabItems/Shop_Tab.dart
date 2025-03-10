import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../main.dart';
import '../pages/Shop_Page.dart';

class Tab3Page extends StatefulWidget {
  @override
  _Tab3PageState createState() => _Tab3PageState();
}

class _Tab3PageState extends State<Tab3Page> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  List<dynamic> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  Future<void> _fetchCategories() async {
    final response = await http.get(Uri.parse('${baseURL}api/categories'));

    if (response.statusCode == 200) {
      setState(() {
        _categories = json.decode(response.body);
        _isLoading = false;
        _tabController = TabController(length: _categories.length, vsync: this);
        _tabController?.addListener(() {
          setState(() {});
        });
      });
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Widget _buildTab(int index) {
    bool isSelected = _tabController?.index == index;
    return GestureDetector(
      onTap: () {
        if (_tabController != null) {
          _tabController!.animateTo(index);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
        margin: EdgeInsets.symmetric(vertical: 0, horizontal: 0.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(width: 1.0, color: const Color.fromRGBO(245, 110, 15, 1)),
          color: isSelected
              ? Color.fromRGBO(245, 110, 15, 1)
              : Colors.transparent,
        ),
        child: Text(
          _categories[index]['title'],
          style: TextStyle(
              color: isSelected
                  ? Colors.white
                  : Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w300),
        ),
      ),
    );
  }

  Widget _buildTabContent(int index) {
    final category = _categories[index];
    return ShopPage(categoryId: category['id'], banner: category['banner'], color: category['color'], startDate: category['startDate'], endDate: category['endDate'], available: category['available'],);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !_isLoading
            ? SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            spacing: 5,
            children: List.generate(
              _categories.length,
                  (index) => _buildTab(index),
            ),
          ),
        )
            : Container(),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : TabBarView(
        controller: _tabController,
        children: List.generate(_categories.length, _buildTabContent),
      ),
    );
  }
}

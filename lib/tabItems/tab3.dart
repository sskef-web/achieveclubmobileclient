import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../main.dart';
import 'shopTabs/mainTab.dart';
import 'shopTabs/parentalTab.dart';
import 'shopTabs/seasonalTab.dart';

class Tab3Page extends StatefulWidget {

  @override
  _Tab3PageState createState() => _Tab3PageState();
}

class _Tab3PageState extends State<Tab3Page> with SingleTickerProviderStateMixin {
  String appTitle = 'Магазин';
  int _selectedIndex = 0;
  List<dynamic> _categories = [];
  bool _isLoading = true;
  var balance;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    final response = await http.get(Uri.parse('${baseURL}api/categories'));

    if (response.statusCode == 200) {
      setState(() {
        _categories = json.decode(response.body);
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load categories');
    }
  }


  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildTab(int index, String text) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onTabSelected(index),
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
          text,
          style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark ? Colors.white : isSelected ? Colors.white : Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w300
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(int index) {
    try{
      if (index == 0) {
        return MainTab(id: _categories[index]['id']);
      } else if (index == 1) {
        return ParentalTab(isAvailable: true, id: _categories[index]['id']);
      }
      else {
        var seasonalCategory = _categories.firstWhere(
              (category) => category['startDate'] != null,
          orElse: () => null,
        );
        if (seasonalCategory != null) {
          bool isAvailable = seasonalCategory['endDate'] == null ||
              DateTime.parse(seasonalCategory['endDate']).isAfter(DateTime.now());

          return SeasonalTab(
            isAvailable: isAvailable,
            startDate: seasonalCategory['startDate'],
            endDate: seasonalCategory['endDate'],
            color: seasonalCategory['color'],
            id: seasonalCategory['id'],
          );
        }
        else {
          return SizedBox();
        }
      }
    }
    catch (e) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Магазин временно недоступен.', textAlign: TextAlign.center,style: TextStyle(fontSize: 18,)),
            SizedBox(height: 6),
            Text('Если вы видите эту ошибку - передайте информацию своему тренеру.', textAlign: TextAlign.center,style: TextStyle(fontSize: 18,)),
            SizedBox(height: 6),
            Text('${e}', textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: Colors.red),),
          ],
        )
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !_isLoading
            ? Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            _categories.length,
                (index) => _buildTab(index, _categories[index]['title']),
          ),
        ) : Container(),
      ),
      body: _isLoading ? Center(child: CircularProgressIndicator()) : _buildTabContent(_selectedIndex),
    );
  }
}

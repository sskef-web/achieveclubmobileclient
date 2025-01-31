import 'package:flutter/material.dart';

import 'shopTabs/mainTab.dart';
import 'shopTabs/parentalTab.dart';
import 'shopTabs/seasonalTab.dart';

class Tab3Page extends StatefulWidget {
  @override
  _Tab3PageState createState() => _Tab3PageState();
}

class _Tab3PageState extends State<Tab3Page> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  bool _isSeasonalStoreAvailable = false;
  bool _isParentalStoreAvailable = false;

  @override
  void initState() {
    super.initState();
    _isSeasonalStoreAvailable = true;
    _isParentalStoreAvailable = true;
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
          style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w300),
        ),
      ),
    );
  }

  Widget _buildTabContent(int index) {
    switch (index) {
      case 0:
        return MainTab();
        break;
      case 1:
        return SeasonalTab(isAvailable: _isSeasonalStoreAvailable);
        break;
      case 2:
        return ParentalTab(isAvailable: _isParentalStoreAvailable,);
        break;
      default:
        return SizedBox();
        break;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTab(0, 'Главный'),
              _buildTab(1, 'Сезонный'),
              _buildTab(2, 'Порадуй близких'),
            ],
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            color: Color.fromRGBO(27, 26, 31, 1)
          ),
          child: _buildTabContent(_selectedIndex),
        ),
    );
  }
}


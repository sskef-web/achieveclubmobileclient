import 'package:flutter/material.dart';

import 'shopTabs/mainTab.dart';
import 'shopTabs/parentalTab.dart';
import 'shopTabs/seasonalTab.dart';

class Tab3Page extends StatefulWidget {
  @override
  _Tab3PageState createState() => _Tab3PageState();
}

class _Tab3PageState extends State<Tab3Page> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isSeasonalStoreAvailable = false;
  bool _isParentalStoreAvailable = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _isSeasonalStoreAvailable = true;
    _isParentalStoreAvailable = true;
  }

  void _handleTabSelection() {
    setState(() {});
  }

  @override
  void dispose() {
    _tabController?.removeListener(_handleTabSelection);
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          alignment: Alignment.center,
          child: TabBar(
            tabAlignment: TabAlignment.center,
            controller: _tabController,
            dividerColor: Colors.transparent,
            indicator: BoxDecoration(
              color: Colors.transparent,
            ),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white,
            tabs: [
              Tab(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    border: _tabController?.index == 0 ? Border.all(width: 0) : Border.all(width: 1.0, color: const Color.fromRGBO(245,110, 15, 1)),
                    color: _tabController?.index == 0 ? Color.fromRGBO(245,110, 15, 1) : Colors.transparent,
                  ),
                  child: Text(
                    'Главная',
                  ),
                ),
              ),
              Tab(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    border: _tabController?.index == 1 ? Border.all(width: 0) : Border.all(width: 1.0, color: const Color.fromRGBO(245,110, 15, 1)),
                    color: _tabController?.index == 1 ? Color.fromRGBO(245,110, 15, 1) : Colors.transparent,
                  ),
                  child: Text(
                    'Сезонный',
                  ),
                ),
              ),
              Tab(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    border: _tabController?.index == 2 ? Border.all(width: 0) : Border.all(width: 1.0, color: const Color.fromRGBO(245,110, 15, 1)),
                    color: _tabController?.index == 2 ? Color.fromRGBO(245,110, 15, 1) : Colors.transparent,
                  ),
                  child: Text(
                    'Родителям',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
            controller: _tabController,
            children: [
              MainTab(),
              SeasonalTab(isAvailable: _isSeasonalStoreAvailable,),
              ParentalTab(isAvailable: _isParentalStoreAvailable,),
            ],
          ),
    );
  }
}


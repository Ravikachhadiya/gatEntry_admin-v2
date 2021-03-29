import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../screens/approval_request_screen.dart';
import '../screens/city_screen.dart';

import '../widgets/app_drawer.dart';

class TabScreen extends StatefulWidget {
  static const routeName = 'tab-screen';

  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  List<Map<String, Object>> _pages;
  int _selectedPageIndex = 1;

  @override
  void initState() {
    _pages = [
      {
        'page': CityScreen(),
        'lable': 'City',
      },
      {
        'page': ApprovalRequestScreen(),
        'lable': 'GatEntry',
      },
    ];
    super.initState();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
      appBar: _selectedPageIndex == 1
          ? AppBar(
              title: Text(_pages[_selectedPageIndex]['lable']),
            )
          : null,
      drawer: AppDrawer(),
      body: _pages[_selectedPageIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Theme.of(context).accentColor,
        currentIndex: _selectedPageIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.location_city),
            label: 'City',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.approval),
            label: 'Requests',
          ),
        ],
      ),
    );
  }
}

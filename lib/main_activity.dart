import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vulnerabilities_database/screens/news_activity.dart';
import 'package:vulnerabilities_database/screens/search_activity.dart';

class MainActivity extends StatefulWidget {
  const MainActivity({Key? key}) : super(key: key);

  @override
  State<MainActivity> createState() => _MainActivityState();
}

class _MainActivityState extends State<MainActivity> {


  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    const NewsPage(),
    SearchActivity(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          onTap: _onItemTapped,
          currentIndex: _selectedIndex, //New

          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFF121212),

          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white.withOpacity(.40),
          selectedFontSize: 13,
          unselectedFontSize: 13,

          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.newspaper),
              label: 'Latest news',
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.magnifyingGlass),
              label: 'Search exploits',
            ),
          ],


        ),
      ),
    );
  }
}

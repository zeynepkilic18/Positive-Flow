import 'package:flutter/material.dart';
import 'package:pozitivity/screens/CategoriesScreen.dart';
import 'package:pozitivity/screens/FavouritesScreen.dart';
import 'package:pozitivity/screens/HomeScreen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = <Widget>[
    HomeScreen(),
    CategoriesScreen(),
    FavoritesScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color selectedColor = Color.fromARGB(255, 175, 202, 176);
    const Color unselectedColor = Colors.grey;

    return Scaffold(
      body: Center(
        child: _screens.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                _selectedIndex == 0
                    ? Icons.home
                    : Icons.home_outlined,
              ),
              label: 'Ana Sayfa',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                _selectedIndex == 1
                    ? Icons.menu_book
                    : Icons.menu_book_outlined,
              ),
              label: 'Kategoriler',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                _selectedIndex == 2
                    ? Icons.star
                    : Icons.star_border,
              ),
              label: 'Favoriler',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: selectedColor,
          unselectedItemColor:
              unselectedColor,
          onTap: _onItemTapped,
          backgroundColor: Colors
              .transparent,
          elevation: 0,
          showSelectedLabels:
              false,
          showUnselectedLabels: false,
        ),
      ),
    );
  }
}

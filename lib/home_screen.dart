import 'package:flutter/material.dart';
import 'package:my_library/countdown_screen.dart';
import 'package:my_library/profile_screen.dart';
import 'package:my_library/to_read_screen.dart';
import 'library_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  List<Widget> pages = [
    ToReadScreen(),
    LibraryScreen(),
    CountDownTimer(),
    ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.bookmark), label: "Okunacak"),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "Kütüphane"),
          BottomNavigationBarItem(icon: Icon(Icons.timer), label: "Sayaç"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

import 'package:finders_united/feature/home/provider/bottom_nav_bar_provider.dart';
import 'package:finders_united/feature/home/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Widget> pages = [
    const HomeScreen(),
    Container(color: Colors.green),
    Container(color: Colors.pink),
    Container(color: Colors.orange),
  ];

  @override
  Widget build(BuildContext context) {
    final bottomNavProvider = Provider.of<BottomNavBarProvider>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: pages[bottomNavProvider.currentTabIndex],
        bottomNavigationBar: BottomNavigationBar(
          iconSize: 7.w,
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          currentIndex: bottomNavProvider.currentIndex,
          onTap: (index) => bottomNavProvider.updateCurrentIndex(index),
          selectedItemColor: Colors.cyan,
          unselectedItemColor: Colors.grey.shade400,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              backgroundColor: Colors.white,
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              backgroundColor: Colors.white,
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark),
              backgroundColor: Colors.white,
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              backgroundColor: Colors.white,
              label: '',
            )
          ],
        ),
      ),
    );
  }
}

import 'package:finders_united/feature/bookmark/screens/bookmark_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../chat/screens/chat_users_screen.dart';
import '../../profile/screens/profile_screen.dart';
import '../../providers/bottom_nav_bar_provider.dart';
import '../../upload/screens/found_item_upload_screen.dart';
import 'home_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Widget> pages = const [
    HomeScreen(),
    ChatUsersScreen(),
    FoundItemUploadScreen(),
    BookmarkScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final bottomNavProvider =
        Provider.of<BottomNavBarProvider>(context, listen: true);
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
              icon: Icon(
                Icons.upload_rounded,
                size: 48,
              ),
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

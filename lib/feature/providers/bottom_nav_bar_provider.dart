import 'package:flutter/material.dart';

class BottomNavBarProvider extends ChangeNotifier {
  int currentTabIndex = 0;

  int get currentIndex => currentTabIndex;

  void updateCurrentIndex(int index) {
    currentTabIndex = index;
    notifyListeners();
  }
}

import 'package:flutter/material.dart';

class BottomNavProvider extends ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void changeTab(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}

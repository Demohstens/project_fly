import 'package:flutter/material.dart';

class PageProvider extends ChangeNotifier {
  int _currentPageIndex = 0;
  Widget? _customComponent = null;

  int get currentPageIndex => _currentPageIndex;
  Widget? get customComponent => _customComponent;

  void setCurrentPageIndex(int index) {
    _currentPageIndex = index;
    notifyListeners();
  }

  void setCustomComponent(Widget? component) {
    _customComponent = component;
    notifyListeners();
  }
}

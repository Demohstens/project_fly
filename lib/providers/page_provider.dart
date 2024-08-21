import 'package:flutter/material.dart';
import 'package:project_fly/components/home_subpage.dart';

class PageProvider extends ChangeNotifier {
  int _currentPageIndex = 0;
  Widget? currentPage;

  late List<Widget> pages;

  // A backup of the pages to be used when the custom component is deactivated
  List<Widget> pagesStatic = [
    Container(child: const HomeSubPage()),
    Container(
      child: const Text('Search'),
    ),
    Container(
      child: const Text('Library'),
    ),
  ];

  PageProvider() {
    pages = pagesStatic;
  }

  int get currentPageIndex => _currentPageIndex;

  void setToCustomPage(Widget component) {
    currentPage = component;
    notifyListeners();
  }

  void setToOriginalIndex(int index) {
    _currentPageIndex = index;
    currentPage = pages[index];
    notifyListeners();
  }
}

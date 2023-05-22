import 'package:flutter/cupertino.dart';

import '../../home/pages/home_page.dart';
import '../../more/more_page.dart';
import '../../quran stories/pages/quran_stories_page.dart';
import '../../quran/quran_page.dart';

class BottomTabsPageProvider extends ChangeNotifier{
  int _currentPage = 0;
  int get currentPage => _currentPage;

  var page = [
    const HomePage(),
    const QuranPage(),
    // const QaidaPage(),
    const QuranStoriesPage(),
    const MorePage()
  ];


  void setCurrentPage(int page){
    _currentPage = page;
    notifyListeners();
  }
}
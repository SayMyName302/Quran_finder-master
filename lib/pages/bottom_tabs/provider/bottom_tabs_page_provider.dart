import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nour_al_quran/pages/qaida/screens/swipe.dart';
import 'package:nour_al_quran/pages/settings/pages/profile/manage_profile_page.dart';

import '../../home/pages/home_page.dart';
import '../../more/more_page.dart';
import '../../quran/quran_page.dart';

class BottomTabsPageProvider extends ChangeNotifier {
  int _currentPage = 0;
  int get currentPage => _currentPage;

  var page = [
    const HomePage(),
    const QuranPage(),
    const SwipePages(initialPage: 0),
    const MorePage(),
    const ManageProfile(),
  ];
  // void navigateToQaidaPage(BuildContext context) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => const SwipePages(initialPage: 0),
  //     ),
  //   );
  // }

  void setCurrentPage(int page) {
    _currentPage = page;
    notifyListeners();
  }
}

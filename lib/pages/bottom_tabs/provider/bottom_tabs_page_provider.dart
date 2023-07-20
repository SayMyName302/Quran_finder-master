import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:nour_al_quran/pages/qaida/screens/swipe.dart';
import 'package:nour_al_quran/pages/settings/pages/profile/manage_profile_page.dart';

import '../../home/pages/home_page.dart';
import '../../more/more_page.dart';
import '../../quran/quran_page.dart';

class BottomTabsPageProvider extends ChangeNotifier {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  int _currentPage = 0;
  int get currentPage => _currentPage;
  bool _showBottomTab = true;

  bool get showBottomTab => _showBottomTab;

  var page = [
    const HomePage(),
    const QuranPage(),
    const SwipePages(initialPage: 0),
    const MorePage(),
    const ManageProfile(),
  ];

  void setCurrentPage(int page) {
    _currentPage = page;
    String eventName;
    switch (page) {
      case 0:
        eventName = 'home_page';
        break;
      case 1:
        eventName = 'quran_page';
        break;
      case 2:
        eventName = 'qaida_page';
        break;
      case 3:
        eventName = 'discover_page';
        break;
      case 4:
        eventName = 'manage_profile_view';
        break;
      default:
        eventName = 'unknown_page_view';
        break;
    }
    analytics.logEvent(
      name: eventName,
      parameters: {'page_index': page},
    );
    notifyListeners();
  }

  void setBottomTabVisibility(bool isVisible) {
    _showBottomTab = isVisible;
    notifyListeners();
  }
}

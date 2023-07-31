import 'package:flutter/material.dart';
import 'package:nour_al_quran/shared/database/quran_db.dart';
import 'package:provider/provider.dart';

import '../../../../../shared/providers/dua_audio_player_provider.dart';
import '../../../shared/routes/routes_helper.dart';
import '../../quran/pages/ruqyah/pages/ruqyah_categories_page.dart';
import '../screens/dua_bookmarks.dart';
import '../screens/dua_categories_page.dart';
import '../models/dua.dart';
import '../models/dua_category.dart';

class DuaProvider extends ChangeNotifier {
  List<DuaCategory> _duaCategoryList = [];
  List<DuaCategory> get duaCategoryList => _duaCategoryList;

  DuaCategory? _selectedDuaCategory;
  DuaCategory? get selectedDuaCategory => _selectedDuaCategory;

  List<Dua> _duaList = [];
  List<Dua> get duaList => _duaList;
  int _currentDuaIndex = 0;
  int get currentDuaIndex => _currentDuaIndex;

  Dua? _selectedDua;
  Dua? get selectedDua => _selectedDua;

  int _currentPage = 0;
  int get currentPage => _currentPage;

  void setCurrentPage(int page) {
    _currentPage = page;
    notifyListeners();
  }

  var pageNames = [
    "duas",
    "al_ruqyah",
    "favorites"
  ];
  var pages = [
    const DuaCategoriesPage(),
    const RuqyahCategoriesPage(),
    const DuaBookmarkPage(),
  ];




  /// get dua categories list
  Future<void> getDuaCategories() async {
    _duaCategoryList = await QuranDatabase().getDuaCategories();
    notifyListeners();
  }

  /// set Current Selected Category
  setSelectedCategory(int index){
    _selectedDuaCategory = _duaCategoryList[index];
    notifyListeners();
  }

  /// get dua where category id = ?
  Future<void> getDuaBasedOnCategoryId(int duaCategoryId) async {
    _duaList = await QuranDatabase().getDuas(duaCategoryId);
    notifyListeners();
  }

  /// get All dua
  Future<void> getAllDuas() async {
    _duaList = await QuranDatabase().getAllDua();
    notifyListeners();
  }


  gotoDuaPlayerPage(int duaCategoryId, String duaText, BuildContext context) async {
    // _duaList = [];
    // _duaList = await QuranDatabase().getDuas(duaCategoryId);
    if (_duaList.isNotEmpty) {
      _currentDuaIndex = _duaList.indexWhere((element) => element.duaText == duaText);
      if (_currentDuaIndex != -1) {
        _selectedDua = _duaList[_currentDuaIndex];
        notifyListeners();
        // ignore: use_build_context_synchronously
        Provider.of<DuaPlayerProvider>(context, listen: false)
            .initAudioPlayer(_selectedDua!.duaUrl!, context);

        Navigator.of(context).pushNamed(
          RouteHelper.duaDetailed,
        );
      }
    }
  }

  void playNextDuaInCategory(BuildContext context) {
    if(_currentDuaIndex < _duaList.length){
      _currentDuaIndex++;
    }else{
      _currentDuaIndex = 0;
    }
    // _currentDuaIndex = (_currentDuaIndex + 1) % _duaList.length;
    _selectedDua = _duaList[_currentDuaIndex];
    notifyListeners();
    Provider.of<DuaPlayerProvider>(context, listen: false)
        .initAudioPlayer(_selectedDua!.duaUrl!, context);
    // getNextDua();
  }

  // Map<String, dynamic> getNextDua() {
  //   return {
  //     'index': _currentDuaIndex + 1,
  //     'dua': _duaList[_currentDuaIndex],
  //   };
  // }

  void playPreviousDuaInCategory(BuildContext context) {
    if (_currentDuaIndex > 0) {
      _currentDuaIndex--;
    } else {
      _currentDuaIndex = _duaList.length - 1;
    }
    // _currentDuaIndex = (_currentDuaIndex - 1) % _duaList.length;
    _selectedDua = _duaList[_currentDuaIndex];
    notifyListeners();
    Provider.of<DuaPlayerProvider>(context, listen: false)
        .initAudioPlayer(_selectedDua!.duaUrl!, context);
    // getNextDua();
  }

  // void bookmark(int duaId, int value) {
  //   _duaList[duaId].setIsBookmark = value;
  //   notifyListeners();
  // }
}

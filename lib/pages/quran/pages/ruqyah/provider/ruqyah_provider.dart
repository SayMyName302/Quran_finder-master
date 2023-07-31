// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:nour_al_quran/pages/quran/pages/ruqyah/models/ruqyah.dart';
import 'package:nour_al_quran/pages/quran/pages/ruqyah/models/ruqyah_category.dart';
import 'package:nour_al_quran/shared/database/quran_db.dart';
import 'package:provider/provider.dart';
import '../../../../../shared/providers/dua_audio_player_provider.dart';
import '../../../../../shared/routes/routes_helper.dart';

class RuqyahProvider extends ChangeNotifier {
  List<RuqyahCategory> _duaCategoryList = [];
  List<RuqyahCategory> get duaCategoryList => _duaCategoryList;

  RuqyahCategory? _selectedDuaCategory;
  RuqyahCategory? get selectedDuaCategory => _selectedDuaCategory;


  List<Ruqyah> _duaList = [];
  List<Ruqyah> get duaList => _duaList;
  int _currentDuaIndex = 0;
  int get currentDuaIndex => _currentDuaIndex;

  Ruqyah? _selectedDua;
  Ruqyah? get selectedDua => _selectedDua;

  /// set Current Selected Category
  setSelectedCategory(int index){
    _selectedDuaCategory = _duaCategoryList[index];
    notifyListeners();
  }

  Future<void> getRDuaCategories() async {
    _duaCategoryList = await QuranDatabase().getRDuaCategories();
    notifyListeners();
  }

  Future<void> getRDuaBasedOnCategoryId(int duaCategoryId) async {
    _duaList = await QuranDatabase().getRDua(duaCategoryId);
    notifyListeners();
  }

  gotoDuaPlayerPage(int duaCategoryId, String duaText, BuildContext context) async {
    // _duaList = [];
    // _duaList = await QuranDatabase().getRDua(duaCategoryId);
    if (_duaList.isNotEmpty) {
      _currentDuaIndex = _duaList.indexWhere((element) => element.duaText == duaText);
      if (_currentDuaIndex != -1) {
        _selectedDua = _duaList[_currentDuaIndex];
        notifyListeners();
        Provider.of<DuaPlayerProvider>(context, listen: false).initAudioPlayer(_selectedDua!.duaUrl!, context);
        Navigator.of(context).pushNamed(
          RouteHelper.ruqyahDetailed,
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
    Provider.of<DuaPlayerProvider>(context, listen: false).initAudioPlayer(_selectedDua!.duaUrl!, context);
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
    Provider.of<DuaPlayerProvider>(context, listen: false).initAudioPlayer(_selectedDua!.duaUrl!, context);
    // getNextDua();
  }

  // void bookmark(int duaId, int value) {
  //   _duaList[duaId].setIsBookmark = value;
  //   notifyListeners();
  // }
}

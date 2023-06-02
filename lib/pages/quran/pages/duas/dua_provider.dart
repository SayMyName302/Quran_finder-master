import 'package:flutter/material.dart';
import 'package:nour_al_quran/shared/database/quran_db.dart';
import 'package:provider/provider.dart';

import '../../../../shared/providers/dua_audio_player_provider.dart';
import 'models/dua.dart';
import 'models/dua_category.dart';

class DuaProvider extends ChangeNotifier {
  List<DuaCategory> _duaCategoryList = [];
  List<DuaCategory> get duaCategoryList => _duaCategoryList;
  List<Dua> _duaList = [];
  List<Dua> get duaList => _duaList;
  int _currentduaIndex = 0;
  int get currentDuaIndex => _currentduaIndex;

  Dua? _selectedDua;
  Dua? get selectedDua => _selectedDua;

  List<String> _duaData = [];
  List<String> get duaData => _duaData;

  void storeDuaData(List<String> data) {
    _duaData = data;
    notifyListeners();
  }

  //Updates Dua by Index+1 which is at Index 0
  void updateDuaAtIndex(int index, String newData) {
    if (index >= 0 && index < _duaData.length) {
      _duaData[index] = newData;
      notifyListeners();
    }
  }

  Future<void> getDuaCategories() async {
    _duaCategoryList = await QuranDatabase().getDuaCategories();
    notifyListeners();
  }

  Future<void> getDua(int duaCategoryId) async {
    //fetches all the dua in current category list
    _duaList = await QuranDatabase().getDua(duaCategoryId);
    notifyListeners();
  }

  gotoDuaPlayerPage(int duaId, BuildContext context) {
    //Dua list index always starting from 0
    _currentduaIndex = _duaList.indexWhere((element) => element.id == duaId);
    _selectedDua = _duaList[_currentduaIndex];
    Provider.of<DuaPlayerProvider>(context, listen: false)
        .initAudioPlayer(_selectedDua!.duaUrl!, context);
  }

  void playNextDuaInCategory(BuildContext context) {
    _currentduaIndex = (_currentduaIndex + 1) % _duaList.length;
    _selectedDua = _duaList[_currentduaIndex];

    Provider.of<DuaProvider>(context, listen: false)
        .updateDuaAtIndex(0, "Dua ${_currentduaIndex + 1}");

    Provider.of<DuaPlayerProvider>(context, listen: false)
        .initAudioPlayer(_selectedDua!.duaUrl!, context);
    getNextDua();
    notifyListeners();
  }

  // Method to get the next dua
  Map<String, dynamic> getNextDua() {
    int nextIndex = (_currentduaIndex) % _duaList.length;
    Dua nextDua = _duaList[nextIndex];
    return {
      'index': nextIndex,
      'dua': nextDua,
    };
  }

  void playPreviousDuaInCategory(BuildContext context) {
    _currentduaIndex = (_currentduaIndex - 1) % _duaList.length;
    _selectedDua = _duaList[_currentduaIndex];

    Provider.of<DuaProvider>(context, listen: false)
        .updateDuaAtIndex(0, "Dua ${_currentduaIndex + 1}");

    Provider.of<DuaPlayerProvider>(context, listen: false)
        .initAudioPlayer(_selectedDua!.duaUrl!, context);
    getNextDua();
    notifyListeners();
  }
}

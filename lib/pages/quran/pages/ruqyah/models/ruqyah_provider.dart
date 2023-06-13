import 'package:flutter/material.dart';
import 'package:nour_al_quran/pages/quran/pages/ruqyah/models/ruqyah.dart';
import 'package:nour_al_quran/pages/quran/pages/ruqyah/models/ruqyah_category.dart';
import 'package:nour_al_quran/shared/database/quran_db.dart';
import 'package:provider/provider.dart';
import '../../../../../shared/providers/dua_audio_player_provider.dart';

class RuqyahProvider extends ChangeNotifier {
  List<RuqyahCategory> _duaCategoryList = [];
  List<RuqyahCategory> get duaCategoryList => _duaCategoryList;
  List<Ruqyah> _duaList = [];
  List<Ruqyah> get duaList => _duaList;
  int _currentduaIndex = 0;
  int get currentDuaIndex => _currentduaIndex;

  Ruqyah? _selectedDua;
  Ruqyah? get selectedDua => _selectedDua;

  Future<void> getRDuaCategories() async {
    _duaCategoryList = await QuranDatabase().getRDuaCategories();
    notifyListeners();
  }

  Future<void> getRDua(int duaCategoryId) async {
    //fetches all the dua in current category list
    _duaList = await QuranDatabase().getRDua(duaCategoryId);
    notifyListeners();
  }

  gotoDuaPlayerPage(
      int duaCategoryId, String duaText, BuildContext context) async {
    _duaList = [];
    _duaList = await QuranDatabase().getRDua(duaCategoryId);
    if (_duaList.isNotEmpty) {
      _currentduaIndex =
          _duaList.indexWhere((element) => element.duaText == duaText);
      if (_currentduaIndex != -1) {
        _selectedDua = _duaList[_currentduaIndex];
        Provider.of<DuaPlayerProvider>(context, listen: false)
            .initAudioPlayer(_selectedDua!.duaUrl!, context);
        notifyListeners();
      }
    }
  }

  void playNextDuaInCategory(BuildContext context) {
    _currentduaIndex = (_currentduaIndex + 1) % _duaList.length;
    _selectedDua = _duaList[_currentduaIndex];

    Provider.of<DuaPlayerProvider>(context, listen: false)
        .initAudioPlayer(_selectedDua!.duaUrl!, context);
    getNextDua();
    notifyListeners();
  }

  // Method to get the next dua
  Map<String, dynamic> getNextDua() {
    return {
      'index': _currentduaIndex,
      'dua': _duaList[_currentduaIndex],
    };
  }

  void playPreviousDuaInCategory(BuildContext context) {
    _currentduaIndex = (_currentduaIndex - 1) % _duaList.length;
    _selectedDua = _duaList[_currentduaIndex];

    Provider.of<DuaPlayerProvider>(context, listen: false)
        .initAudioPlayer(_selectedDua!.duaUrl!, context);
    getNextDua();
    notifyListeners();
  }

  void bookmark(int duaId, int value) {
    _duaList[duaId].setIsBookmark = value;
    notifyListeners();
  }
}

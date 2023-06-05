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

  gotoDuaPlayerPage(int duaId, BuildContext context) {
    //Dua list index always starting from 0
    _currentduaIndex = _duaList.indexWhere((element) => element.id == duaId);
    _selectedDua = _duaList[_currentduaIndex];
    Provider.of<DuaPlayerProvider>(context, listen: false)
        .initAudioPlayer(_selectedDua!.duaUrl!, context);
    notifyListeners();
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
    int nextIndex = (_currentduaIndex) % _duaList.length;
    Ruqyah nextDua = _duaList[nextIndex];
    return {
      'index': nextIndex + 1,
      'dua': nextDua,
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
}

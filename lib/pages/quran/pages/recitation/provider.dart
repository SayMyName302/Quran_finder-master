import 'package:flutter/material.dart';
import 'package:nour_al_quran/pages/recitation_category/models/RecitationCategory.dart';
import 'package:nour_al_quran/shared/database/quran_db.dart';
import 'package:nour_al_quran/shared/entities/reciters.dart';

class recentProviderRecitation extends ChangeNotifier {
  List<Reciters> _reciterNameList = [];
  List<Reciters> get reciterNameList => _reciterNameList;
  List<Reciters> _tappedRecitersList = [];

  List<Reciters> get tappedRecitersList => _tappedRecitersList;

  List<RecitationCategoryModel> _tappedRecitationList = [];

  List<RecitationCategoryModel> get tappedRecitationList =>
      _tappedRecitationList;
  Future<void> getSurahName() async {
    _reciterNameList = await QuranDatabase().getAllReciter();
    notifyListeners();
  }

  void addReciter(Reciters reciter) {
    _tappedRecitersList.add(reciter);
    notifyListeners();
  }

  void addRecitation(RecitationCategoryModel reciter) {
    _tappedRecitationList.add(reciter);
    notifyListeners();
  }
}

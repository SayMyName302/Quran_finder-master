import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:nour_al_quran/shared/database/quran_db.dart';
import 'package:nour_al_quran/shared/entities/surah.dart';

import '../../../../shared/utills/app_constants.dart';

class SurahProvider extends ChangeNotifier {
  List<Surah> _surahNamesList = [];
  List<Surah> get surahNamesList => _surahNamesList;

  Future<void> getSurahName() async {
    _surahNamesList = await QuranDatabase().getSurahName();
    notifyListeners();
  }

  List<Surah> tappedSurahList = Hive.box(appBoxKey).get(tappedSurahListKey) != null ?
  (jsonDecode(Hive.box(appBoxKey).get(tappedSurahListKey)) as List<dynamic>).map((e) => Surah.fromJson(e)).toList() : [];

  addTappedSurahList(Surah surah){
    if(tappedSurahList.length >= 3){
      tappedSurahList.removeAt(0);
    }
    if(!tappedSurahList.any((element) => element.surahName == surah.surahName)){
      tappedSurahList.add(surah);
      notifyListeners();
    }
    Hive.box(appBoxKey).put(tappedSurahListKey, jsonEncode(tappedSurahList));
  }

  void searchSurah(String query) async {
    var surahName = await QuranDatabase().getSurahName();
    if (query.isEmpty) {
      _surahNamesList = surahName;
    } else {
      final suggestions = surahName.where((surah) {
        final title = surah.surahName!.toLowerCase();
        final input = query.toLowerCase();
        return title.contains(input);
      }).toList();
      _surahNamesList = suggestions;
    }
    notifyListeners();
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nour_al_quran/shared/database/quran_db.dart';
import 'package:nour_al_quran/shared/entities/juz.dart';
import 'package:nour_al_quran/shared/entities/surah.dart';

import '../../../../shared/utills/app_constants.dart';

class JuzProvider extends ChangeNotifier {
  List<Juz> _juzNamesList = [];
  List<Juz> get juzNameList => _juzNamesList;

  Future<void> getJuzNames() async {
    _juzNamesList = await QuranDatabase().getJuzNames();
    notifyListeners();
  }

  List<Juz> tappedSurahList = Hive.box(appBoxKey).get(tappedJuzzListKey) != null
      ? (jsonDecode(Hive.box(appBoxKey).get(tappedJuzzListKey))
              as List<dynamic>)
          .map((e) => Juz.fromJson(e))
          .toList()
          .cast<Juz>()
      : [];

  addTappedSurahList(Juz juzz) {
    if (tappedSurahList.length >= 3) {
      tappedSurahList.removeAt(0);
    }
    if (!tappedSurahList
        .any((element) => element.juzEnglish == juzz.juzEnglish)) {
      tappedSurahList.add(juzz);
      notifyListeners();
    }
    Hive.box(appBoxKey).put(tappedJuzzListKey, jsonEncode(tappedJuzzListKey));
  }

  void searchJuz(String query) async {
    // copy of list
    var juzNames = await QuranDatabase().getJuzNames();
    if (query.isEmpty) {
      // actual list
      _juzNamesList = juzNames;
    } else {
      final suggestions = juzNames.where((juz) {
        final title = juz.juzEnglish!.toLowerCase();
        final input = query.toLowerCase();
        return title.contains(input);
      }).toList();
      _juzNamesList = suggestions;
    }
    notifyListeners();
  }
}

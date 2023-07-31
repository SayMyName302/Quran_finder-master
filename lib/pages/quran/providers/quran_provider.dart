import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:nour_al_quran/shared/database/quran_db.dart';
import 'package:nour_al_quran/shared/entities/quran_text.dart';
import 'package:nour_al_quran/shared/entities/surah.dart';

class QuranProvider extends ChangeNotifier {
  int _currentPage = 0;
  int get currentPage => _currentPage;

  // quran view
  List<QuranText> _quranTextList = [];
  List<QuranText> get quranTextList => _quranTextList;
  // means that is it from surah, juz , last seen to manage the positions
  int? _surahId;
  int? get surahId => _surahId;
  int? _fromWhere;
  int? get fromWhere => _fromWhere;
  String? _title;
  String? get title => _title;
  bool? _isJuz;
  bool? get isJuz => _isJuz;
  int? _juzId;
  int? get juzId => _juzId;
  int? _bookmarkPosition;
  int? get bookmarkPosition => _bookmarkPosition;
  Surah? _nextSurah;
  Surah? get nextSurah => _nextSurah;

  Surah? _previousSurah;
  Surah? get previousSurah => _previousSurah;

  String? _selectedTranslation;
  String? get selectedTranslation => _selectedTranslation;

  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  void updateState(String name) {
    for (int i = 0; i < _quranTextList.length; i++) {
      QuranText quranText = _quranTextList[i];
      String translation = quranText.getTranslation(name);
      quranText.setTranslationText = translation;
      _quranTextList[i] = quranText;
    }
    notifyListeners();
  }

  void setCurrentPage(int page) {
    _currentPage = page;
    String eventName;
    switch (page) {
      case 0:
        eventName = 'recitation';
        break;
      case 1:
        eventName = 'read_quran';
        break;
      case 2:
        eventName = 'bookmarks';
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

  void setJuzText(
      {required int juzId,
      required String title,
      required int fromWhere,
      bool? isJuz = false,
      int? bookmarkPosition = -1}) async {
    _fromWhere = fromWhere;
    _title = title;
    _isJuz = isJuz;
    _juzId = juzId;
    _bookmarkPosition = bookmarkPosition;
    _surahId = -1;
    _quranTextList = await QuranDatabase().getQuranJuzText(juzId: juzId);
    notifyListeners();
  }

  void setSurahText(
      {required int surahId,
      required String title,
      required int fromWhere,
      bool? isJuz = false,
      int? juzId = -1,
      int? bookmarkPosition = -1}) async {
    _fromWhere = fromWhere;
    _title = title;
    _isJuz = isJuz;
    _juzId = juzId;
    _bookmarkPosition = bookmarkPosition;
    _surahId = surahId;
    _quranTextList = await QuranDatabase().getQuranSurahText(surahId: surahId);
    _nextSurah = await getSpecificSurah(surahId + 1);
    if (surahId > 1) {
      Surah? previousSurah = await getSpecificSurah(surahId - 1);
      _previousSurah = previousSurah;
    } else {
      _previousSurah = null; // Set to null for the first surah
    }
    notifyListeners();
  }

  void bookmark(int index, int value) {
    _quranTextList[index].setIsBookmark = value;
    notifyListeners();
  }

  Future<Surah?> getSpecificSurah(int surahId) async {
    return await QuranDatabase().getSpecificSurahName(surahId);
  }

}

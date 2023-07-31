import 'package:flutter/material.dart';
import 'package:nour_al_quran/pages/recitation_category/models/RecitationCategory.dart';
import 'package:nour_al_quran/shared/database/quran_db.dart';
import 'package:nour_al_quran/shared/entities/reciters.dart';

class recentProviderRecitation extends ChangeNotifier {
  List<String> tappedReciters = [];

  void addTappedReciterName(String name) {
    tappedReciters.add(name);
    notifyListeners();
  }
}

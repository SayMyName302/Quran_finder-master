import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:nour_al_quran/shared/database/quran_db.dart';
import 'package:nour_al_quran/shared/entities/reciters.dart';
import 'package:nour_al_quran/shared/entities/surah.dart';
import '../../../../shared/utills/app_constants.dart';

class RecitationProvider extends ChangeNotifier {
  List<Reciters> _recitersList = [];
  List<Reciters> get recitersList => _recitersList;
  List<Surah> _surahNamesList = [];
  List<Surah> get surahNamesList => _surahNamesList;

  List<Reciters> _recitersList2 = [];
  List<Reciters> get recitersList2 => _recitersList2;
  // List<Reciters> _favReciters = [];
  // List<Reciters> get favReciters => _favReciters;
  final List<Reciters> _favRecitersTest =
      Hive.box(appBoxKey).get(favReciterListKey) != null
          ? (jsonDecode(Hive.box(appBoxKey).get(favReciterListKey))
                  as List<dynamic>)
              .map((e) => Reciters.fromJson(e))
              .toList()
          : [];
  List<Reciters> get favRecitersTest => _favRecitersTest;

  void addReciterFavOrRemove(int reciterId) {
    if (!_favRecitersTest.any((element) => element.reciterId == reciterId)) {
      int index =
          _recitersList.indexWhere((element) => element.reciterId == reciterId);
      _favRecitersTest.add(_recitersList[index]);
      Hive.box(appBoxKey).put(favReciterListKey, jsonEncode(_favRecitersTest));
      notifyListeners();
    } else {
      _favRecitersTest.removeWhere((element) => element.reciterId == reciterId);
      Hive.box(appBoxKey).put(favReciterListKey, jsonEncode(_favRecitersTest));
      notifyListeners();
    }
  }

  // Future<void> getFavReciter() async {
  //   _favReciters = await QuranDatabase().getFavReciters();
  //   notifyListeners();
  // }

  Future<void> getSurahName() async {
    _surahNamesList = await QuranDatabase().getSurahName();
    notifyListeners();
  }

  Future<void> getRecommendedReciters() async {
    _recitersList = await QuranDatabase().getRecommendedReciters();
    notifyListeners();
  }

  Future<void> getPopularReciters() async {
    _recitersList2 = await QuranDatabase().getPopularReciters();
    notifyListeners();
    // print(_recitersList2.toString());
  }

  // both method are used to change state only
  // void addFav(int reciterId){
  //   addFavInLocal(reciterId);
  //   int index = _recitersList.indexWhere((element) => element.reciterId == reciterId);
  //   _recitersList[index].setIsFav = 1;
  //   notifyListeners();
  // }
  //
  // void removeFavReciter(int reciterId){
  //   removeFavFromLocal(reciterId);
  //   _favReciters.removeWhere((element) => element.reciterId == reciterId);
  //   notifyListeners();
  //   int index = _recitersList.indexWhere((element) => element.reciterId == reciterId);
  //   _recitersList[index].setIsFav = 0;
  //   notifyListeners();
  // }

  // void addFavInLocal(int reciterId){
  //   List favReciterList = Hive.box("myBox").get("favReciters") ?? <int>[];
  //   favReciterList.add(reciterId);
  //   Hive.box('myBox').put("favReciters", favReciterList);
  //   QuranDatabase().updateReciterIsFav(reciterId,1);
  // }

  // void removeFavFromLocal(int reciterId){
  //   List favReciterList = Hive.box("myBox").get("favReciters") ?? <int>[];
  //   if(favReciterList.isNotEmpty){
  //     favReciterList.removeWhere((element) => element == reciterId);
  //     Hive.box("myBox").put("favReciters", favReciterList);
  //     QuranDatabase().updateReciterIsFav(reciterId,0);
  //   }
  // }
}

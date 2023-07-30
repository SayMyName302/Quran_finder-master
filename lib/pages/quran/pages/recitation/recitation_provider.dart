import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:nour_al_quran/shared/database/quran_db.dart';
import 'package:nour_al_quran/shared/entities/reciters.dart';
import 'package:nour_al_quran/shared/entities/surah.dart';

class RecitationProvider extends ChangeNotifier {
  List<Reciters> _recommendedReciterList = [];
  List<Reciters> get recommendedReciterList => _recommendedReciterList;

  List<Reciters> _popularReciterList = [];
  List<Reciters> get popularReciterList => _popularReciterList;

  List<Reciters> _allRecitersList = [];
  List<Reciters> get allRecitersList => _allRecitersList;

  List<Surah> _surahNamesList = [];
  List<Surah> get surahNamesList => _surahNamesList;

  Future<void> getRecommendedReciters() async {
    _recommendedReciterList = await QuranDatabase().getRecommendedReciters();
    _allRecitersList = await QuranDatabase().getAllReciter();
    notifyListeners();
  }

  Future<void> getPopularReciters() async {
    _popularReciterList = await QuranDatabase().getPopularReciters();
    notifyListeners();
  }

  Future<void> getAllReciters() async {
    _allRecitersList = await QuranDatabase().getAllReciter();
    notifyListeners();
  }

  Future<void> getSurahName() async {
    _surahNamesList = await QuranDatabase().getSurahName();
    notifyListeners();
  }
}

// List<Reciters> _favRecitersTest = Hive.box(appBoxKey).get(favReciterListKey) != null ? (jsonDecode(Hive.box(appBoxKey).get(favReciterListKey))
//                 as List<dynamic>).map((e) => Reciters.fromJson(e)).toList() : [];
// List<Reciters> get favRecitersTest => _favRecitersTest;

// void addReciterFavOrRemove(int reciterId) {
//   if (!_favRecitersTest.any((element) => element.reciterId == reciterId)) {
//     int index = _allRecitersList.indexWhere((element) => element.reciterId == reciterId);
//     _favRecitersTest.add(_allRecitersList[index]);
//     Hive.box(appBoxKey).put(favReciterListKey, jsonEncode(_favRecitersTest));
//     notifyListeners();
//   } else {
//     _favRecitersTest.removeWhere((element) => element.reciterId == reciterId);
//     Hive.box(appBoxKey).put(favReciterListKey, jsonEncode(_favRecitersTest));
//     notifyListeners();
//   }
// }

// setRecitationList(List<Reciters> favReciterList){
//   _favRecitersTest = favReciterList;
//   notifyListeners();
// }




// Future<void> getFavReciter() async {
//   _favReciters = await QuranDatabase().getFavReciters();
//   notifyListeners();
// }

// List<Reciters> _favReciters = [];
// List<Reciters> get favReciters => _favReciters;
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
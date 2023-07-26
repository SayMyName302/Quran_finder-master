import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

import 'package:nour_al_quran/pages/tranquil_tales/models/TranquilCategory.dart';
import 'package:nour_al_quran/pages/tranquil_tales/models/TranquilModel.dart';
import 'package:provider/provider.dart';

import '../../../shared/database/home_db.dart';

import '../../../shared/providers/story_n_basics_audio_player_provider.dart';
import '../pages/bookmarks_recitation.dart';

class TranquilCategoryProvider extends ChangeNotifier {
  List<TranquilTalesCategoryModel> _recitationCategory = [];
  List<TranquilTalesCategoryModel> get recitationCategory =>
      _recitationCategory;

  List<TranquilTalesModel> _recitationAll = [];
  List<TranquilTalesModel> get recitationAll => _recitationAll;

  List<TranquilTalesModel> _selectedRecitationAll = [];
  List<TranquilTalesModel> get selectedRecitationAll => _selectedRecitationAll;

  int _currentRecitationIndex = 0;
  int get currentRecitationIndex => _currentRecitationIndex;

  TranquilTalesModel? _selectedRecitationStory;
  TranquilTalesModel? get selectedRecitationStory => _selectedRecitationStory;

  final List _bookmarkList = [];
  // final List _bookmarkList = Hive.box('myBox').get('bookmarksrecite') ?? [];
  List get bookmarkList => _bookmarkList;

  final List<BookmarksRecitation> _bookmarkListTest =
      Hive.box('myBox').get('bookmarksrecite') != null
          ? (jsonDecode(Hive.box('myBox').get('bookmarksrecite'))
                  as List<dynamic>)
              .map((e) => BookmarksRecitation.fromJson(e))
              .toList()
          : [];
  List get bookmarkListTest => _bookmarkListTest;

  void addOrRemoveBookmark(BookmarksRecitation bookmarks) {
    if (!_bookmarkListTest.any(
        (element) => element.recitationIndex == bookmarks.recitationIndex)) {
      // print('adding');
      _bookmarkListTest.add(bookmarks);
      Hive.box("myBox").put("bookmarksrecite", jsonEncode(_bookmarkListTest));
    } else {
      // print('removing');
      _bookmarkListTest.removeWhere(
          (element) => element.recitationIndex == bookmarks.recitationIndex);
      Hive.box("myBox").put("bookmarksrecite", jsonEncode(_bookmarkListTest));
    }
    notifyListeners();
  }

  Future<void> getRecitationCategoryStories() async {
    _recitationCategory = await HomeDb().getTranquilCategory();
    notifyListeners();
  }

  Future<void> getRecitationAllCategoryStories() async {
    _recitationAll = await HomeDb().getTranquilAll();
    notifyListeners();
  }

  Future<void> getSelectedRecitationAll(int categoryId) async {
    _selectedRecitationAll = await HomeDb().getSelectedAllTranquil(categoryId);
    notifyListeners();
  }

  Map<String, dynamic> getNextDuaRecitation() {
    return {
      'index': _currentRecitationIndex + 1,
      'dua': _selectedRecitationAll[_currentRecitationIndex],
    };
  }

  gotoRecitationAudioPlayerPage(
      int duaCategoryId, int surahId, imageUrl, BuildContext context) async {
    _selectedRecitationAll = [];
    _selectedRecitationAll =
        await HomeDb().getSelectedAllTranquil(duaCategoryId);
    if (_selectedRecitationAll.isNotEmpty) {
      _currentRecitationIndex = _selectedRecitationAll
          .indexWhere((element) => element.surahId == surahId);
      _selectedRecitationStory =
          _selectedRecitationAll[_currentRecitationIndex];
      // ignore: use_build_context_synchronously
      Provider.of<StoryAndBasicPlayerProvider>(context, listen: false)
          .initAudioPlayer(
              _selectedRecitationStory!.contentType!, imageUrl!, context);
      notifyListeners();
    }
  }

  // void removeBookmark(int duaId, int categoryId) {
  //   QuranDatabase().removeRecitatioBookmark(duaId, categoryId);
  //   _bookmarkList.removeWhere((element) =>
  //       element.recitationIndex == duaId && element.catID == categoryId);
  //   notifyListeners();
  //   Hive.box("myBox").put("bookmarksrecite", _bookmarkList);
  // }

  // void addBookmark(BookmarksRecitation bookmarks) {
  //   QuranDatabase().addRecitationBookmark(bookmarks.recitationIndex!);
  //   if (!_bookmarkList.contains(bookmarks)) {
  //     _bookmarkList.add(bookmarks);
  //   }
  //   notifyListeners();
  //   Hive.box("myBox").put("bookmarksrecite", _bookmarkList);
  // }

  // void bookmark(int duaId, int value) {
  //   _selectedRecitationAll[duaId].setIsBookmark = value;
  //   notifyListeners();
  // }
}

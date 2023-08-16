import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:nour_al_quran/pages/recitation_category/models/RecitationCategory.dart';
import 'package:nour_al_quran/pages/recitation_category/models/recitation_all_category_model.dart';
import 'package:provider/provider.dart';

import '../../../shared/database/home_db.dart';
import '../../../shared/providers/story_n_basics_audio_player_provider.dart';

class RecitationCategoryProvider extends ChangeNotifier {
  void printCurrentTimeCategory() {
    // Get the current time
    DateTime currentTime = DateTime.now();
    int currentHour = currentTime.hour;

    if (currentHour >= 6 && currentHour < 12) {
      print("It's currently Morning.");
    } else if (currentHour >= 12 && currentHour < 18) {
      print("It's currently Afternoon.");
    } else if (currentHour >= 18 && currentHour < 24) {
      print("It's currently Evening.");
    } else {
      print("It's currently Night time.");
    }
  }

  Timer? _timer;

  void startUpdatingPeriodically() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(minutes: 5), (_) {
      // Adjust the duration as needed; here, we update every 5 minutes
      getRecitationCategoryStories();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  List<RecitationCategoryModel> _recitationCategoryList = [];
  List<RecitationCategoryModel> get recitationCategoryList =>
      _recitationCategoryList;

  RecitationCategoryModel? _selectedRecitationCategory;
  RecitationCategoryModel? get selectedRecitationCategory =>
      _selectedRecitationCategory;

  List<RecitationAllCategoryModel> _recitationAllList = [];
  List<RecitationAllCategoryModel> get recitationAllList => _recitationAllList;

  List<RecitationAllCategoryModel> _selectedRecitationAll = [];
  List<RecitationAllCategoryModel> get selectedRecitationAll =>
      _selectedRecitationAll;

  int _currentRecitationIndex = 0;
  int get currentRecitationIndex => _currentRecitationIndex;

  RecitationAllCategoryModel? _selectedRecitationModel;
  RecitationAllCategoryModel? get selectedRecitationModel =>
      _selectedRecitationModel;

  setSelectedRecitationCategory(RecitationCategoryModel value) {
    _selectedRecitationCategory = value;
    print(_selectedRecitationCategory);
    notifyListeners();
  }

  Future<void> getRecitationCategoryStories() async {
    _recitationCategoryList = await HomeDb().getRecitationBasedOnTime();
    printCurrentTimeCategory();
    notifyListeners();
  }

  Future<void> getRecitationAllCategoryStories() async {
    _recitationAllList = await HomeDb().getRecitationAll();
    notifyListeners();
  }

  Future<void> getSelectedRecitationAll(int playlistId) async {
    _selectedRecitationAll = await HomeDb().getSelectedAll(playlistId);
    notifyListeners();
  }

  Map<String, dynamic> getNextDuaRecitation() {
    return {
      'index': _currentRecitationIndex + 1,
      'dua': _selectedRecitationAll[_currentRecitationIndex],
    };
  }

  gotoRecitationAudioPlayerPage(
      RecitationAllCategoryModel recitationAllCategoryModel,
      String imageUrl,
      BuildContext context) async {
    String imageU = imageUrl;
    _selectedRecitationAll.clear();
    _selectedRecitationAll =
        await HomeDb().getSelectedAll(recitationAllCategoryModel.playlistId!);
    if (_selectedRecitationAll.isNotEmpty) {
      _currentRecitationIndex = _selectedRecitationAll.indexWhere((element) =>
          element.title == recitationAllCategoryModel.title &&
          element.surahName == recitationAllCategoryModel.surahName);
      _selectedRecitationModel =
          _selectedRecitationAll[_currentRecitationIndex];
      notifyListeners();
      int index = _recitationCategoryList.indexWhere((element) =>
          element.playlistId == recitationAllCategoryModel.playlistId!);
      if (index != -1) {
        imageU = _recitationCategoryList[index].imageURl!;
      }
      // ignore: use_build_context_synchronously
      Provider.of<StoryAndBasicPlayerProvider>(context, listen: false)
          .initAudioPlayer(
              _selectedRecitationModel!.contentUrl!, imageU, context);
    }
  }
}


/// book logic done previously
// final List _bookmarkList = [];
// final List _bookmarkList = Hive.box('myBox').get('bookmarksrecite') ?? [];
// List get bookmarkList => _bookmarkList;

// final List<BookmarksRecitation> _bookmarkListTest =
//     Hive.box('myBox').get('bookmarksrecite') != null
//         ? (jsonDecode(Hive.box('myBox').get('bookmarksrecite'))
//                 as List<dynamic>)
//             .map((e) => BookmarksRecitation.fromJson(e))
//             .toList()
//         : [];
// List get bookmarkListTest => _bookmarkListTest;

// void addOrRemoveBookmark(BookmarksRecitation bookmarks) {
//   if (!_bookmarkListTest.any(
//       (element) => element.contentUrl == bookmarks.contentUrl)) {
//     // print('adding');
//     _bookmarkListTest.add(bookmarks);
//     Hive.box("myBox").put("bookmarksrecite", jsonEncode(_bookmarkListTest));
//   } else {
//     // print('removing');
//     _bookmarkListTest.removeWhere(
//         (element) => element.recitationIndex == bookmarks.recitationIndex);
//     Hive.box("myBox").put("bookmarksrecite", jsonEncode(_bookmarkListTest));
//   }
//   notifyListeners();
// }

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
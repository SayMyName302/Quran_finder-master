import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:nour_al_quran/pages/recitation_category/models/RecitationCategory.dart';
import 'package:nour_al_quran/pages/recitation_category/models/recitation_all_category_model.dart';
import 'package:provider/provider.dart';

import '../../../shared/database/home_db.dart';
import '../../../shared/database/quran_db.dart';
import '../../../shared/providers/story_n_basics_audio_player_provider.dart';
import '../pages/bookmarks_recitation.dart';

class RecitationCategoryProvider extends ChangeNotifier {
  List<RecitationCategoryModel> _recitationCategory = [];
  List<RecitationCategoryModel> get recitationCategory => _recitationCategory;

  List<RecitationAllCategoryModel> _recitationAll = [];
  List<RecitationAllCategoryModel> get recitationAll => _recitationAll;

  List<RecitationAllCategoryModel> _selectedRecitationAll = [];
  List<RecitationAllCategoryModel> get selectedRecitationAll =>
      _selectedRecitationAll;

  int _currentRecitationIndex = 0;
  int get currentRecitationIndex => _currentRecitationIndex;

  RecitationAllCategoryModel? _selectedRecitationStory;
  RecitationAllCategoryModel? get selectedRecitationStory =>
      _selectedRecitationStory;

  final List _bookmarkList = Hive.box('myBox').get('bookmarksrecite') ?? [];
  List get bookmarkList => _bookmarkList;

  Future<void> getRecitationCategoryStories() async {
    _recitationCategory = await HomeDb().getRecitationCategory();
    notifyListeners();
  }

  Future<void> getRecitationAllCategoryStories() async {
    _recitationAll = await HomeDb().getRecitationAll();
    notifyListeners();
  }

  Future<void> getSelectedRecitationAll(int categoryId) async {
    _selectedRecitationAll = await HomeDb().getSelectedAll(categoryId);
    notifyListeners();
  }

  // gotoRecitationPlayerPage(
  //     int duaCategoryId,imageUrl, String duaText, BuildContext context) async {
  //   _selectedRecitationAll = [];
  //   _selectedRecitationAll = await HomeDb().getSelectedAll(duaCategoryId);
  //   if (_selectedRecitationAll.isNotEmpty) {
  //     _currentRecitationIndex = _selectedRecitationAll
  //         .indexWhere((element) => element.title == duaText);
  //     if (currentRecitationIndex != -1) {
  //       _selectedRecitationStory =
  //           _selectedRecitationAll[_currentRecitationIndex];
  //       // ignore: use_build_context_synchronously
  //       Provider.of<StoryAndBasicPlayerProvider>(context, listen: false)
  //           .initAudioPlayer(_selectedRecitationStory!.contentUrl!,imageUrl, context);
  //       notifyListeners();
  //     }
  //   }
  // }

  Map<String, dynamic> getNextDuaRecitation() {
    return {
      'index': _currentRecitationIndex + 1,
      'dua': _selectedRecitationAll[_currentRecitationIndex],
    };
  }

  gotoRecitationAudioPlayerPage(
      int duaCategoryId,int surahNo, imageUrl,BuildContext context) async{
  _selectedRecitationAll = [];
    _selectedRecitationAll = await HomeDb().getSelectedAll(duaCategoryId);
    _currentRecitationIndex = _selectedRecitationAll
        .indexWhere((element) => element.surahNo == surahNo);
    _selectedRecitationStory = _selectedRecitationAll[_currentRecitationIndex];
    Provider.of<StoryAndBasicPlayerProvider>(context, listen: false)
        .initAudioPlayer(
            _selectedRecitationStory!.contentUrl!, imageUrl!, context);
    notifyListeners();
  }

  void removeBookmark(int duaId, int categoryId) {
    QuranDatabase().removeRecitatioBookmark(duaId, categoryId);
    _bookmarkList.removeWhere((element) =>
        element.recitationIndex == duaId && element.catID == categoryId);
    notifyListeners();
    Hive.box("myBox").put("bookmarksrecite", _bookmarkList);
  }

  void addBookmark(BookmarksRecitation bookmarks) {
    QuranDatabase().addRecitationBookmark(bookmarks.recitationIndex!);
    if (!_bookmarkList.contains(bookmarks)) {
      _bookmarkList.add(bookmarks);
    }
    notifyListeners();
    Hive.box("myBox").put("bookmarksrecite", _bookmarkList);
  }

  void bookmark(int duaId, int value) {
    _selectedRecitationStory!.setIsBookmark = value;
    notifyListeners();
  }
}

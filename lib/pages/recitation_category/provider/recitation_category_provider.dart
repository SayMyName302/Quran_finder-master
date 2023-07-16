import 'package:flutter/cupertino.dart';
import 'package:nour_al_quran/pages/recitation_category/models/RecitationCategory.dart';
import 'package:nour_al_quran/pages/recitation_category/models/recitation_all_category_model.dart';
import 'package:provider/provider.dart';

import '../../../shared/database/home_db.dart';
import '../../../shared/providers/dua_audio_player_provider.dart';
import '../../../shared/providers/story_n_basics_audio_player_provider.dart';
import '../../../shared/routes/routes_helper.dart';

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

  Future<void> getRecitationCategoryStories() async {
    _recitationCategory = await HomeDb().getRecitationCategory();
    notifyListeners();
  }

  Future<void> getRecitationAllCategoryStories() async {
    _recitationAll = await HomeDb().getRecitationAll();
    notifyListeners();
  }

  Future<void> getSelectedRecitationAll(int categoryId) async {
    //fetches all the dua in current category list
    _selectedRecitationAll = await HomeDb().getSelectedAll(categoryId);
    notifyListeners();
  }

  gotoRecitationPlayerPage(
      int duaCategoryId, String duaText, BuildContext context) async {
    _selectedRecitationAll = [];
    _selectedRecitationAll = await HomeDb().getSelectedAll(duaCategoryId);
    if (_selectedRecitationAll.isNotEmpty) {
      _currentRecitationIndex = _selectedRecitationAll
          .indexWhere((element) => element.title == duaText);
      if (currentRecitationIndex != -1) {
        _selectedRecitationStory =
            _selectedRecitationAll[_currentRecitationIndex];
        // ignore: use_build_context_synchronously
        Provider.of<DuaPlayerProvider>(context, listen: false)
            .initAudioPlayer(_selectedRecitationStory!.contentUrl!, context);
        print("content check by url");
        print(_selectedRecitationStory!.contentUrl!);
        notifyListeners();
      }
    }
  }

  Map<String, dynamic> getNextDuaRecitation() {
    return {
      'index': _currentRecitationIndex + 1,
      'dua': _selectedRecitationAll[_currentRecitationIndex],
    };
  }

  gotoRecitationAudioPlayerPage(
      int surahNo, imageUrl, BuildContext context, int index) {
    _currentRecitationIndex = _selectedRecitationAll
        .indexWhere((element) => element.surahNo == surahNo);
    _selectedRecitationStory = _selectedRecitationAll[_currentRecitationIndex];
    print("content url check by farhan");
    print(_selectedRecitationStory!.contentUrl);
    print('inside provider${_selectedRecitationStory!.title}');
    print(imageUrl);
    print(index);
    Provider.of<StoryAndBasicPlayerProvider>(context, listen: false)
        .initAudioPlayer(
            _selectedRecitationStory!.contentUrl!, imageUrl!, context);
    Navigator.of(context).pushNamed(RouteHelper.recitationAudioPlayer,
        arguments: 'fromRecitation');
  }
}

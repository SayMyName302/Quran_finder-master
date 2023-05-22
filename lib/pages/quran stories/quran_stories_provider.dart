import 'package:flutter/material.dart';
import 'package:nour_al_quran/shared/providers/story_n_basics_audio_player_provider.dart';
import 'package:nour_al_quran/shared/database/home_db.dart';
import 'package:nour_al_quran/shared/routes/routes_helper.dart';
import 'package:provider/provider.dart';
import 'models/quran_stories.dart';


class QuranStoriesProvider extends ChangeNotifier{
  List<QuranStories> _stories = [];
  List<QuranStories> get stories => _stories;
  int _currentStoryIndex = 0;
  int get currentStoryIndex => _currentStoryIndex;
  QuranStories? _selectedQuranStory;
  QuranStories? get selectedQuranStory => _selectedQuranStory;


  Future<void> getStories() async {
     _stories = await HomeDb().getQuranStories();
     notifyListeners();
  }

   goToStoryContentPage(int index,BuildContext context){
     _currentStoryIndex = index;
     _selectedQuranStory = _stories[index];
     notifyListeners();
     Navigator.of(context).pushNamed(RouteHelper.storyDetails);
   }


   gotoStoryPlayerPage(int storyId,BuildContext context){
     _currentStoryIndex = _stories.indexWhere((element) => element.storyId == storyId);
     _selectedQuranStory = _stories[_currentStoryIndex];
     Provider.of<StoryAndBasicPlayerProvider>(context,listen: false).initAudioPlayer(_selectedQuranStory!.audioUrl!, "assets/images/quran_stories/${selectedQuranStory!.image}",context);
     Navigator.of(context).pushNamed(RouteHelper.storyPlayer,arguments: 'fromStory');
   }
}








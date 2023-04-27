import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nour_al_quran/pages/home/home_page.dart';
import 'package:nour_al_quran/pages/home/sections/player/story_player_provider.dart';
import 'package:nour_al_quran/shared/database/home_db.dart';
import 'package:nour_al_quran/shared/routes/routes_helper.dart';
import 'package:nour_al_quran/shared/widgets/easy_loading.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'quran_stories.dart';


class QuranStoriesProvider extends ChangeNotifier{
  List<QuranStories> _stories = [];
  List<QuranStories> get stories => _stories;
  int _currentStoryIndex = 0;
  int get currentStoryIndex => _currentStoryIndex;
  QuranStories? _selectedQuranStory;
  QuranStories? get selectedQuranStory => _selectedQuranStory;
  bool _isDownloading = false;
  bool get isDownloading => _isDownloading;
  double _downloaded = 0;
  double get downloaded => _downloaded;

  Future<void> getStories() async {
     _stories = await HomeDb().getQuranStories();
     notifyListeners();
   }


   gotoNextOrPreviousStory(String where){
     if(where == "n"){
       _currentStoryIndex++;
       if(_currentStoryIndex != _stories.length){
         _selectedQuranStory = _stories[_currentStoryIndex];
         notifyListeners();
       }
     }else{
       if(_currentStoryIndex > 0){
         _currentStoryIndex--;
         _selectedQuranStory = _stories[_currentStoryIndex];
         notifyListeners();
       }else{
         _currentStoryIndex = 0;
         notifyListeners();
       }
     }
     print(_currentStoryIndex);
   }

   checkIndex(int index){
     if(index > 0){
       return index;
     }else{
       return 0;
     }
   }

   goToStoryDetailsPage(int index,BuildContext context){
     _currentStoryIndex = index;
     _selectedQuranStory = _stories[index];
     notifyListeners();
     Navigator.of(context).pushNamed(RouteHelper.storyDetails);
   }

   Future<void> downloadStoryAudio(BuildContext context) async {
     try{
       showProgressLoading(_downloaded, context,true);
       _isDownloading = true;
       notifyListeners();
       CancelToken cancelToken = CancelToken();
       Dio dio = Dio();
       var response = await dio.get(
         _selectedQuranStory!.audioUrl!,
         onReceiveProgress: (receive,total){
           _downloaded = (receive/total)*100;
           notifyListeners();
         },
         options: Options(responseType: ResponseType.bytes),
         cancelToken: cancelToken
       );
       if(response.statusCode == 200){
         _downloaded = 0;
         var file = <int>[];
         file.addAll(response.data);
         var directory  = await getApplicationDocumentsDirectory();
         var storiesAudioFolder = "${directory.path}/quranStoriesAudios";
         if(!Directory(storiesAudioFolder).existsSync()){
           Directory(storiesAudioFolder).createSync();
         }
         String filePath = "$storiesAudioFolder/${_selectedQuranStory!.storyId!}.mp3";
         File(filePath).writeAsBytes(file).then((value) {
           EasyLoadingDialog.dismiss(context);
           _isDownloading = false;
           notifyListeners();
           Future.delayed(Duration.zero,()=> gotoPlayerPage(context,value.path));
         });
       }
     }on DioError {
       EasyLoadingDialog.dismiss(context);
       _isDownloading = false;
       notifyListeners();
     }catch(e){
       EasyLoadingDialog.dismiss(context);
       _isDownloading = false;
       notifyListeners();
     }
   }

   Future<void> checkAudioExist(int storyId,BuildContext context) async {
    _currentStoryIndex = _stories.indexWhere((element) => element.storyId == storyId);
    _selectedQuranStory = _stories[_currentStoryIndex];
     var directory  = await getApplicationDocumentsDirectory();
     var storiesAudioFolder = "${directory.path}/quranStoriesAudios";
     if(!Directory(storiesAudioFolder).existsSync()){
       Directory(storiesAudioFolder).createSync();
     }
     var audioPath = File("$storiesAudioFolder/$storyId.mp3");
     if(audioPath.existsSync()){
       Future.delayed(Duration.zero,()=> gotoPlayerPage(context,audioPath.path));
     }else{
       Future.delayed(Duration.zero,()=>downloadStoryAudio(context));
     }
   }

   void gotoPlayerPage(BuildContext context,String audioFile){
     Provider.of<StoryPlayerProvider>(context,listen: false).initAudioPlayer(audioFile, "assets/images/quran_stories/${selectedQuranStory!.image}");
     Navigator.of(context).pushNamed(RouteHelper.storyPlayer,arguments: 'fromStory');
   }
}

// String? _title;
// String? get title => _title;
// Chapters? _selectedChapter;
// Chapters? get selectedChapter => _selectedChapter;
// List<Chapters> _chapters = [];
// List<Chapters> get chapters => _chapters;

// Future<void> getChapter(int id) async {
//   _chapters = await HomeDb().getChapters(id);
//   notifyListeners();
// }
//
// void goToChaptersListPage(int id,BuildContext context,String title){
//   getChapter(id);
//   _title = title;
//   notifyListeners();
//   Navigator.of(context).pushNamed(RouteHelper.chapterList);
// }
//
// void goToChapterDetailsPage(int index,BuildContext context){
//   _selectedChapter = _chapters[index];
//   notifyListeners();
//   Navigator.of(context).pushNamed(RouteHelper.storyDetails);
// }

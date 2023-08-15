import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nour_al_quran/pages/popular_section/models/popular_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nour_al_quran/shared/database/home_db.dart';
import 'package:nour_al_quran/shared/providers/story_n_basics_audio_player_provider.dart';
import 'package:nour_al_quran/shared/routes/routes_helper.dart';
import 'package:video_player/video_player.dart';

class PopularProvider extends ChangeNotifier {
  List<PopularRecitationModel> _feature = [];
  List<PopularRecitationModel> get feature => _feature;
  int _currentFeatureIndex = 0;
  int get currentFeatureIndex => _currentFeatureIndex;
  PopularRecitationModel? _selectedFeatureStory;
  File? _videoUrl;
  File? get videoUrl => _videoUrl;
  PopularRecitationModel? get selectedFeatureStory => _selectedFeatureStory;
  SharedPreferences? _preferences;
  Future<void> getStories() async {
    _feature = await HomeDb().getPopular();
    print('FEATUER >>>>>>$_feature');
    // _loadStoriesOrder();
    notifyListeners();
  }

  PopularProvider() {
    _initSharedPreferences();
  }

  Future<void> _initSharedPreferences() async {
    _preferences = await SharedPreferences.getInstance();
  }

  void goToVideoDetailsPage(String title, BuildContext context, int index) {
    _selectedFeatureStory = _feature[index];
    notifyListeners();
    Navigator.of(context).pushNamed(RouteHelper.miraclesDetails);
    // _moveStoryToEnd(index);
  }

  goToFeatureContentPage(int index, BuildContext context) {
    _currentFeatureIndex = index;
    _selectedFeatureStory = _feature[index];
    notifyListeners();

    _moveStoryToEnd(index);

    Navigator.of(context).pushNamed(RouteHelper.featureDetails);
    // _moveStoryToEnd(index);
  }

  gotoFeaturePlayerPage(String storyId, BuildContext context, int index) {
    _currentFeatureIndex =
        _feature.indexWhere((element) => element.surahId == storyId);
    _selectedFeatureStory = _feature[_currentFeatureIndex];
    Provider.of<StoryAndBasicPlayerProvider>(context, listen: false)
        .initAudioPlayer(
            // _selectedFeatureStory!.audioUrl!,
            _selectedFeatureStory!.contentUrl!,
            // "assets/images/popular_recitations/${selectedFeatureStory!.image}",
            "assets/images/popular_recitations/${selectedFeatureStory!.image}",
            context);
    _moveStoryToEnd(index);
    Navigator.of(context)
        .pushNamed(RouteHelper.storyPlayer, arguments: 'fromPopular');
  }

  void _moveStoryToEnd(int index) {
    _selectedFeatureStory =
        _feature[index]; // Set the selected story to the one being moved
    notifyListeners();

    Future.delayed(const Duration(milliseconds: 300), () {
      _feature.removeAt(index);
      _feature.add(_selectedFeatureStory!);
      notifyListeners();
      _saveStoriesOrder();

      // Find the new index of the selected story after it has been moved
      _currentFeatureIndex = _feature.indexOf(_selectedFeatureStory!);
      notifyListeners();
    });
  }

  void _saveStoriesOrder() async {
    final List<String> order =
        _feature.map((stories) => stories.title!).toList();
    _preferences?.setStringList('popular_order', order);
  }

  // void _loadStoriesOrder() async {
  //   final List<String>? order = _preferences?.getStringList('feature_order');

  //   if (order != null && order.isNotEmpty) {
  //     // Add a check for non-empty order
  //     final List<FeaturedModel> sortedStories = [];
  //     for (final storyTitle in order) {
  //       final story = _feature.firstWhere(
  //         (m) => m.storyTitle == storyTitle,
  //       );
  //       if (story != null) {
  //         sortedStories.add(story);
  //       }
  //     }
  //     _feature = sortedStories;
  //     notifyListeners();
  //   }
  // }

  void setVideoFile(File video) {
    _videoUrl = video;
    notifyListeners();
  }

  /// video player logic
  late VideoPlayerController controller;
  bool isNetworkError = false;
  Duration lastPosition = Duration.zero;
  bool isBuffering = false;

  void initVideoPlayer() async {
    try {
      controller = VideoPlayerController.networkUrl(
        Uri.parse(_selectedFeatureStory!.contentUrl!),
      )
        ..initialize().then((_) {
          setNetworkError(false);

          /// if user internet connection lost during video
          /// so after connection resolve so user can seek to the same point of video
          if (lastPosition != Duration.zero) {
            controller.seekTo(lastPosition);
          }
          notifyListeners();
        })
        ..addListener(() async {
          /// if there will be any error so this block will trigger error and resolve error during video
          if (controller.value.hasError) {
            controller.pause();
            setNetworkError(true);
            lastPosition = (await controller.position)!;
            notifyListeners();
          }
        });
    } on PlatformException catch (e) {
      setNetworkError(true);
      Fluttertoast.showToast(msg: e.toString());
    } catch (e) {
      setNetworkError(true);
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  setNetworkError(value) {
    isNetworkError = value;
    notifyListeners();
  }

  /// this method will play if video is pause if pause so it will play
  /// based on condition
  playVideo() {
    controller.value.isPlaying ? controller.pause() : controller.play();
    notifyListeners();
  }
}

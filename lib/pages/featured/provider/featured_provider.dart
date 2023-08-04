// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nour_al_quran/pages/featured/models/featured.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:nour_al_quran/shared/database/home_db.dart';
import 'package:nour_al_quran/shared/providers/story_n_basics_audio_player_provider.dart';
import 'package:nour_al_quran/shared/routes/routes_helper.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';

class FeatureProvider extends ChangeNotifier {
  List<FeaturedModel> _feature = [];
  List<FeaturedModel> get feature => _feature;
  int _currentFeatureIndex = 0;
  int get currentFeatureIndex => _currentFeatureIndex;
  FeaturedModel? _selectedFeatureStory;
  File? _videoUrl;
  File? get videoUrl => _videoUrl;
  FeaturedModel? get selectedFeatureStory => _selectedFeatureStory;
  SharedPreferences? _preferences;
  //For reordeing ListView for FRIDAY
  // List<Map<String, dynamic>> _reorderedStories = [];
  // List<Map<String, dynamic>> get reorderedStories => _reorderedStories;

  String _dayName = '';

  String get dayName => _dayName;

  setDayName(String value) {
    _dayName = value;
    // reorderStories();
    notifyListeners();
  }

  void reorderStoriesIfNeeded(String dayName) {
    setDayName(dayName);
    reorderStories(dayName);
    notifyListeners();
  }

  // Schedule the method to be called every Friday
  void scheduleReorder() {
    DateTime now = DateTime.now();

    if (now.weekday == DateTime.friday) {
      reorderStories('friday'); // if today is friday call reorder method
    } else {
      const oneWeek = Duration(days: 7);
      DateTime nextFriday;
      if (now.weekday <= DateTime.friday) {
        // If today is a day before Friday
        nextFriday = now.add(Duration(days: DateTime.friday - now.weekday));
      } else {
        // If today is Saturday to Thursday
        nextFriday =
            now.add(oneWeek - Duration(days: now.weekday - DateTime.friday));
      }
      Duration timeUntilNextFriday = nextFriday.difference(now);
      // Schedule the method using Timer.periodic
      Timer.periodic(timeUntilNextFriday, (Timer timer) {
        if (timer.isActive) {
          reorderStories('friday'); // Calling reorderStories method
        }
      });
    }
  }

  void reorderStories(String dayName) {
    if (dayName == 'friday') {
      // Find the indices of rows with the 'friday' day
      List<int> fridayIndices = [];
      for (int i = 0; i < _feature.length; i++) {
        if (_feature[i].day == 'friday') {
          fridayIndices.add(i);
        }
      }

      if (fridayIndices.isNotEmpty && _feature.length > 1) {
        Random random = Random();
        int randomIndex = random.nextInt(fridayIndices.length);
        int selectedFridayIndex = fridayIndices[randomIndex];
        // print('>>>>>>>>${fridayIndices}');

        FeaturedModel firstItem = _feature[0];
        FeaturedModel selectedFridayItem = _feature[selectedFridayIndex];
        _feature[0] = selectedFridayItem;
        _feature[selectedFridayIndex] = firstItem;
        notifyListeners();
      }
    }
  }

//dsassssssssssssssssssssssssss
  Future<void> getStories() async {
    _feature = await HomeDb().getFeatured();
    scheduleReorder();
    // _loadStoriesOrder();
    notifyListeners();
  }

  FeatureProvider() {
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

  gotoFeaturePlayerPage(int storyId, BuildContext context, int index) {
    _currentFeatureIndex =
        _feature.indexWhere((element) => element.storyId == storyId);
    _selectedFeatureStory = _feature[_currentFeatureIndex];
    Provider.of<StoryAndBasicPlayerProvider>(context, listen: false)
        .initAudioPlayer(
            _selectedFeatureStory!.audioUrl!,
            "assets/images/quran_feature/${selectedFeatureStory!.image}",
            context);
    _moveStoryToEnd(index);
    Navigator.of(context)
        .pushNamed(RouteHelper.storyPlayer, arguments: 'fromFeature');
  }

  void _moveStoryToEnd(int index) {
    _selectedFeatureStory = _feature[index];
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
        _feature.map((stories) => stories.storyTitle!).toList();
    _preferences?.setStringList('feature_order', order);
  }

  void _loadStoriesOrder() async {
    final List<String>? order = _preferences?.getStringList('feature_order');

    if (order != null && order.isNotEmpty) {
      // Add a check for non-empty order
      final List<FeaturedModel> sortedStories = [];
      for (final storyTitle in order) {
        final story = _feature.firstWhere(
          (m) => m.storyTitle == storyTitle,
        );
        if (story != null) {
          sortedStories.add(story);
        }
      }
      _feature = sortedStories;
      notifyListeners();
    }
  }

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
      controller = VideoPlayerController.network(
        _selectedFeatureStory!.videoUrl!,
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

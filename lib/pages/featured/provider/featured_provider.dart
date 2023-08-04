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
import 'package:hijri/hijri_calendar.dart';

class FeatureProvider extends ChangeNotifier {
  List<FeaturedModel> _feature = [];
  List<FeaturedModel> _copyFeature =
      []; // Will remove this later as its currently needed to do operations as TEST CASES
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
  String _monthName = '';
  String get monthName => _monthName;

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

  //Test method will remove later (Input month from user and reorder)
  sethijriMonth(String value) {
    _monthName = value;
    // reorderStories();
    print(_monthName);
    notifyListeners();
  }

  void reorderStoriesforMonth(String mname) {
    sethijriMonth(mname);
    reorderHijriMonth(mname);
    notifyListeners();
  }

  void reorderHijriMonth(String inputMonth) {
    if (_copyFeature.isEmpty) {
      print('No features to reorder.');
      return;
    }

    String lowercaseInputMonth = inputMonth.toLowerCase();
    int userInputMonthIndex = -1;
    for (int i = 0; i < _copyFeature.length; i++) {
      if (_copyFeature[i].monthDisplay!.toLowerCase() == lowercaseInputMonth) {
        userInputMonthIndex = i;
        print('User input month found at index: $userInputMonthIndex');
        break;
      }
    }

    if (userInputMonthIndex != -1) {
      print('Swapping user input month with the first index.');

      // Swap the user-provided month's item with the first item in the _copyFeature list
      FeaturedModel firstItem = _copyFeature[0];
      FeaturedModel selectedMonthItem = _copyFeature[userInputMonthIndex];
      _copyFeature[0] = selectedMonthItem;
      _copyFeature[userInputMonthIndex] = firstItem;

      print('Reordered list: $_copyFeature');

      notifyListeners();
    } else {
      print('User input month not found in the list.');
    }
  }

  //

  // Method to be called every Friday to reorder stories
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

  String getHijriMonthAndYear(int month) {
    List<String> hijriMonthNames = [
      "Muharram",
      "Safar",
      "Rabi al-Awwal",
      "Rabi al-Thani",
      "Jumada al-Awwal",
      "Jumada al-Thani",
      "Rajab",
      "Sha'ban",
      "Ramadan",
      "Shawwal",
      "Dhu al-Qa'dah",
      "Dhu al-Hijjah"
    ];

    if (month >= 1 && month <= 12) {
      return hijriMonthNames[month - 1].toLowerCase();
    } else {
      return 'Unknown';
    }
  }

  void reorderStories(String dayName) {
    if (dayName == 'friday' || _feature.isEmpty) {
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
        // print('FRIDAYINDICESSS>>>>>>>${fridayIndices}');

        FeaturedModel firstItem = _feature[0];
        FeaturedModel selectedFridayItem = _feature[selectedFridayIndex];
        _feature[0] = selectedFridayItem;
        _feature[selectedFridayIndex] = firstItem;

        notifyListeners();
      }
    } else {
      // Get the current Hijri month
      String currentHijriMonth = getHijriMonthAndYear(
        HijriCalendar.now().hMonth,
      );
      // print('>>>>HIJRIMONTH>>>>${currentHijriMonth}');

      // Find the indices of rows with the current Hijri month
      List<int> currentMonthIndices = [];
      for (int i = 0; i < _feature.length; i++) {
        if (_feature[i].monthDisplay == currentHijriMonth) {
          currentMonthIndices.add(i);
        }
      }

      if (currentMonthIndices.isNotEmpty && _feature.length > 1) {
        Random random = Random();
        int randomIndex = random.nextInt(currentMonthIndices.length);
        int selectedMonthIndex = currentMonthIndices[randomIndex];
        // print('CURR_MONTH INDICES>>>>>>${currentMonthIndices}');

        FeaturedModel firstItem = _feature[0];
        FeaturedModel selectedMonthItem = _feature[selectedMonthIndex];
        _feature[0] = selectedMonthItem;
        _feature[selectedMonthIndex] = firstItem;

        notifyListeners();
      }
    }
  }

  Future<void> getStories() async {
    _feature = await HomeDb().getFeatured();
    scheduleReorder();
    // _loadStoriesOrder();
    _copyFeature = List.from(_feature);

    // Print the list and its indices
    print('AT RUNTIME LIST IS $_copyFeature');
    for (int i = 0; i < _copyFeature.length; i++) {
      print(
          'Index: $i, Month: ${_copyFeature[i].monthDisplay},ViewOrderBY: ${_copyFeature[i].viewOrderBy}, ');
    }

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

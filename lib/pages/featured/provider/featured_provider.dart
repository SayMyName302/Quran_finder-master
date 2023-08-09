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
  List<FeaturedModel> get feature => _feature;

  //Test List will remove when Task completed
  List<FeaturedModel> _featureListDate = [];
  List<FeaturedModel> get featureListDate => _featureListDate;
  int _currentFeatureIndex = 0;
  int get currentFeatureIndex => _currentFeatureIndex;
  FeaturedModel? _selectedFeatureStory;
  File? _videoUrl;
  File? get videoUrl => _videoUrl;
  FeaturedModel? get selectedFeatureStory => _selectedFeatureStory;
  SharedPreferences? _preferences;
  String _dayName = '';
  String get dayName => _dayName;
  String _monthName = '';
  String get monthName => _monthName;
  String _hijriDate = '';
  String get hijriDate => _hijriDate;

  setDayName(String value) {
    _dayName = value;
    notifyListeners();
  }

  void reorderStoriesIfNeeded(String dayName) {
    setDayName(dayName);
    reorderStories(dayName);
    notifyListeners();
  }

  ///M///
  //Test method will remove later (Input month from user and reorder)
  sethijriMonth(String value) {
    _monthName = value;
    notifyListeners();
  }

  //Test method will remove later (Input month from user and reorder)
  void reorderStoriesforMonth(String mname) {
    sethijriMonth(mname);
    reorderHijriMonth(mname);
    notifyListeners();
  }

  //Test method will remove later (Input month from user and reorder)
  void reorderHijriMonth(String inputMonth) {
    if (_feature.isEmpty) {
      // print('No features to reorder.');
      return;
    }

    String lowercaseInputMonth = inputMonth.toLowerCase();
    int userInputMonthIndex = -1;

    for (int i = 0; i < _feature.length; i++) {
      if (_feature[i].monthDisplay!.toLowerCase() == lowercaseInputMonth) {
        userInputMonthIndex = i;
        // print('User input month found at index: $userInputMonthIndex');
        break;
      }
    }

    if (userInputMonthIndex != -1) {
      // print('Swapping user input month with the first index.');

      // Swap the user-provided month's item with the first item in the _feature list
      FeaturedModel firstItem = _feature[0];
      FeaturedModel selectedMonthItem = _feature[userInputMonthIndex];
      _feature[0] = selectedMonthItem;
      _feature[userInputMonthIndex] = firstItem;

      // print('Reordered list: $_feature');

      notifyListeners();
    } else {
      // print('User input month not found in the list.');
    }
  }

  ///M///

  //d// Test method will remove when task completed
  void reorderStoriesforDate(String hdate, String hmonth) {
    sethijriDate(hdate, hmonth);
    // reorderHijriMonth(hdate);
    notifyListeners();
  }

  sethijriDate(String hdatee, String hmonthh) async {
    _hijriDate = hdatee;
    _monthName = hmonthh;
    _featureListDate = await HomeDb()
        .filterFeaturesByIslamicDate(_feature, _hijriDate, _monthName);
    // print('List fetched IN PROVIDER${_featureListDate}');
    reorderHijriDate(_featureListDate);
    notifyListeners();
  }

  void reorderHijriDate(List<FeaturedModel> filteredList) {
    if (filteredList.isEmpty) {
      // print('No features to reorder.');
      return;
    }

    // Find the index of the first item with the lowest index in the list that matches the date
    int lowestIndex = -1;
    for (int i = 0; i < filteredList.length; i++) {
      if (filteredList[i].day == filteredList[0].day) {
        lowestIndex = i;
        break;
      }
    }

    if (lowestIndex != -1) {
      // Swap the items
      FeaturedModel firstItem = filteredList[0];
      filteredList[0] = filteredList[lowestIndex];
      filteredList[lowestIndex] = firstItem;

      // print('Reordered list: $filteredList');

      notifyListeners();
    } else {
      // If the date is not found in the list
      // print('User provided date not found in the list.');
    }
  }

  //d//

  // Method to check Day if found else execute Month Logic
  void scheduleReorder() {
    DateTime now = DateTime.now();
    if (now.weekday == DateTime.friday) {
      reorderStories('friday');
    } else {
      reorderStories('notFriday');
    }
  }

  //Method returns lowerCaseHijriMonth name
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
        // print('FRIDAYINDICESSS>>>>>>>${fridayIndices}');

        FeaturedModel firstItem = _feature[0];
        FeaturedModel selectedFridayItem = _feature[selectedFridayIndex];
        _feature[0] = selectedFridayItem;
        _feature[selectedFridayIndex] = firstItem;

        notifyListeners();
      }
    } else {
      // Get the current Hijri month
      String currentHijriMonth =
          getHijriMonthAndYear(HijriCalendar.now().hMonth);

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

    //Uncomment this after testing date
    scheduleReorder();

    // int date = HijriCalendar.now().hDay;
    // int month = HijriCalendar.now().hMonth;
    // int year = HijriCalendar.now().hYear;
    // int mlength = HijriCalendar.now().lengthOfMonth;
    // print('====DATE $date====');
    // print('====MONTH $month====');
    // print('====YEAR $year====');
    // print('====MonthLength $mlength====');

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

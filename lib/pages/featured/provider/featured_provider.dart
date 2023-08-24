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

import '../../home/models/friday_content.dart';

class FeatureProvider extends ChangeNotifier {
  List<FeaturedModel> _feature = [];
  List<FeaturedModel> get feature => _feature;

  int _currentFeatureIndex = 0;
  int get currentFeatureIndex => _currentFeatureIndex;
  FeaturedModel? _selectedFeatureStory;
  FeaturedModel? get selectedFeatureStory => _selectedFeatureStory;

  List<Friday> _friday = [];
  List<Friday> get friday => _friday;
  Friday? _selectedFridayStory;
  Friday? get selectedFridayStory => _selectedFridayStory;

  File? _videoUrl;
  File? get videoUrl => _videoUrl;
  SharedPreferences? _preferences;
  String _dayName = '';
  String get dayName => _dayName;
  String _monthName = '';
  String get monthName => _monthName;
  String _hijriDate = '';
  String get hijriDate => _hijriDate;
  String _georgeDate = '';
  String get georgeDate => _georgeDate;
  int _hijriYear = 0;
  int get hijriYear => _hijriYear;

  setDayName(String value) {
    _dayName = value;
    notifyListeners();
  }

  void reorderStoriesDayName(String dayName) {
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
  void reorderStoriesforHijriDate(String hdate) {
    sethijriDateInput(hdate);
    notifyListeners();
  }

  sethijriDate(String hdate) async {
    _hijriDate = hdate;
    List<FeaturedModel> tempFeatureList = List.from(_feature);

    List<FeaturedModel> _featureListHijriDate =
        await HomeDb().filterFeaturesByIslamicDate(tempFeatureList, _hijriDate);

    if (_featureListHijriDate.isNotEmpty && tempFeatureList.isNotEmpty) {
      // Find the index of the filtered item in tempFeatureList
      int filteredIndex = tempFeatureList.indexWhere(
        (item) =>
            item.islamicDate == _featureListHijriDate[0].islamicDate &&
            item.monthDisplay == _featureListHijriDate[0].monthDisplay &&
            item.hijriYear == _featureListHijriDate[0].hijriYear,
      );
      print('INDEX FOUND AT $filteredIndex');

      if (filteredIndex != -1) {
        // Swap the items in tempFeatureListt
        FeaturedModel temp = tempFeatureList[0];
        tempFeatureList[0] = tempFeatureList[filteredIndex];
        tempFeatureList[filteredIndex] = temp;
      } else {
        print('Filtered item not found in tempFeatureList');
      }
    }

    _feature = tempFeatureList;
    notifyListeners();
  }

  //Test PURPOSE WILL REMOVE LATER, upper method should remain later on remove this below method only
  sethijriDateInput(String hdate) async {
    _hijriDate = hdate;
    List<FeaturedModel> tempFeatureList = List.from(_feature);

    List<FeaturedModel> featureListHijriDate =
        await HomeDb().filterFeaturesByHijriDate(tempFeatureList, _hijriDate);

    if (featureListHijriDate.isNotEmpty && tempFeatureList.isNotEmpty) {
      // Find the index of the filtered item in tempFeatureList
      int filteredIndex = tempFeatureList.indexWhere(
        (item) =>
            item.islamicDate == featureListHijriDate[0].islamicDate &&
            item.monthDisplay == featureListHijriDate[0].monthDisplay &&
            item.hijriYear == featureListHijriDate[0].hijriYear,
      );
      print('INDEX FOUND AT $filteredIndex');

      if (filteredIndex != -1) {
        // Swap the items in tempFeatureList
        FeaturedModel temp = tempFeatureList[0];
        tempFeatureList[0] = tempFeatureList[filteredIndex];
        tempFeatureList[filteredIndex] = temp;
      } else {
        print('Filtered item not found in tempFeatureList');
      }
    }
    _feature = tempFeatureList;
    notifyListeners();
  }

  //d//

  /////////
  /////d// Test method will remove when task completed
  void reorderStoriesforHijriYear(int hYear) {
    print(hYear);
    sethijriYearInput(hYear);
    notifyListeners();
  }

  //Test PURPOSE WILL REMOVE LATER, upper method should remain later on remove this below method only
  sethijriYearInput(int hYear) async {
    _hijriYear = hYear;
    List<FeaturedModel> tempFeatureList = List.from(_feature);

    List<FeaturedModel> featureListHijriDate =
        await HomeDb().filterFeaturesByHijriYear(tempFeatureList, _hijriYear);

    if (featureListHijriDate.isNotEmpty && tempFeatureList.isNotEmpty) {
      // Find the index of the filtered item in tempFeatureList
      int filteredIndex = tempFeatureList.indexWhere(
        (item) => item.hijriYear == featureListHijriDate[0].hijriYear,
      );
      print('INDEX FOUND AT $filteredIndex');

      if (filteredIndex != -1) {
        // Swap the items in tempFeatureList
        FeaturedModel temp = tempFeatureList[0];
        tempFeatureList[0] = tempFeatureList[filteredIndex];
        tempFeatureList[filteredIndex] = temp;
      } else {
        print('Filtered item not found in tempFeatureList');
      }
    }
    _feature = tempFeatureList;
    notifyListeners();
  }
  ///////////

  //GeorgianDate// Test method will remove when task completed
  void reorderStoriesforGeorgeDate(String hdate) {
    setGeorgeDate(hdate);
    notifyListeners();
  }

  setGeorgeDate(String hdate) async {
    _georgeDate = hdate;
    print(georgeDate);
    List<FeaturedModel> tempFeatureList = List.from(_feature);

    List<FeaturedModel> _featureListHijriDate =
        await HomeDb().filterFeaturesByGeorgeDate(tempFeatureList, _georgeDate);

    if (_featureListHijriDate.isNotEmpty && tempFeatureList.isNotEmpty) {
      // Find the index of the filtered item in tempFeatureList
      int filteredIndex = tempFeatureList.indexWhere(
        (item) =>
            item.georgeDate == _featureListHijriDate[0].georgeDate &&
            item.georgeMonth == _featureListHijriDate[0].georgeMonth &&
            item.georgeYear == _featureListHijriDate[0].georgeYear,
      );
      print('INDEX FOUND AT $filteredIndex');

      if (filteredIndex != -1) {
        // Swap the items in tempFeatureList
        FeaturedModel temp = tempFeatureList[0];
        tempFeatureList[0] = tempFeatureList[filteredIndex];
        tempFeatureList[filteredIndex] = temp;
      } else {
        print('Filtered item not found in tempFeatureList');
      }
    }

    _feature = tempFeatureList;
    notifyListeners();
  }

  //d//

  // Method to check HijriDate records in db if found else checks Georgian date else checks Day else Month
  void scheduleReorder() async {
    HijriCalendar currentDate = HijriCalendar.now();
    String todayHijriDate = currentDate.hDay.toString();
    print("Today's Hijri date is: $todayHijriDate");

    List<FeaturedModel> featureListHijriDate =
        await HomeDb().filterFeaturesByIslamicDate(_feature, todayHijriDate);

    if (featureListHijriDate.isNotEmpty) {
      print("Found matching rows for Hijri date: $todayHijriDate");
      sethijriDate(todayHijriDate);
    } else {
      DateTime now = DateTime.now();
      if (now.weekday == DateTime.friday) {
        print("Today is Friday, reordering for Friday");
        reorderStories('friday');
      } else {
        String formattedDate = "${now.month.toString().padLeft(1, '0')}"
            "${now.day.toString().padLeft(2, '0')}"
            "${now.year.toString().substring(2)}";
        print("Today's Georgian date is: $formattedDate");

        List<FeaturedModel> featureListGeorgeDate =
            await HomeDb().filterByGeorgeDate(_feature, formattedDate);

        if (featureListGeorgeDate.isNotEmpty) {
          print("Found matching rows for Georgian date: $formattedDate");
          setGeorgeDate(formattedDate);
        } else {
          print("Checking for today's day name");
          // If needed, you can add additional logic for checking day name here
          reorderStories('notFriday');
        }
      }
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
      print('Today is Not Friday,Executing Month Logic');
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
    _friday = [await HomeDb().fridayFilter()];

    //Uncomment this after testing date
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

    // _moveStoryToEnd(index);
    Navigator.of(context).pushNamed(RouteHelper.featureDetails);
    // _moveStoryToEnd(index);
  }

  gotoFeaturePlayerPage(int storyId, BuildContext context, int index) {
    _currentFeatureIndex =
        _feature.indexWhere((element) => element.storyId == storyId);
    _selectedFeatureStory = _feature[_currentFeatureIndex];
    Provider.of<StoryAndBasicPlayerProvider>(context, listen: false)
        .initAudioPlayer(_selectedFeatureStory!.audioUrl!,
            "${selectedFeatureStory!.image}", context);
    // _moveStoryToEnd(index);
    Navigator.of(context)
        .pushNamed(RouteHelper.storyPlayer, arguments: 'fromFeature');
  }

  gotoFeaturePlayerPageF(int storyId, BuildContext context, int index) {
    _currentFeatureIndex =
        _friday.indexWhere((element) => element.recitationId == storyId);
    _selectedFridayStory = _friday[_currentFeatureIndex];
    Provider.of<StoryAndBasicPlayerProvider>(context, listen: false)
        .initAudioPlayer(_selectedFridayStory!.contentUrl!,
            "${selectedFridayStory!.appImageUrl}", context);
    // _moveStoryToEnd(index);
    Navigator.of(context)
        .pushNamed(RouteHelper.storyPlayer, arguments: 'fromFeature');
  }

  // void _moveStoryToEnd(int index) {
  //   _selectedFeatureStory = _feature[index];
  //   notifyListeners();

  //   Future.delayed(const Duration(milliseconds: 300), () {
  //     _feature.removeAt(index);
  //     _feature.add(_selectedFeatureStory!);
  //     notifyListeners();
  //     _saveStoriesOrder();

  //     // Find the new index of the selected story after it has been moved
  //     _currentFeatureIndex = _feature.indexOf(_selectedFeatureStory!);
  //     notifyListeners();
  //   });
  // }

  // void _saveStoriesOrder() async {
  //   final List<String> order =
  //       _feature.map((stories) => stories.storyTitle!).toList();
  //   _preferences?.setStringList('feature_order', order);
  // }

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
        Uri.parse(_selectedFeatureStory!.videoUrl!),
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

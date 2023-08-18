import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:android_intent_plus/android_intent.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:nour_al_quran/shared/database/quran_db.dart';
import 'package:nour_al_quran/shared/entities/quran_text.dart';
import 'package:nour_al_quran/shared/entities/surah.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../shared/utills/app_constants.dart';
import '../../../shared/widgets/easy_loading.dart';
import 'package:hijri/hijri_calendar.dart';

import '../../onboarding/provider/on_boarding_provider.dart';
import '../../settings/pages/notifications/notification_services.dart';
import '../models/title_custom.dart';

class HomeProvider extends ChangeNotifier {
  int? verseId = 0;
  int? surahId = 0;
  QuranText _verseOfTheDay = QuranText(
      surahId: 105,
      verseId: 4,
      verseText: "تَرْمِيهِم بِحِجَارَةٍ مِّن سِجِّيلٍ",
      translationText: "",
      isBookmark: 0,
      juzId: 1);
  QuranText get verseOfTheDay => _verseOfTheDay;
  Surah? surahName;

  //For Region/Zone
  String _country = "";
  String _date = "";
  String _time = "";
  String _hijriMonth = "";
  String _hijriYear = "";
  String _dayName = "";
  String _weather = "";
  String _hijriDate = "";

  String get country => _country;
  String get date => _date;
  String get time => _time;
  String get hijriMonth => _hijriMonth;
  String get hijriYear => _hijriYear;
  String get dayName => _dayName;
  String get weather => _weather;
  String get hijriDate => _hijriDate;

  //For Recitation Time of the Day
  String _rCountryName = "";
  String _rTimeOfTheDay = "";

  String get rCountryName => _rCountryName;
  String get rTimeOfTheDay => _rTimeOfTheDay;

  //Fetching all the text_title by filtering
  List<CustomTitles> _titleText = [];
  List<CustomTitles> get titleText => _titleText;

  //Fetching all title_text by filtering Recitation TOD
  String? _rtitleText = 'Recitations';
  String? get rtitleText => _rtitleText;

  //For Test Users
  // bool? _user;
  // bool? get userFound => _user;

  final ValueNotifier<bool?> _user = ValueNotifier<bool?>(null);
  ValueNotifier<bool?> get user => _user;

  //this variable will be used to display in HomeScreen text change
  String? _selectedTitleText;
  String? get selectedTitleText => _selectedTitleText;

  //this variable will be used to display in Quran text change
  String? _selectedrecTitleText;
  String? get selectedrecTitleText => _selectedrecTitleText;

  bool isRequestingPermission = false;

  Future<void> checkUser(String email) async {
    bool userExists = await QuranDatabase().checkUserInDatabase(email);
    _user.value = userExists;
  }

  Future<List<CustomTitles>> getTitlesByCountry(String country) async {
    _titleText = await QuranDatabase().getCountrytitles(country);
    notifyListeners();
    return _titleText;
  }

  Future<List<CustomTitles>> getTitlesbyWeather(String country) async {
    List<CustomTitles> titles =
        await QuranDatabase().getTitlesByWeather(country);
    notifyListeners();
    return titles;
  }

  //Only For Country and TOD Input in Recitations
  void updateInput(String country, String tod) {
    _rCountryName = country;
    _rTimeOfTheDay = tod;
    getTitlesForRecitationsExplicitly(_rCountryName, _rTimeOfTheDay);
    notifyListeners();
  }

  Future<String?> getTitlesForRecitationsExplicitly(
      String country, String tod) async {
    _rtitleText = await QuranDatabase().getRecitationTitleExpTOD(country, tod);
    notifyListeners();
    return _rtitleText;
  }

  //Only country input by user
  Future<List<CustomTitles>> getTitlesByCountryExplicitly(
      String country) async {
    _titleText = await QuranDatabase().getCountrytitlesExplicitly(country);
    notifyListeners();
    return _titleText;
  }

  // Country name and weather input by user
  Future<List<CustomTitles>> getWeatherCountryTitles(
      String country, String weather) async {
    _titleText =
        await QuranDatabase().getWeatherCountryTitles(country, weather);
    notifyListeners();
    return _titleText;
  }

  //Setting weather value to show in UI
  void updateWeather(String newWeather) {
    _weather = newWeather;
    notifyListeners();
  }

  void updateHijriDate(String hijriDate) {
    _hijriDate = hijriDate;
    notifyListeners();
  }

  void setSelectedTitleText(String? text) {
    _selectedTitleText = text;
    notifyListeners();
  }

  // getVerse(BuildContext context) async {
  //   _verseOfTheDay = await QuranDatabase().getVerseOfTheDay() ??
  //       QuranText(
  //           surahId: 105,
  //           verseId: 4,
  //           verseText: "تَرْمِيهِم بِحِجَارَةٍ مِّن سِجِّيلٍ",
  //           translationText: "",
  //           isBookmark: 0,
  //           juzId: 1);
  //   verseId = _verseOfTheDay.verseId;
  //   surahId = _verseOfTheDay.surahId;
  //   if (_verseOfTheDay.surahId != null) {
  //     surahName =
  //         await QuranDatabase().getSpecificSurahName(_verseOfTheDay.surahId!);
  //   }
  //   notifyListeners();
  //   Future.delayed(Duration.zero, () {
  //     bool dailyVerseNotificationEnable =
  //         OnBoardingProvider().notification[1].isSelected!;
  //     if (dailyVerseNotificationEnable) {
  //       NotificationServices().dailyNotifications(
  //           id: dailyVerseNotificationId,
  //           title: "Verse Of the Day",
  //           body: _verseOfTheDay.verseText!,
  //           payload: "dua",
  //           dailyNotifyTime: const TimeOfDay(hour: 14, minute: 07));
  //     }
  //   });
  // }
  // void sendVerseNotification(String verse) async {
  //   // Sending OneSignal notification
  //   var notification = OSCreateNotification(
  //     playerIds: [
  //       'e1a5e8bf-a00e-49a2-90cb-9b4834fef138'
  //     ], // Add the player IDs of your active users here
  //     //  includedSegments: ['All'],

  //     content: verse,
  //     heading: "Verse of the Day",
  //     additionalData: {"verse": verse}, // Attach verse data here
  //   );

  //   var response = await OneSignal.shared.postNotification(notification);

  //   if (response != null && response["success"] == true) {
  //     print("OneSignal Notification sent successfully");
  //   } else {
  //     print("OneSignal Notification sending failed");
  //   }
  // }

  void getVerse(BuildContext context) async {
    _verseOfTheDay = await QuranDatabase().getVerseOfTheDay() ??
        QuranText(
            surahId: 105,
            verseId: 4,
            verseText: "تَرْمِيهِم بِحِجَارَةٍ مِّن سِجِّيلٍ",
            translationText: "",
            isBookmark: 0,
            juzId: 1);
    verseId = _verseOfTheDay.verseId;
    surahId = _verseOfTheDay.surahId;
    if (_verseOfTheDay.surahId != null) {
      surahName =
          await QuranDatabase().getSpecificSurahName(_verseOfTheDay.surahId!);
    }

    notifyListeners();
    Future.delayed(Duration.zero, () {
      bool dailyVerseNotificationEnable =
          OnBoardingProvider().notification[1].isSelected!;
      if (dailyVerseNotificationEnable) {
        NotificationServices().checkPermissionAndSetNotification(() {
          NotificationServices().dailyNotifications(
              id: dailyVerseNotificationId,
              title: "Verse Of the Day",
              body: _verseOfTheDay.verseText!,
              payload: "dua",
              dailyNotifyTime: const TimeOfDay(hour: 8, minute: 0));
        });
      }
    });
    final currentTime = TimeOfDay.now();
    if (currentTime.hour == 16 && currentTime.minute == 37) {
      // sendVerseNotification(_verseOfTheDay.verseText!);
      // print('Selected verse: ${_verseOfTheDay.verseText!}');
    }
  }

  // void getPlayerId() async {
  //   var deviceState = await OneSignal.shared.getDeviceState();
  //   var playerId = deviceState!.userId;
  //   print('OneSignal Player ID:>>>>> $playerId');
  // }

  updateVerseTranslation() async {
    _verseOfTheDay = await QuranDatabase().getVerse(_verseOfTheDay);
    notifyListeners();
  }

  Future getLocationPermission(BuildContext context) async {
    if (isRequestingPermission) {
      return;
    }

    isRequestingPermission = true;

    var permissionStatus = await Permission.location.request();

    isRequestingPermission = false;

    if (permissionStatus.isDenied) {
      Future.delayed(
        Duration.zero,
        () => showError(
          context: context,
          msg: 'Please Allow Quran Pro to Use Location Services',
        ),
      );
    } else if (permissionStatus.isGranted) {
      // UserData userData = await getRegionAndShowContent(context);
      // updateUserData(userData);
      // UserDataforRecitation recitationData =
      //     (await getRegionAndShowContent(context)) as UserDataforRecitation;
      // updateRecitationData(recitationData);
      Map<String, dynamic> data = await getRegionAndShowContent(context);
      UserData userData = data['userData'];
      UserDataforRecitation recitationData = data['recitationData'];
      updateUserData(userData);
      updateRecitationData(recitationData);

      notifyListeners();
    } else {
      Future.delayed(
        Duration.zero,
        () => showError(
          context: context,
          msg: 'Please Enable Location Services',
        ),
      );
    }
  }

  Future<Map<String, String>> checkWeather(
      double latitude, double longitude, BuildContext context) async {
    try {
      //Printing Player ID FOR ONE SIGNAL TEST PURPOSE ONLY
      // getPlayerId();
      var dio = Dio();
      String url =
          "http://api.weatherapi.com/v1/current.json?key=73ec04d970d540f1ba3173621232602&q=$latitude,$longitude&aqi=yes";

      Response response = await dio.get(url);
      var data = response.data;
      if (response.statusCode == 200) {
        String weatherCondition =
            data['current']['condition']['text'].toString().toLowerCase();
        String country = data['location']['country'].toString().toLowerCase();

        // String cityAPI = data['location']['name'].toString().toLowerCase();
        //print('==URL API=${url}=====');

        if (weatherCondition.contains("rain") ||
            weatherCondition.contains("light rain")) {
          return {
            'weather': 'rain',
            'country': country,
          };
        } else {
          return {
            'weather': weatherCondition,
            'country': country,
          };
        }
      }
    } catch (e, stackTrace) {
      print("Error fetching weather data: $e");
      print(stackTrace);
      EasyLoadingDialog.dismiss(context);
      return {
        'weather': 'other',
        'country': '',
      };
    }
    return {
      'weather': 'other',
      'country': '',
    };
  }

  //Test method will remove later
  Future<void> updateUserData(UserData userData) async {
    _country = userData.country;
    _date = userData.date;
    _time = userData.time;
    _hijriMonth = userData.hijriMonth;
    _hijriYear = userData.hijriYear;
    _dayName = userData.dayName;
    notifyListeners();
  }

  //Test method will remove later
  Future<void> updateRecitationData(UserDataforRecitation userData) async {
    _rCountryName = userData.country;
    _rTimeOfTheDay = userData.tod;
    notifyListeners();
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

  Future<Map<String, dynamic>> getRegionAndShowContent(
      BuildContext context) async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      ).timeout(const Duration(seconds: 15));

      List<Placemark> placeMarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placeMarks.isNotEmpty) {
        Placemark placeMark = placeMarks[0];
        String country = placeMark.country?.toLowerCase() ?? "";
        double latitude = position.latitude;
        double longitude = position.longitude;
        // ignore: use_build_context_synchronously
        Map<String, String> weatherData = await checkWeather(
          latitude,
          longitude,
          context,
        );
        String weatherCondition = weatherData['weather'] ?? "";
        String countryfromapi = weatherData['country'] ?? "";
        print('country fromapi is>>>${countryfromapi}');

        //Code For Recitation Title Text based on Time of The Day
        String? recitationTitle =
            await QuranDatabase().getRecitationTitleOnTOD(countryfromapi);
        _rtitleText = recitationTitle;
        //

        //Remove this method when All the code is ready(Right Now its only being used to update UI)
        updateWeather(weatherCondition);
        //
        if (weatherCondition == "rain") {
          List<CustomTitles> titles = await getTitlesbyWeather(countryfromapi);
          if (titles.isNotEmpty) {
            int randomIndex = Random().nextInt(titles.length);
            CustomTitles selectedTitle = titles[randomIndex];
            String? selectedTitleText = selectedTitle.titleText;
            _selectedTitleText =
                selectedTitleText ?? "No Title Available for Raining Weather}";
          } else {
            _selectedTitleText = "No Title Available for Raining Weather";
          }
        } else {
          List<CustomTitles> titles = await getTitlesByCountry(countryfromapi);
          if (titles.isNotEmpty) {
            int randomIndex = Random().nextInt(_titleText.length);
            // print('length of titles are>>>${_titleText.length}');
            CustomTitles selectedTitle = _titleText[randomIndex];
            String? selectedTitleText = selectedTitle.titleText;
            _selectedTitleText = selectedTitleText;
          } else {
            // countries naming all and weather not like rain,thunder etc
            List<CustomTitles> allCountryTitles =
                await getTitlesByCountry('all');
            if (allCountryTitles.isNotEmpty) {
              int randomIndex = Random().nextInt(allCountryTitles.length);
              //    print('length of titles are>>>${_titleText.length}');
              CustomTitles selectedTitle = allCountryTitles[randomIndex];
              String? selectedTitleText = selectedTitle.titleText;
              _selectedTitleText = selectedTitleText;
            } else {
              _selectedTitleText = "Popular Recitations";
            }
          }
        }

        DateTime now = DateTime.now();
        String formattedDate = DateFormat('Mddyy').format(now);
        String formattedTime = DateFormat('HH').format(now);

        // Time of Day Data for Recitation Section Will Remove Later
        String currentTimePeriod = '';

        if (now.hour >= 5 && now.hour < 12) {
          currentTimePeriod = 'morning';
        } else if (now.hour >= 12 && now.hour < 18) {
          currentTimePeriod = 'afternoon';
        } else if (now.hour >= 18 && now.hour < 22) {
          currentTimePeriod = 'evening';
        } else {
          currentTimePeriod = 'night';
        }
        //

        String hijriMonthAndYear = getHijriMonthAndYear(
          HijriCalendar.now().hMonth,
        );
        String hijriYear = HijriCalendar.now().hYear.toString();
        String hijriDate = HijriCalendar.now().hDay.toString();

        //Remove this method when All the code is ready(Right Now its only being used to update UI)
        updateHijriDate(hijriDate);

        String dayName =
            DateFormat('EEEE').format(DateTime.now()).toLowerCase();

        UserData userData = UserData(
            country: country,
            date: formattedDate,
            time: formattedTime,
            hijriMonth: hijriMonthAndYear,
            hijriYear: hijriYear,
            dayName: dayName,
            weather: weatherCondition,
            hijridate: hijriDate);

        UserDataforRecitation recitationData =
            UserDataforRecitation(country: country, tod: currentTimePeriod);
        notifyListeners();

        return {
          'userData': userData,
          'recitationData': recitationData,
        }; // return LocationData(userData: userData, recitationData: recitationData);
      } else {
        throw Exception("PlaceMarks is empty");
      }
    } catch (e) {
      throw Exception("Error fetching location data: $e");
    }
  }

  Future<void> openAppSettingsPermissionSection() async {
    if (Platform.isAndroid) {
      const intent = AndroidIntent(
        action: 'action_application_details_settings',
        data: 'package:com.nouralquran.nouralquran',
      );
      await intent.launch();
    } else if (Platform.isIOS) {
      const String settingsUrl = 'app-settings:';
      if (await canLaunchUrl(settingsUrl as Uri)) {
        await launchUrl(settingsUrl as Uri);
      } else {
        throw 'Could not launch the app settings page.';
      }
    }
  }

  showError({required BuildContext context, required String msg}) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(msg)));
  }

  String getRegionFromCountry(String country) {
    switch (country) {
      case "pakistan":
      case "india":
      case "indonesia":
      case "bangladesh":
      case "china":
        return "Asia";
      case "france":
      case "spain":
      case "germany":
        return "Europe";
      case "saudi arabia":
        return "Middle East";
      case "united states":
      case "canada":
      case "central america":
        return "North America";
      default:
        return "Unknown";
    }
  }
}

class UserData {
  String country;
  String date;
  String time;
  String hijriMonth;
  String hijriYear;
  String dayName;
  String weather;
  String hijridate;

  UserData({
    required this.country,
    required this.date,
    required this.time,
    required this.hijriMonth,
    required this.hijriYear,
    required this.dayName,
    required this.weather,
    required this.hijridate,
  });
}

class UserDataforRecitation {
  String country;
  String tod;

  UserDataforRecitation({
    required this.country,
    required this.tod,
  });
}

class LocationData {
  final UserData userData;
  final UserDataforRecitation recitationData;

  LocationData({
    required this.userData,
    required this.recitationData,
  });
}

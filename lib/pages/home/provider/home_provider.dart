import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:android_intent_plus/android_intent.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:nour_al_quran/pages/home/models/test_users.dart';
import 'package:nour_al_quran/pages/settings/pages/notifications/notification_services.dart';
import 'package:nour_al_quran/shared/database/quran_db.dart';
import 'package:nour_al_quran/shared/entities/quran_text.dart';
import 'package:nour_al_quran/shared/entities/surah.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../shared/utills/app_constants.dart';
import '../../../shared/widgets/easy_loading.dart';
import '../../onboarding/provider/on_boarding_provider.dart';
import 'package:hijri/hijri_calendar.dart';

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

  //Fetching all the text_title by filtering
  List<CustomTitles> _titleText = [];
  List<CustomTitles> get titleText => _titleText;

  //For Test Users
  // bool? _user;
  // bool? get userFound => _user;

  final ValueNotifier<bool?> _user = ValueNotifier<bool?>(null);
  ValueNotifier<bool?> get user => _user;

  //this variable will be used to display in HomeScreen text change
  String? _selectedTitleText;
  String? get selectedTitleText => _selectedTitleText;

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

  getVerse(BuildContext context) async {
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
        NotificationServices().dailyNotifications(
            id: dailyVerseNotificationId,
            title: "Verse Of the Day",
            body: _verseOfTheDay.verseText!,
            payload: "dua",
            dailyNotifyTime: const TimeOfDay(hour: 8, minute: 0));
      }
    });
  }

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
      UserData userData = await getRegionAndShowContent(context);
      updateUserData(userData);
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

  Future<void> updateUserData(UserData userData) async {
    _country = userData.country;
    _date = userData.date;
    _time = userData.time;
    _hijriMonth = userData.hijriMonth;
    _hijriYear = userData.hijriYear;
    _dayName = userData.dayName;
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

  Future<UserData> getRegionAndShowContent(BuildContext context) async {
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
        Map<String, String> weatherData = await checkWeather(
          latitude,
          longitude,
          context,
        );
        String weatherCondition = weatherData['weather'] ?? "";
        String countryfromapi = weatherData['country'] ?? "";

        //Remove this method when All the code is ready(Right Now its only being used to update UI)
        updateWeather(weatherCondition);

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
          List<CustomTitles> titles = await getTitlesByCountry(country);
          if (titles.isNotEmpty) {
            int randomIndex = Random().nextInt(_titleText.length);
            CustomTitles selectedTitle = _titleText[randomIndex];
            String? selectedTitleText = selectedTitle.titleText;
            _selectedTitleText = selectedTitleText;
          } else {
            _selectedTitleText = "Popular Recitations";
          }
        }

        DateTime now = DateTime.now();
        String formattedDate = DateFormat('Mddyy').format(now);
        String formattedTime = DateFormat('HH').format(now);

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

        notifyListeners();

        return userData;
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

import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
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

  String get country => _country;
  String get date => _date;
  String get time => _time;
  String get hijriMonth => _hijriMonth;
  String get hijriYear => _hijriYear;
  String get dayName => _dayName;

  //Fetching all the text_title by filtering on country name
  List<CustomTitle> _titleText = [];
  List<CustomTitle> get titleText => _titleText;

  //this variable will be used to display in HomeScreen text change
  String? _selectedTitleText;
  String? get selectedTitleText => _selectedTitleText;

  bool isRequestingPermission = false;

  Future<void> getTitlesByCountry(String country) async {
    _titleText = await QuranDatabase().getCountrytitles(country);
    notifyListeners();
  }

  Future<void> getTitlesByCountryExplicitly(String country) async {
    _titleText = await QuranDatabase().getCountrytitlesExplicitly(country);
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
    EasyLoadingDialog.show(context: context, radius: 20.r);

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      ).timeout(const Duration(seconds: 15));

      List<Placemark> placeMarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placeMarks.isNotEmpty) {
        Placemark placeMark = placeMarks[0];
        String country = placeMark.country?.toLowerCase() ?? "";
        print('=====Country{$country}======');
        await getTitlesByCountry(country);
        // Select a random title from the list
        // Select a random title from the list
        if (_titleText.isNotEmpty) {
          int randomIndex = Random().nextInt(_titleText.length);
          CustomTitle selectedTitle = _titleText[randomIndex];
          String? selectedTitleText = selectedTitle.titleText;
          _selectedTitleText = selectedTitleText;
        } else {
          _selectedTitleText = "Popular Recitations";
        }

        notifyListeners();

        DateTime now = DateTime.now();
        String formattedDate = DateFormat('MMddyy').format(now);
        String formattedTime = DateFormat('HH').format(now);
        notifyListeners();

        String hijriMonthAndYear = getHijriMonthAndYear(
          HijriCalendar.now().hMonth,
        );
        String hijriYear = HijriCalendar.now().hYear.toString();
        String dayName =
            DateFormat('EEEE').format(DateTime.now()).toLowerCase();
        notifyListeners();

        return UserData(
          country: country,
          date: formattedDate,
          time: formattedTime,
          hijriMonth: hijriMonthAndYear,
          hijriYear: hijriYear,
          dayName: dayName,
        );
      } else {
        throw Exception("PlaceMarks is empty");
      }
    } catch (e) {
      throw Exception("Error fetching location data: $e");
    } finally {
      EasyLoadingDialog.dismiss(context);
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

  UserData({
    required this.country,
    required this.date,
    required this.time,
    required this.hijriMonth,
    required this.hijriYear,
    required this.dayName,
  });
}

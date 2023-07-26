import 'dart:async';
import 'dart:io';

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
import '../../onboarding/on_boarding_provider.dart';
import 'package:hijri/hijri_calendar.dart';

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
  String _region = "";
  String _dateTime = "";
  String _hijriMonth = "";
  String _hijriYear = "";
  String _dayName = "";

  String get region => _region;
  String get dateTime => _dateTime;
  String get hijriMonth => _hijriMonth;
  String get hijriYear => _hijriYear;
  String get dayName => _dayName;

  bool isRequestingPermission = false;

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
    _region = userData.region;
    _dateTime = userData.dateTime;
    _hijriMonth = userData.hijriMonth;
    _hijriYear = userData.hijriYear;
    _dayName = userData.dayName;
    notifyListeners();
  }

  String getHijriMonthAndYear(int month, int year) {
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
      return "${hijriMonthNames[month - 1]} $year";
    } else {
      return 'Unknown';
    }
  }

  Future<UserData> getRegionAndShowContent(BuildContext context) async {
    EasyLoadingDialog.show(context: context, radius: 20.r);

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
      ).timeout(const Duration(seconds: 15));

      List<Placemark> placeMarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placeMarks.isNotEmpty) {
        Placemark placeMark = placeMarks[0];
        String region = placeMark.administrativeArea ?? "";
        notifyListeners();

        String formattedDateTime =
            DateFormat('dd/MM/yy HH:mm').format(DateTime.now());

        notifyListeners();

        String hijriMonthAndYear = getHijriMonthAndYear(
          HijriCalendar.now().hMonth,
          HijriCalendar.now().hYear,
        );
        String hijriYear = HijriCalendar.now().hYear.toString();
        String dayName = DateFormat('EEEE').format(DateTime.now());

        notifyListeners();

        return UserData(
          region: region,
          dateTime: formattedDateTime,
          hijriMonth: hijriMonthAndYear,
          hijriYear: hijriYear,
          dayName: dayName,
        );
      } else {
        throw Exception(
            "PlaceMarks is empty"); // You can throw an exception or return a default value here
      }
    } catch (e) {
      // Handle any exceptions that may occur during the location retrieval
      throw Exception("Error fetching location data: $e");
    } finally {
      EasyLoadingDialog.dismiss(context);
    }
  }

  // Future<void> saveUserRegion(
  //   String region,
  //   String dateTime,
  //   String hijriMonth,
  // ) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('user_region', region);
  //   await prefs.setString('user_date_time', dateTime);
  //   await prefs.setString('user_hijri_month', hijriMonth);
  //   notifyListeners();
  // }

  // Future<String?> getUserRegion() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString('user_region');
  // }

  // Future<String?> getUserDateTime() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString('user_date_time');
  // }

  // Future<String?> getUserHijriMonth() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString('user_hijri_month');
  // }

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
}

class UserData {
  String region;
  String dateTime;
  String hijriMonth;
  String hijriYear;
  String dayName;

  UserData({
    required this.region,
    required this.dateTime,
    required this.hijriMonth,
    required this.hijriYear,
    required this.dayName,
  });
}

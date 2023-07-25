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
import 'package:shared_preferences/shared_preferences.dart';
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
  String get region => _region;

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
      // Check if the user's region is already available in shared preferences
      String? userRegion = await getUserRegion();
      if (userRegion != null && userRegion.isNotEmpty) {
        // Region is available, skip showing the dialog and directly call getRegionAndShowContent
        getRegionAndShowContent(context);
      } else {
        // Region is not available, show the dialog
        Future.delayed(
          Duration.zero,
          () => getRegionAndShowContent(context),
        );
      }
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

  String getHijriMonthName(int month) {
    List<String> hijriMonthNames = [
      "Muharram",
      "Safar",
      "Rabi al-Awwal",
      "Rabi al-Thani",
      "Jumada al-Ula",
      "Jumada al-Thani",
      "Rajab",
      "Sha'ban",
      "Ramadan",
      "Shawwal",
      "Dhu al-Qi'dah",
      "Dhu al-Hijjah"
    ];

    if (month >= 1 && month <= 12) {
      return hijriMonthNames[month - 1];
    } else {
      return 'Unknown';
    }
  }

  Future<void> getRegionAndShowContent(BuildContext context) async {
    EasyLoadingDialog.show(context: context, radius: 20.r);

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
      ).timeout(const Duration(seconds: 15));

      List<Placemark> placeMarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placeMarks.isNotEmpty) {
        Placemark placeMark = placeMarks[0];
        _region = placeMark.administrativeArea ?? "";
        notifyListeners();

        // Get the current date/time in the desired format (dd/mm/yy HH:mm)
        String formattedDateTime =
            DateFormat('dd/MM/yy HH:mm').format(DateTime.now());

        notifyListeners();

        // Get the current Hijri month name
        String hijriMonthName = getHijriMonthName(HijriCalendar.now().hMonth);

        notifyListeners();

        // Now you have the region, date/time, and the Hijri month.
        // Save them to shared preferences
        await saveUserRegion(
          _region,
          formattedDateTime, // Convert DateTime to ISO 8601 format
          hijriMonthName,
        );
      }

      // Existing error handling code...
    } finally {
      EasyLoadingDialog.dismiss(context);
    }
  }

  // Method to save user's region, date/time, and Hijri month to shared preferences
  Future<void> saveUserRegion(
    String region,
    String dateTime,
    String hijriMonth,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_region', region);
    await prefs.setString('user_date_time', dateTime);
    await prefs.setString('user_hijri_month', hijriMonth);
    // Notify listeners after saving the data
    notifyListeners();
  }

  // Method to retrieve user's region from shared preferences
  Future<String?> getUserRegion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_region');
  }

  // Method to retrieve user's date/time from shared preferences
  Future<String?> getUserDateTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_date_time');
  }

  // Method to retrieve user's Hijri month from shared preferences
  Future<String?> getUserHijriMonth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_hijri_month');
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
}

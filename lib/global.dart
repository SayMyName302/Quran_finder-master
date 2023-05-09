import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'pages/settings/pages/notifications/notification_services.dart';
import 'shared/database/home_db.dart';
import 'shared/database/quran_db.dart';
import 'shared/hive_adopters/bookmark_adopter.dart';
import 'shared/hive_adopters/duration_adapter.dart';
import 'shared/hive_adopters/last_seen_adopter.dart';
import 'shared/hive_adopters/locale_adopter.dart';
import 'shared/hive_adopters/on_boarding_adopter.dart';
import 'shared/hive_adopters/user_profile_adopter.dart';
import 'shared/localization/localization_provider.dart';
import 'package:path_provider/path_provider.dart';

class Global {
  static init() async {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white,
      // statusBarColor: Colors.white
    ));
    await Firebase.initializeApp();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    Directory dir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(dir.path);
    Hive.registerAdapter(DurationAdapter());
    Hive.registerAdapter(LastSeenAdapter());
    Hive.registerAdapter(LocaleAdapter());
    Hive.registerAdapter(BookmarksAdapter());
    Hive.registerAdapter(UserProfileAdopter());
    Hive.registerAdapter(OnBoardingAdopter());
    await Hive.openBox('myBox');
    await ScreenUtil.ensureScreenSize();
    await QuranDatabase().initAndSaveDb();
    await HomeDb().initDb();
    await NotificationServices().init();
    HijriCalendar.setLocal(LocalizationProvider().locale.languageCode);
  }
}

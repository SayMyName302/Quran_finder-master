import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nour_al_quran/pages/paywall/paywal_provider.dart';
import 'global.dart';
import 'pages/home/home_provider.dart';
import 'pages/home/sections/basics_of_quran/islam_basics_provider.dart';
import 'pages/home/sections/player/story_player_provider.dart';
import 'pages/main/main_page_provider.dart';
import 'pages/more/pages/names_of_allah/names_provider.dart';
import 'pages/more/pages/qibla_direction/provider.dart';
import 'pages/more/pages/salah_timer/provider.dart';
import 'pages/more/pages/step_by_step_salah/salah_steps_provider.dart';
import 'pages/more/pages/tasbeeh/tasbeeh_provider.dart';
import 'pages/onboarding/on_boarding_provider.dart';
import 'pages/quran/pages/bookmarks/bookmarks_provider.dart';
import 'pages/quran/pages/duas/dua_provider.dart';
import 'pages/quran/pages/juz/juz_provider.dart';
import 'pages/quran/pages/recitation/reciter/player/player_provider.dart';
import 'pages/quran/pages/recitation/reciter/reciter_provider.dart';
import 'pages/quran/pages/recitation/recitation_provider.dart';
import 'pages/quran/pages/surah/surah_provider.dart';
import 'pages/quran/providers/quran_provider.dart';
import 'pages/settings/pages/app_colors/app_colors_provider.dart';
import 'pages/settings/pages/download_manager/download_manager_provider.dart';
import 'pages/settings/pages/fonts/font_provider.dart';

import 'pages/settings/pages/profile/profile_provider.dart';
import 'pages/settings/pages/translation_manager/translation_manager_provider.dart';
import 'pages/sign_in/sign_in_provider.dart';
import 'shared/localization/localization_constants.dart';
import 'shared/localization/localization_provider.dart';
import 'shared/localization/localization_demo.dart';
import 'shared/providers/download_provider.dart';
import 'pages/quran/pages/resume/last_seen_provider.dart';
import 'pages/settings/pages/app_them/them_provider.dart';
import 'shared/routes/routes_helper.dart';
import 'shared/utills/app_them.dart';
import 'shared/utills/dimensions.dart';
import 'package:provider/provider.dart';

import 'pages/home/sections/miracles_of_quran/miracles_of_quran_provider.dart';
import 'pages/home/sections/quran stories/quran_stories_provider.dart';

void main() async {
  await Global.init();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (_) => ThemProvider(),
    ),
    ChangeNotifierProvider(create: (_) => MainPageProvider()),
    ChangeNotifierProvider(create: (_) => QuranProvider()),
    ChangeNotifierProvider(create: (_) => TasbeehProvider()),
    ChangeNotifierProvider(create: (_) => LocalizationProvider()),
    ChangeNotifierProvider(
      create: (_) => ReciterProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => PremiumScreenProvider(),
    ),
    ChangeNotifierProvider(create: (_) => DownloadProvider()),
    ChangeNotifierProvider(create: (_) => PlayerProvider()),
    ChangeNotifierProvider(create: (_) => AppColorsProvider()),
    ChangeNotifierProvider(create: (_) => PrayerTimeProvider()),
    ChangeNotifierProvider(create: (_) => QiblaProvider()),
    ChangeNotifierProvider(
      create: (_) => LastSeenProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => BookmarkProvider(),
    ),
    ChangeNotifierProvider(create: (_) => SurahProvider()),
    ChangeNotifierProvider(create: (_) => JuzProvider()),
    ChangeNotifierProvider(
      create: (_) => DuaProvider(),
    ),
    ChangeNotifierProvider(create: (_) => RecitationProvider()),
    ChangeNotifierProvider(create: (_) => HomeProvider()),
    ChangeNotifierProvider(
      create: (_) => OnBoardingProvider(),
    ),
    ChangeNotifierProvider(create: (_) => FontProvider()),
    ChangeNotifierProvider(create: (_) => QuranStoriesProvider()),
    ChangeNotifierProvider(create: (_) => MiraclesOfQuranProvider()),
    ChangeNotifierProvider(
      create: (_) => TranslationManagerProvider(),
    ),
    ChangeNotifierProvider(create: (_) => DownloadManagerProvider()),
    ChangeNotifierProvider(create: (_) => SalahStepsProvider()),
    ChangeNotifierProvider(create: (_) => IslamBasicsProvider()),
    ChangeNotifierProvider(create: (_) => NamesProvider()),
    ChangeNotifierProvider(
      create: (_) => SignInProvider(),
    ),
    ChangeNotifierProvider(create: (_) => ProfileProvider()),
    ChangeNotifierProvider(create: (_) => StoryPlayerProvider())
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(Dimensions.width, Dimensions.height),
      builder: (BuildContext context, Widget? child) {
        return Consumer2<LocalizationProvider, ThemProvider>(
          builder: (context, value, dark, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              locale: value.locale,
              localizationsDelegates: [
                LocalizationDemo.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: supportedLocales,
              localeResolutionCallback: localeResolutionCallback,
              themeMode: dark.isDark ? ThemeMode.dark : ThemeMode.light,
              theme: AppThem.light,
              darkTheme: AppThem.dark,
              initialRoute: RouteHelper.initRoute,
              routes: RouteHelper.routes(context),
              // home: const TestingQuran(),
            );
          },
        );
      },
    );
  }
}


// bool localizationCalled = false;
// if (!localizationCalled) {
//   value.getLocal();
//   localizationCalled = true;
// }

// getLocal() async {
//   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//   return sharedPreferences.getString('languageCode') ?? "";
// }



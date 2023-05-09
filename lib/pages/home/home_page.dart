import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:hive/hive.dart';
import 'home_provider.dart';
import 'widgets/home_row_widget.dart';
import '../main/main_page_provider.dart';
import '../quran/pages/recitation/reciter/player/player_provider.dart';
import '../settings/pages/profile/profile_provider.dart';
import '../settings/pages/subscriptions/on_board/free_trial.dart';
import '../../shared/entities/last_seen.dart';
import '../settings/pages/app_colors/app_colors_provider.dart';
import '../../shared/localization/localization_constants.dart';
import '../settings/pages/app_them/them_provider.dart';
import '../../shared/localization/localization_provider.dart';
import '../../shared/routes/routes_helper.dart';
import '../../shared/utills/app_constants.dart';
import '../../shared/widgets/app_text_widgets.dart';
import '../../shared/widgets/circle_button.dart';
import '../../shared/widgets/dua_container.dart';
import '../quran/pages/resume/where_you_left_off_widget.dart';
import '../../shared/utills/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'sections/basics_of_quran/islam_basics.dart';
import 'sections/basics_of_quran/islam_basics_provider.dart';
import 'sections/miracles_of_quran/miracles.dart';
import 'sections/miracles_of_quran/miracles_of_quran_provider.dart';
import 'sections/quran stories/quran_stories.dart';
import 'sections/quran stories/quran_stories_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Duration time = Duration(seconds: Hive.box('myBox').get('seconds') ?? 0);
  LastSeen? lastSeen = Hive.box('myBox').get("lastSeen");

  @override
  void initState() {
    super.initState();
    context.read<QuranStoriesProvider>().getStories();
    context.read<MiraclesOfQuranProvider>().getMiracles();
    context.read<IslamBasicsProvider>().getIslamBasics();
    // Future.delayed(const Duration(seconds: 5),()=>showInAppPurchaseBottomSheet());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Consumer<LocalizationProvider>(
          builder: (context, language, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildHomeAndUserPictureContainer(context),
                time.inSeconds != 0
                    ? Container(
                        margin: EdgeInsets.only(
                            left: 20.w, right: 20.w, bottom: 8.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text14(
                                title: localeText(context, 'your_engagement')),
                            Consumer<ThemProvider>(
                              builder: (context, them, child) {
                                return DropdownButton(
                                  value: "Week",
                                  style: TextStyle(
                                      fontSize: 9.9.sp,
                                      fontFamily: 'satoshi',
                                      color: them.isDark
                                          ? AppColors.grey4
                                          : AppColors.grey2,
                                      fontWeight: FontWeight.w500),
                                  underline: const SizedBox.shrink(),
                                  iconSize: 20.h,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(7.4.r),
                                      bottomRight: Radius.circular(7.4.r),
                                      bottomLeft: Radius.circular(7.4.r)),
                                  items: const [
                                    DropdownMenuItem(
                                        value: 'Week', child: Text('Week')),
                                    DropdownMenuItem(
                                        value: 'Month', child: Text('Month')),
                                    DropdownMenuItem(
                                        value: 'Year', child: Text('Year')),
                                  ],
                                  onChanged: (value) {},
                                );
                              },
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
                time.inSeconds != 0
                    ? Container(
                        margin: EdgeInsets.only(
                            left: 20.w, right: 20.w, bottom: 14.h),
                        // height: 68.h,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.grey5,
                          ),
                          borderRadius: BorderRadius.circular(4.78.r),
                          // color: AppColors.lightBlue
                        ),
                        child: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  left: 6.76.w,
                                  top: 7.94.h,
                                  right: 9.71.w,
                                  bottom: 7.52.h),
                              height: 52.54.h,
                              width: 52.54.w,
                              decoration: BoxDecoration(
                                  color: AppColors.mainBrandingColor,
                                  borderRadius: BorderRadius.circular(4.r)),
                              child: Image.asset(
                                'assets/images/app_icons/page.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 12.h, bottom: 10.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        time.inSeconds >= 61 &&
                                                time.inMinutes <= 60
                                            ? '${time.inMinutes} ${localeText(context, 'minutes')}'
                                            : '${time.inHours} ${localeText(context, 'hour')}',
                                        style: TextStyle(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: "satoshi"),
                                      ),
                                      Container(
                                          margin: EdgeInsets.only(
                                              left: 4.w, right: 4.w, top: 3.h),
                                          child: CircleButton(
                                              height: 11.h,
                                              width: 11.w,
                                              icon: Icon(
                                                Icons.cloud,
                                                size: 5.w,
                                              ))),
                                      Container(
                                        margin: EdgeInsets.only(top: 3.h),
                                        child: Text(
                                          '21% ${localeText(context, 'from_last_week')}',
                                          style: TextStyle(
                                              fontFamily: 'satoshi',
                                              fontSize: 8.sp,
                                              color:
                                                  AppColors.mainBrandingColor),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 4.h,
                                  ),
                                  Text(
                                    localeText(context, 'lifetime'),
                                    style: TextStyle(
                                        fontSize: 8.sp,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "satoshi",
                                        color: AppColors.grey3),
                                  ),
                                  SizedBox(
                                    height: 1.h,
                                  ),
                                  Text(
                                    _formatDuration(time),
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      fontFamily: "satoshi",
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
                lastSeen != null
                    ? Container(
                        margin: EdgeInsets.only(
                            left: 20.w, bottom: 8.h, right: 20.w),
                        child: Text14(
                          title: localeText(
                              context, 'continue_where_you_left_off'),
                        ))
                    : const SizedBox.shrink(),
                lastSeen != null
                    ? const WhereULeftOffWidget()
                    : const SizedBox.shrink(),
                HomeRowWidget(
                  text: localeText(context, 'quran_stories'),
                  buttonText: localeText(context, "view_all"),
                  onTap: () {
                    context.read<MainPageProvider>().setCurrentPage(2);
                  },
                ),
                buildQuranStoriesList(language),
                buildVerseOfTheDayContainer(),
                HomeRowWidget(
                  text: localeText(context, 'quran_miracles'),
                  buttonText: localeText(context, "view_all"),
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(RouteHelper.miraclesOfQuran);
                  },
                ),
                buildMiraclesList(language),
                HomeRowWidget(
                  text: localeText(context, 'islam_basics'),
                  buttonText: localeText(context, "view_all"),
                  onTap: () {
                    Navigator.of(context).pushNamed(RouteHelper.basicsOfQuran);
                  },
                ),
                buildIslamBasicsList(language),
              ],
            );
          },
        ),
      ),
    );
  }

  Container buildHomeAndUserPictureContainer(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 17.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              margin: EdgeInsets.only(left: 20.w, top: 60.h, right: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text22(title: localeText(context, 'home')),
                  SizedBox(
                    height: 2.h,
                  ),
                  Consumer<AppColorsProvider>(
                    builder: (context, appColors, child) {
                      return Text(
                        HijriCalendar.now().toFormat("dd MMMM yyyy"),
                        style: TextStyle(
                            fontSize: 12.sp,
                            fontFamily: "satoshi",
                            color: appColors.mainBrandingColor),
                      );
                    },
                  ),
                ],
              )),
          InkWell(
            onTap: () {
              var loginStatus = Hive.box(appBoxKey).get(loginStatusString) ?? 0;
              Provider.of<ProfileProvider>(context, listen: false)
                  .setFromWhere("home");
              Navigator.of(context).pushNamed(loginStatus != 0
                  ? RouteHelper.manageProfile
                  : RouteHelper.signIn);
            },
            child: Container(
                margin: EdgeInsets.only(
                  top: 61.h,
                  right: 20.w,
                  left: 20.w,
                ),
                child: CircleButton(
                    height: 29.h,
                    width: 29.w,
                    icon: FirebaseAuth.instance.currentUser != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(30.r),
                            child: Consumer<ProfileProvider>(
                              builder: (context, profile, child) {
                                return profile.userProfile != null
                                    ? profile.userProfile!.image != ""
                                        ? CachedNetworkImage(
                                            imageUrl:
                                                profile.userProfile!.image!,
                                            progressIndicatorBuilder: (context,
                                                    url, downloadProgress) =>
                                                CircularProgressIndicator(
                                                    value: downloadProgress
                                                        .progress),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.person),
                                          )
                                        : CircleButton(
                                            height: 29.h,
                                            width: 29.w,
                                            icon: const Icon(Icons.person))
                                    : CircleButton(
                                        height: 29.h,
                                        width: 29.w,
                                        icon: const Icon(Icons.person));
                              },
                            ),
                          )
                        : Icon(
                            Icons.person,
                            size: 11.h,
                            color: Colors.white,
                          ))),
          ),
        ],
      ),
    );
  }

  Consumer<HomeProvider> buildVerseOfTheDayContainer() {
    return Consumer<HomeProvider>(
      builder: (context, value, child) {
        return Column(
          children: [
            HomeRowWidget(
              text: localeText(context, 'verse_of_the_day'),
              buttonText: localeText(context, 'share'),
              onTap: () {
                Share.share(
                    "${value.verseOfTheDay.verseText}\n               -- ${value.verseOfTheDay.surahId}:${value.verseOfTheDay.verseId} --                \nhttps://play.google.com/store/apps/details?id=com.fanzetech.holyquran");
              },
            ),
            DuaContainer(
              ref:
                  "${value.verseOfTheDay.surahId}:${value.verseOfTheDay.verseId}",
              text: value.verseOfTheDay.verseText,
              translation: value.verseOfTheDay.translationText,
            )
          ],
        );
      },
    );
  }

  SizedBox buildIslamBasicsList(LocalizationProvider language) {
    return SizedBox(
      height: 136.h,
      child: Consumer<IslamBasicsProvider>(
        builder: (context, islamBasicProvider, child) {
          return ListView.builder(
            itemCount: islamBasicProvider.islamBasics.length,
            padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 14.h),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              IslamBasics islamBasics = islamBasicProvider.islamBasics[index];
              return InkWell(
                onTap: () {
                  islamBasicProvider.checkAudioExist(
                      islamBasics.title!, context);
                  // islamBasicProvider.goToIslamTopicPage(index, context);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  margin: EdgeInsets.only(right: 10.w),
                  decoration: BoxDecoration(
                      color: Colors.amberAccent,
                      borderRadius: BorderRadius.circular(8.r),
                      image: DecorationImage(
                          image: AssetImage(islamBasics.image!),
                          fit: BoxFit.cover)),
                  child: Container(
                    margin: EdgeInsets.only(left: 6.w, bottom: 8.h, right: 6.w),
                    alignment: language.locale.languageCode == "ur" ||
                            language.locale.languageCode == "ar"
                        ? Alignment.bottomRight
                        : Alignment.bottomLeft,
                    child: Text(
                      localeText(context, islamBasics.title!),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.8.sp,
                          fontFamily: "satoshi",
                          fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  SizedBox buildMiraclesList(LocalizationProvider language) {
    return SizedBox(
      height: 136.h,
      child: Consumer<MiraclesOfQuranProvider>(
        builder: (context, miraclesProvider, child) {
          return ListView.builder(
            itemCount: miraclesProvider.miracles.length,
            padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 14.h),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              Miracles model = miraclesProvider.miracles[index];
              return InkWell(
                onTap: () {
                  print('outPut');
                  miraclesProvider.checkVideoAvailable(model.title!, context);
                  // miraclesProvider.goToMiracleDetailsPage(model.title!, context);
                },
                child: Container(
                  width: 287.w,
                  margin: EdgeInsets.only(right: 10.w),
                  decoration: BoxDecoration(
                      color: Colors.amberAccent,
                      borderRadius: BorderRadius.circular(8.r),
                      image: DecorationImage(
                          image: AssetImage('${model.image}'),
                          fit: BoxFit.cover)),
                  child: Container(
                    margin: EdgeInsets.only(left: 6.w, bottom: 8.h, right: 8.w),
                    alignment: language.locale.languageCode == "ur" ||
                            language.locale.languageCode == "ar"
                        ? Alignment.bottomRight
                        : Alignment.bottomLeft,
                    child: Text(
                      localeText(context, model.title!.toLowerCase()),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.8.sp,
                          fontFamily: "satoshi",
                          fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  SizedBox buildQuranStoriesList(LocalizationProvider language) {
    return SizedBox(
      height: 150.h,
      child: Consumer<QuranStoriesProvider>(
        builder: (context, storiesProvider, child) {
          return ListView.builder(
            itemCount: storiesProvider.stories.length,
            padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 14.h),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              QuranStories model = storiesProvider.stories[index];
              return InkWell(
                onTap: () {
                  Future.delayed(Duration.zero,
                      () => context.read<PlayerProvider>().pause());
                  storiesProvider.checkAudioExist(model.storyId!, context);
                  // storiesProvider.goToStoryDetailsPage(index,context);
                  // storiesProvider.goToChaptersListPage(model.storyId!, context,model.storyTitle!);
                },
                child: Container(
                  width: 209.w,
                  margin: EdgeInsets.only(right: 10.w),
                  decoration: BoxDecoration(
                      color: Colors.amberAccent,
                      borderRadius: BorderRadius.circular(8.r),
                      image: DecorationImage(
                          image: AssetImage(
                              "assets/images/quran_stories/${model.image!}"),
                          fit: BoxFit.cover)),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromRGBO(0, 0, 0, 0),
                          Color.fromRGBO(0, 0, 0, 1),
                        ],
                        begin: Alignment.center,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Container(
                      margin:
                          EdgeInsets.only(left: 6.w, bottom: 8.h, right: 6.w),
                      alignment: language.locale.languageCode == "ur" ||
                              language.locale.languageCode == "ar"
                          ? Alignment.bottomRight
                          : Alignment.bottomLeft,
                      child: Text(
                        localeText(context, model.storyTitle!),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.8.sp,
                            fontFamily: "satoshi",
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      final hours = duration.inHours - duration.inDays * 24;
      final minutes = duration.inMinutes - duration.inHours * 60;
      return '${duration.inDays}d${hours}h${minutes}m';
    } else if (duration.inSeconds <= 60) {
      return '${duration.inSeconds}s';
    } else if (duration.inSeconds >= 61 && duration.inMinutes <= 60) {
      return '${duration.inMinutes}m';
    } else {
      final hours = duration.inHours;
      final minutes = duration.inMinutes - duration.inHours * 60;
      return '${hours}h ${minutes}m';
    }
  }

  showInAppPurchaseBottomSheet() async {
    await showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (context) {
        return const FreeTrial();
      },
    );
  }
}

showProgressLoading(
    double downloaded, BuildContext context, bool isFromStory) async {
  await showDialog(
    context: context,
    useSafeArea: false,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.r)),
        content: Consumer2<QuranStoriesProvider, IslamBasicsProvider>(
          builder: (context, story, basics, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  alignment:
                      LocalizationProvider().locale.languageCode == "ur" ||
                              LocalizationProvider().locale.languageCode == "ar"
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(),
                      SizedBox(
                        width: 10.h,
                      ),
                      Text(localeText(context, "please_wait"))
                    ],
                  ),
                ),
                Text(
                    "${isFromStory ? story.downloaded.toInt().toString() : basics.downloaded.toInt().toString()}/100")
              ],
            );
          },
        ),
      );
    },
  );
}

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nour_al_quran/pages/quran/pages/juz/juz_Index_page.dart';
import 'package:nour_al_quran/pages/quran/pages/juz/juz_provider.dart';
import 'package:nour_al_quran/pages/quran/pages/recitation/reciter/player/player_provider.dart';
import 'package:nour_al_quran/pages/quran/pages/surah/lastreadprovider.dart';
import 'package:nour_al_quran/pages/quran/pages/surah/provider.dart';
import 'package:nour_al_quran/pages/quran/pages/surah/surah_provider.dart';

import 'package:nour_al_quran/pages/quran/widgets/search_widget.dart';
import 'package:nour_al_quran/pages/settings/pages/app_colors/app_colors_provider.dart';
import 'package:nour_al_quran/shared/entities/surah.dart';
import 'package:nour_al_quran/pages/quran/widgets/quran_text_view.dart';
import 'package:nour_al_quran/pages/quran/providers/quran_provider.dart';
import 'package:nour_al_quran/pages/quran/widgets/details_container_widget.dart';
import 'package:nour_al_quran/pages/quran/widgets/subtitle_text.dart';
import 'package:nour_al_quran/shared/localization/localization_constants.dart';
import 'package:nour_al_quran/shared/localization/localization_provider.dart';
import 'package:nour_al_quran/shared/utills/app_colors.dart';
import 'package:provider/provider.dart';

import '../../../../shared/database/quran_db.dart';

class SurahIndexPage extends StatefulWidget {
  const SurahIndexPage({Key? key}) : super(key: key);

  @override
  State<SurahIndexPage> createState() => _SurahIndexPageState();
}

class _SurahIndexPageState extends State<SurahIndexPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  var searchController = TextEditingController();
  bool _isSurahSelected = true;
  List<String> tappedSurahNames = [];
  var appColorsProvider = AppColorsProvider();

  var widgetsList = [];

  initWidgetList(){
    final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

    appColorsProvider = Provider.of<AppColorsProvider>(context,listen: false);
    tappedSurahNames = context.read<LastReadProvider>().tappedSurahNames;
    setState(() {
      widgetsList = [
        // Display the list of tapped surah names horizontally
        // Display the list of tapped surah names
        // Display the list of tapped surah names horizontally
        Consumer<AppColorsProvider>(builder: (context, value, child) {
          return Container(
            color: value.mainBrandingColor.withOpacity(0.15),
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 20.0, bottom: 5.0, top: 5),
              child: Text(
                localeText(
                  context,
                  'last_read',
                ),
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontFamily: 'satoshi',
                  fontSize: 13.sp,
                ),
              ),
            ),
          );
        }),
        Consumer<recentProvider>(builder: (context, surahValue, child) {
          if (tappedSurahNames.isEmpty) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: Text(
                  localeText(
                    context,
                    'no_last_read',
                  ), // Your desired message
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontFamily: 'satoshi',
                    fontSize: 13.sp,
                    color: AppColors.grey3,
                    // Your desir
                    //ed style
                  ),
                ),
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 20.0, bottom: 14.0, top: 10),
              child: SizedBox(
                height: 23.h, // Set the desired height constraint
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: tappedSurahNames.reversed.toSet().length > 3
                      ? 3
                      : tappedSurahNames.reversed.toSet().length,
                  itemBuilder: (context, index) {
                    final surahNamesSet = tappedSurahNames.reversed.toSet();
                    final surahName = surahNamesSet.elementAt(index);
                    return GestureDetector(
                      onTap: () async {
                        var surahList = await QuranDatabase().getSurahName();
                        int surahIndex = surahList.indexWhere(
                                (element) => element.surahName == surahName);
                        Surah surah = surahList[surahIndex];
                        context.read<QuranProvider>().setSurahText(
                            surahId: surah.surahId!,
                            title: 'سورة ${surah.arabicName}',
                            fromWhere: 1);
                        context
                            .read<LastReadProvider>()
                            .addTappedSurahName(surah.surahName!);

                        saveTappedSurahNames(context);
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) {
                            return const QuranTextView();
                          },
                        ));
                      },
                      child: Container(
                        height: 23.h,
                        padding: EdgeInsets.only(left: 9.w, right: 9.w),
                        margin: EdgeInsets.only(right: 7.w),
                        decoration: BoxDecoration(
                          color: AppColors.grey6,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Center(
                          child: Text(
                            surahName,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontFamily: 'satoshi',
                              fontSize: 15.sp,
                              color: AppColors.grey3,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          }
        }),
        const SizedBox(height: 10),
        Consumer<AppColorsProvider>(
            builder: (context, value, child) {
              return Container(
                color: value.mainBrandingColor.withOpacity(0.15),
                width: double.infinity,
                child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, bottom: 5.0, top: 5.0),
                    child: Text(
                      localeText(
                        context,
                        'quick_links',
                      ),
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontFamily: 'satoshi',
                        fontSize: 13.sp,
                      ),
                    )),
              );
            }),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Consumer<recentProvider>(
            builder: (context, surahValue, child) {
              // Modify the logic to display the specific surahs you want
              final additionalSurahNames = [
                'Al-Mulk',
                'Al-Baqara',
                'As-Sajda',
                'Yaseen',
                'Ar-Rahmaan',
                'Al-Waaqia',
                'Al-Kahf'
              ];

              return Container(
                height: 23.h,
                margin: EdgeInsets.only(bottom: 15.h),
                child: ListView.builder(
                  padding: EdgeInsets.only(left: 20.w, right: 20.w),
                  itemCount: additionalSurahNames.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final surahName = additionalSurahNames[index];

                    return GestureDetector(
                      onTap: () async {
                        var surahList = await QuranDatabase().getSurahName();
                        int surahIndex = surahList.indexWhere(
                                (element) => element.surahName == surahName);
                        Surah surah = surahList[surahIndex];
                        context.read<QuranProvider>().setSurahText(
                          surahId: surah.surahId!,
                          title: 'سورة ${surah.arabicName}',
                          fromWhere: 1,
                        );
                        tappedSurahNames.add(surah.surahName!);
                        context
                            .read<LastReadProvider>()
                            .addTappedSurahName(surah.surahName!);

                        saveTappedSurahNames(context);
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) {
                            return const QuranTextView();
                          },
                        ));
                        // Handle the onTap logic for additional surahs
                      },
                      child: Container(
                        height: 23.h,
                        padding: EdgeInsets.only(left: 9.w, right: 9.w),
                        margin: EdgeInsets.only(right: 7.w),
                        decoration: BoxDecoration(
                          color: AppColors.grey6,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Center(
                          child: Text(
                            surahName,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontFamily: 'satoshi',
                              fontSize: 15.sp,
                              color: AppColors.grey3,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
        // Custom Tab Bar
        Container(
          width: 170,
          child: TabBar(
            controller: _tabController,
            indicatorColor: appColorsProvider.mainBrandingColor,
            labelColor: appColorsProvider.mainBrandingColor,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(
                child: Text(
                  'Surah',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontFamily: 'satoshi',
                    fontSize: 13.sp, // Add font weight if needed
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Juzz',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontFamily: 'satoshi',
                    fontSize: 13.sp, // Add font weight if needed
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 10.0),
        Consumer<SurahProvider>(
          builder: (context, surahValue, child) {
            String subtitleTitle = _tabController.index == 0
                ? localeText(context, "surah_index")
                : localeText(context, "juz_index");

            return SubTitleText(title: subtitleTitle);
          },
        ),
        // SearchWidget(
        //   hintText: localeText(context, "search_surah_name"),
        //   searchController: searchController,
        //   onChange: (value) {
        //     context.read<SurahProvider>().searchSurah(value);
        //   },
        // ),
        _sizedBoxForSearchWidget(_tabController.index),
        IndexedStack(
          index: _tabController.index,
          children: [
            Consumer<SurahProvider>(
              builder: (context, surahValue, child) {
                return surahValue.surahNamesList.isNotEmpty
                    ? ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: surahValue.surahNamesList.length,
                  itemBuilder: (context, index) {
                    Surah surah = surahValue.surahNamesList[index];
                    return InkWell(
                      onTap: () async {
                        // to clear search field
                        searchController.text = "";
                        context.read<QuranProvider>().setSurahText(
                          surahId: surah.surahId!,
                          title: 'سورة ${surah.arabicName}',
                          fromWhere: 1,
                        );
                        Future.delayed(
                          Duration.zero,
                              () => context
                              .read<RecitationPlayerProvider>()
                              .pause(context),
                        );
                        tappedSurahNames.add(surah.surahName!);
                        context
                            .read<LastReadProvider>()
                            .addTappedSurahName(surah.surahName!);
                        saveTappedSurahNames(context);
                        analytics.logEvent(
                          name: 'read_quran_surah_index',
                          parameters: {
                            'Name': surah.surahName,
                            'index': surah.surahId
                          },
                        );
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) {
                            return const QuranTextView();
                          },
                        ));
                      },
                      child: DetailsContainerWidget1(
                        index: index + 1,
                        title: LocalizationProvider().checkIsArOrUr()
                            ? surah.arabicName!
                            : surah.surahName!,
                        subTitle: surah.englishName!,
                        icon: Icons.remove_red_eye_outlined,
                        imageIcon: "assets/images/app_icons/view.png",
                      ),
                    );
                  },
                )
                    : const Center(
                  child: Text('No Result Found'),
                );
              },
            ),
            const JuzIndexPage(), // Replace this with your implementation of JuzIndexPage
          ],
        ),
        const SizedBox(height: 50),
      ];
    });
  }
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    context.read<SurahProvider>().getSurahName();
    Future.delayed(Duration.zero,()=>initWidgetList());
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    appColorsProvider = Provider.of<AppColorsProvider>(context);
    tappedSurahNames = context.watch<LastReadProvider>().tappedSurahNames;
    loadTappedSurahNames(context);
    return ListView.builder(
        itemCount: widgetsList.length,
        itemBuilder: (context, index) {
          return widgetsList[index];
        },
    );
  }

  Widget _sizedBoxForSearchWidget(int tabIndex) {
    if (tabIndex == 0) {
      return SizedBox(
        height: 50.0, // Set the desired height for the search widget
        child: SearchWidget(
          hintText: localeText(context, "search_surah_name"),
          searchController: searchController,
          onChange: (value) {
            context.read<SurahProvider>().searchSurah(value);
          },
        ),
      );
    } else {
      return SizedBox(
        height: 50.0, // Set the desired height for the search widget
        child: SearchWidget(
          hintText: localeText(context, "search_juz_name"),
          searchController: searchController,
          onChange: (value) {
            context.read<JuzProvider>().searchJuz(value);
          },
        ),
      );
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nour_al_quran/pages/quran/pages/recitation/reciter/player/player_provider.dart';
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
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../shared/database/quran_db.dart';

class SurahIndexPage extends StatefulWidget {
  const SurahIndexPage({Key? key}) : super(key: key);

  @override
  State<SurahIndexPage> createState() => _SurahIndexPageState();
}

class _SurahIndexPageState extends State<SurahIndexPage> {
  var searchController = TextEditingController();
  List<String> tappedSurahNames = [];
  @override
  void initState() {
    super.initState();
    context.read<SurahProvider>().getSurahName();
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    loadTappedSurahNames();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Display the list of tapped surah names horizontally
        // Display the list of tapped surah names
        // Display the list of tapped surah names horizontally
        Consumer<AppColorsProvider>(builder: (context, value, child) {
          return Container(
            color: value.mainBrandingColor.withOpacity(0.15),
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 20.0, bottom: 14.0, top: 10),
              child: Text(
                'Last Read',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontFamily: 'satoshi',
                  fontSize: 15.sp,
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
                  'No last read', // Your desired message
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontFamily: 'satoshi',
                    fontSize: 15.sp,
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
              child: Container(
                height: 23.h, // Set the desired height constraint
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: tappedSurahNames.reversed.length > 3
                      ? 3
                      : tappedSurahNames.reversed.length,
                  itemBuilder: (context, index) {
                    final surahName =
                        tappedSurahNames.reversed.elementAt(index);
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

        Consumer<AppColorsProvider>(builder: (context, value, child) {
          return Container(
            color: value.mainBrandingColor.withOpacity(0.15),
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 20.0, bottom: 14.0, top: 10),
              child: Text(
                'Quick Links',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontFamily: 'satoshi',
                  fontSize: 15.sp,
                ),
              ),
            ),
          );
        }),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Consumer<recentProvider>(
            builder: (context, surahValue, child) {
              // Modify the logic to display the specific surahs you want
              final additionalSurahNames = [
                'Al-Baqara',
                'An-Nisaa',
                'Al-Faatiha',
                'Al-Kahf',
                'Yaseen'
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

        SubTitleText(title: localeText(context, "surah_index")),
        SearchWidget(
          hintText: localeText(context, "search_surah_name"),
          searchController: searchController,
          onChange: (value) {
            context.read<SurahProvider>().searchSurah(value);
          },
        ),
        Consumer<SurahProvider>(
          builder: (context, surahValue, child) {
            return surahValue.surahNamesList.isNotEmpty
                ? Expanded(
                    child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: ListView.builder(
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
                                  fromWhere: 1);
                              Future.delayed(
                                  Duration.zero,
                                  () => context
                                      .read<RecitationPlayerProvider>()
                                      .pause(context));
                              tappedSurahNames.add(surah.surahName!);
                              saveTappedSurahNames(); // Save tapped surah names
                              printTappedSurahNames();
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) {
                                  return const QuranTextView();
                                },
                              ));
                            },
                            child: DetailsContainerWidget(
                              title: LocalizationProvider().checkIsArOrUr()
                                  ? surah.arabicName!
                                  : surah.surahName!,
                              subTitle: surah.englishName!,
                              icon: Icons.remove_red_eye_outlined,
                              imageIcon: "assets/images/app_icons/view.png",
                            ),
                          );
                        },
                      ),
                    ),
                  )
                : const Expanded(
                    child: Center(
                    child: Text('No Result Found'),
                  ));
          },
        )
      ],
    );
  }

  Future<void> loadTappedSurahNames() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedNames = prefs.getStringList('tappedSurahNames');
    setState(() {
      tappedSurahNames =
          savedNames ?? []; // If savedNames is null, set an empty list
    });
  }

  Future<void> saveTappedSurahNames() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (tappedSurahNames.length > 10) {
      tappedSurahNames = tappedSurahNames.sublist(tappedSurahNames.length - 10);
    }

    await prefs.setStringList('tappedSurahNames', tappedSurahNames);
  }

  void printTappedSurahNames() {
    print('Tapped Surah Names: $tappedSurahNames');
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nour_al_quran/pages/onboarding/provider/on_boarding_provider.dart';
import 'package:nour_al_quran/pages/onboarding/widgets/skip_button.dart';
import 'package:nour_al_quran/pages/onboarding/widgets/on_boarding_text_widgets.dart';
import 'package:nour_al_quran/pages/quran/pages/recitation/recitation_provider.dart';
import 'package:nour_al_quran/pages/settings/pages/app_colors/app_colors_provider.dart';
import 'package:nour_al_quran/pages/settings/pages/app_them/them_provider.dart';
import 'package:nour_al_quran/shared/localization/localization_constants.dart';
import 'package:nour_al_quran/shared/routes/routes_helper.dart';
import 'package:nour_al_quran/shared/utills/app_colors.dart';
import 'package:nour_al_quran/shared/widgets/brand_button.dart';
import 'package:provider/provider.dart';

import '../../settings/pages/profile/profile_provider.dart';
import '../models/fav_reciter.dart';

class SetFavReciter extends StatefulWidget {
  const SetFavReciter({Key? key}) : super(key: key);

  @override
  State<SetFavReciter> createState() => _SetFavReciterState();
}

class _SetFavReciterState extends State<SetFavReciter> {
  @override
  void initState() {
    super.initState();
    context.read<RecitationProvider>().getAllReciters();
  }

  @override
  Widget build(BuildContext context) {
    var isDark = context.read<ThemProvider>().isDark;
    var appColors = context.read<AppColorsProvider>();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(
              left: 20.w,
              right: 20.w,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OnBoardingTitleText(
                    title: localeText(context,
                        "beautiful_recitations_from_around_the_world")),
                OnBoardingSubTitleText(
                    title: localeText(context, "set_your_favorite_reciter")),
                Consumer<OnBoardingProvider>(
                  builder: (context, setReciter, child) {
                    return MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      removeBottom: true,
                      child: ListView.builder(
                        itemCount: setReciter.reciterList.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          FavReciter reciter = setReciter.reciterList[index];
                          return InkWell(
                            onTap: () {
                              setReciter.setFavReciter(index);
                            },
                            child: _buildReciterNameContainer(
                                reciter, setReciter, isDark, appColors, index),
                          );
                        },
                      ),
                    );
                  },
                ),
                BrandButton(
                    text: localeText(context, "continue"),
                    onTap: () async {
                      var provider = Provider.of<OnBoardingProvider>(context,listen: false);
                      List<FavReciter> reciterList = provider.reciterList;
                      int index = reciterList.indexWhere((element) => element.title == provider.favReciter);
                      Provider.of<ProfileProvider>(context,listen: false).addReciterFavOrRemove(reciterList[index].reciterId!);
                      // Provider.of<RecitationProvider>(context,listen: false).addReciterFavOrRemove(reciterList[index].reciterId!);
                      // var selectedReciterIds = context.read<OnBoardingProvider>().reciterList.where((reciter) => reciter.title == context.read<OnBoardingProvider>().favReciter).map((reciter) => reciter.reciterId).toList();
                      // Assuming you have access to the DBHelper instance
                      // var dbHelper = QuranDatabase();

                      // Iterate over the selected reciter IDs and update the is_fav value
                      // for (var reciterId in selectedReciterIds) {
                        /// we will update this with hive

                        // await dbHelper.updateReciterIsFav(
                        //     reciterId!, 1); // Set the value to 1 for true
                      // }

                      // Navigator.of(context).pushNamed(RouteHelper.quranReminder);
                      Navigator.of(context).pushNamed(RouteHelper.notificationSetup);
                    }),
                SizedBox(
                  height: 16.h,
                ),
                SkipButton(onTap: () {
                  Navigator.of(context)
                      .pushNamed(RouteHelper.notificationSetup);
                  // Navigator.of(context).pushNamed(RouteHelper.quranReminder);
                })
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container _buildReciterNameContainer(
      FavReciter reciter,
      OnBoardingProvider setReciter,
      bool isDark,
      AppColorsProvider appColors,
      int index) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 15.h,
      ),
      padding:
          EdgeInsets.only(left: 10.w, right: 10.w, top: 15.h, bottom: 15.h),
      decoration: BoxDecoration(
          color: reciter.title == setReciter.favReciter
              ? isDark
                  ? AppColors.brandingDark
                  : AppColors.lightBrandingColor
              : Colors.transparent,
          border: Border.all(
              color: reciter.title == setReciter.favReciter
                  ? appColors.mainBrandingColor
                  : isDark
                      ? AppColors.grey3
                      : AppColors.grey5),
          borderRadius: BorderRadius.circular(6.r)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50.r),
            child: Image.asset(
              reciter.imageUrl ?? "",
              width: 48.w,
              height: 48.h,
              fit: BoxFit.cover,

              errorBuilder: (context, error, stackTrace) => const Icon(Icons
                  .error), // Display an error icon if the image fails to load
            ),
          ),
          Text(
            reciter.title!,
            style: TextStyle(
                fontFamily: 'satoshi',
                fontSize: 14.sp,
                fontWeight: FontWeight.w500),
          ),
          reciter.title == setReciter.favReciter
              ? Row(
                  children: [
                    reciter.isPlaying!
                        ? Image.asset(
                            "assets/images/app_icons/sound_waves.png",
                            height: 20.78.h,
                            width: 27.46.w,
                            color: isDark
                                ? Colors.white
                                : appColors.mainBrandingColor,
                          )
                        : InkWell(
                            onTap: () {
                              setReciter.setIsPlaying(index);
                            },
                            child: Image.asset(
                              "assets/images/app_icons/play_mainplayer.png",
                              height: 20.h,
                              width: 20.w,
                            )),
                    SizedBox(
                      width: 9.w,
                    ),
                  ],
                )
              : Row(
                  children: [
                    Image.asset(
                      "assets/images/app_icons/play_mainplayer.png",
                      height: 20.h,
                      width: 20.w,
                    ),
                  ],
                )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nour_al_quran/pages/onboarding/on_boarding_provider.dart';
import 'package:nour_al_quran/pages/onboarding/widgets/on_boarding_text_widgets.dart';
import 'package:nour_al_quran/pages/onboarding/widgets/skip_button.dart';
import 'package:nour_al_quran/pages/settings/pages/app_colors/app_colors_provider.dart';
import 'package:nour_al_quran/shared/localization/localization_constants.dart';
import 'package:nour_al_quran/shared/routes/routes_helper.dart';
import 'package:nour_al_quran/shared/widgets/brand_button.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import '../../../shared/utills/app_colors.dart';
import '../../settings/pages/app_them/them_provider.dart';
import '../models/app_download_count_provider.dart';

// ignore: must_be_immutable
class AchieveWithQuranPage extends StatelessWidget {
  
  AchieveWithQuranPage({Key? key}) : super(key: key);
  List<String> tagsList = [];
    
  @override
  Widget build(BuildContext context) {
   // List<String> tagsList = [];
    var appColors = context.read<AppColorsProvider>();
    var isDark = context.read<ThemProvider>().isDark;
    final downloadCountModel = Provider.of<DownloadCountModel>(context);
    downloadCountModel.initializePreferences();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(
              left: 20.w,
              right: 20.w,
            ),
            child: Consumer<OnBoardingProvider>(
              builder: (context, achieve, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OnBoardingTitleText(
                        title: localeText(context, "purpose_of_quran_app?")),
                    OnBoardingSubTitleText(
                        title: localeText(context,
                            "we_will_provide_custom_recommendations_to_fit_your_individual_goals")),
                    _buildGoalsText(appColors.mainBrandingColor, context),
                    _buildAchievementsList(context, achieve, isDark, appColors),
                    BrandButton(
                        text: localeText(context, "continue"),
                        onTap: () {
                          if (achieve.selectAchieveWithQuranList.length < 3) {
                            ScaffoldMessenger.of(context)
                              ..removeCurrentSnackBar()
                              ..showSnackBar(SnackBar(
                                  duration: const Duration(milliseconds: 500),
                                  content: Text(
                                    localeText(context,
                                        "please_select_at_least_three_goals"),
                                  )));
                          } else {
                            print("The tags list in final phase arev $tagsList");
                            OneSignal.shared.sendTags({'App Feature preference': tagsList});
                            //OneSignal.shared.sendTag("App Feature preference", tagsList);
                            Navigator.of(context).pushNamed(RouteHelper.setFavReciter);
                          }
                        }),
                    SizedBox(
                      height: 20.h,
                    ),
                    SkipButton(
                      onTap: () {
                        Navigator.of(context).pushNamed(RouteHelper.setFavReciter);
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  _buildAchievementsList(BuildContext context, OnBoardingProvider achieve,
      bool isDark, AppColorsProvider appColors) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      child: ListView.builder(
        itemCount: achieve.achieveWithQuranList.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          String achieveText = achieve.achieveWithQuranList[index];
          return InkWell(
            onTap: () {
              achieve.addAchieveItem(achieveText, index, context);
              if(index == 0)
              {
                OneSignal.shared.sendTag("App Feature preference", achieveText);
              }
              else if(index == 1)
              {
                OneSignal.shared.sendTag("App Feature preference 1", achieveText);
              }
              else if(index == 2)
              {
                OneSignal.shared.sendTag("App Feature preference 2", achieveText);
              }
              else if(index == 3)
              {
                OneSignal.shared.sendTag("App Feature preference 3", achieveText);
              }
              else if(index == 4)
              {
                OneSignal.shared.sendTag("App Feature preference 4", achieveText);
              }
              else if(index == 5)
              {
                OneSignal.shared.sendTag("App Feature preference 5", achieveText);
              }
              else
              {

              }
              
            },
            child: Container(
              margin: EdgeInsets.only(
                bottom: 15.h,
              ),
              padding: EdgeInsets.only(
                  left: 10.w, right: 10.w, top: 15.h, bottom: 15.h),
              decoration: BoxDecoration(
                  color:
                      achieve.selectAchieveWithQuranList.contains(achieveText)
                          ? isDark
                              ? AppColors.brandingDark
                              : AppColors.lightBrandingColor
                          : Colors.transparent,
                  border: Border.all(
                      color: achieve.selectAchieveWithQuranList
                              .contains(achieveText)
                          ? appColors.mainBrandingColor
                          : isDark
                              ? AppColors.grey3
                              : AppColors.grey5),
                  borderRadius: BorderRadius.circular(6.r)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    localeText(context, achieveText),
                    style: TextStyle(
                        fontFamily: 'satoshi',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500),
                  ),
                  Icon(
                    achieve.selectAchieveWithQuranList.contains(achieveText)
                        ? Icons.check_circle
                        : Icons.circle,
                    size: 23.h,
                    color:
                        achieve.selectAchieveWithQuranList.contains(achieveText)
                            ? isDark
                                ? Colors.white
                                : appColors.mainBrandingColor
                            : AppColors.grey5,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  _buildGoalsText(Color appColor, BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(
        bottom: 15.h,
      ),
      child: Text(
          localeText(
              context, "choose_upto_3_goals_for_precise_personalization"),
          style: TextStyle(
              fontWeight: FontWeight.w400,
              fontFamily: 'satoshi',
              fontSize: 12.sp,
              color: appColor)),
    );
  }
}

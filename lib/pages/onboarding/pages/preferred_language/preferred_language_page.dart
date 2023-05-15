import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import '../../on_boarding.dart';
import '../../on_boarding_provider.dart';
import '../../widgets/on_boarding_text_widgets.dart';
import '../../../settings/pages/app_colors/app_colors_provider.dart';
import '../../../settings/pages/app_them/them_provider.dart';
import '../../../../shared/localization/languages.dart';
import '../../../../shared/localization/localization_constants.dart';
import '../../../../shared/localization/localization_provider.dart';
import '../../../../shared/routes/routes_helper.dart';
import '../../../../shared/utills/app_colors.dart';
import '../../../../shared/utills/app_constants.dart';
import '../../../../shared/widgets/brand_button.dart';
import 'package:provider/provider.dart';

class SetPreferredLanguage extends StatelessWidget {
  const SetPreferredLanguage({Key? key}) : super(key: key);

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
            child: Consumer<LocalizationProvider>(
              builder: (context, localization, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OnBoardingTitleText(
                        title: localeText(
                            context, "choose_your_preferred_language")),
                    OnBoardingSubTitleText(
                        title: localeText(
                            context, "let's_personalize_the_app_experience")),
                    MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      removeBottom: true,
                      child: ListView.builder(
                        itemCount: Languages.languages.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          Languages lang = Languages.languages[index];
                          return InkWell(
                            onTap: () {
                              localization.setLocale(lang);
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                bottom: 10.h,
                              ),
                              padding: EdgeInsets.only(
                                  left: 10.w,
                                  right: 10.w,
                                  top: 15.h,
                                  bottom: 15.h),
                              decoration: BoxDecoration(
                                  color: localization.locale.languageCode ==
                                          lang.languageCode
                                      ? isDark
                                          ? AppColors.brandingDark
                                          : AppColors.lightBrandingColor
                                      : Colors.transparent,
                                  border: Border.all(
                                      color: localization.locale.languageCode ==
                                              lang.languageCode
                                          ? appColors.mainBrandingColor
                                          : isDark
                                              ? AppColors.grey3
                                              : AppColors.grey5),
                                  borderRadius: BorderRadius.circular(6.r)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    localeText(context, lang.name),
                                    style: TextStyle(
                                        fontFamily: 'satoshi',
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Icon(
                                    localization.locale.languageCode ==
                                            lang.languageCode
                                        ? Icons.check_circle
                                        : Icons.circle,
                                    size: 17.h,
                                    color: localization.locale.languageCode ==
                                            lang.languageCode
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
                    ),
                    SizedBox(
                      height: 6.h,
                    ),
                    BrandButton(
                        text: localeText(context, "continue"),
                        onTap: () {
                          saveOnBoarding(localization);
                          Navigator.of(context)
                              .pushNamed(RouteHelper.achieveWithQuran);
                        }),
                    SizedBox(
                      height: 20.h,
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

  void saveOnBoarding(LocalizationProvider localization) {
    OnBoardingProvider provider = OnBoardingProvider();
    OnBoardingInformation onBoardingInfo = OnBoardingInformation(
        purposeOfQuran: provider.selectAchieveWithQuranList,
        favReciter: provider.favReciter,
        whenToReciterQuran: provider.selectTimeLikeToRecite,
        recitationReminder: provider.recitationReminderTime,
        dailyQuranReadTime: provider.selectedDailyTime,
        preferredLanguage: localization.locale);
    Hive.box(appBoxKey).put(onBoardingInformationKey, onBoardingInfo);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../on_boarding_provider.dart';
import '../../widgets/on_boarding_text_widgets.dart';
import '../../widgets/skip_button.dart';
import '../../../settings/pages/app_colors/app_colors_provider.dart';
import '../../../settings/pages/app_them/them_provider.dart';
import '../../../../shared/localization/localization_constants.dart';
import '../../../../shared/routes/routes_helper.dart';
import '../../../../shared/utills/app_colors.dart';
import '../../../../shared/widgets/brand_button.dart';
import 'package:provider/provider.dart';

class AchieveWithQuranPage extends StatelessWidget {
  const AchieveWithQuranPage({Key? key}) : super(key: key);

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
                    title: localeText(context, "purpose_of_quran_app?")),
                OnBoardingSubTitleText(
                    title: localeText(context,
                        "we_will_provide_custom_recommendations_to_fit_your_individual_goals")),
                buildGoalsText(appColors.mainBrandingColor),
                Consumer<OnBoardingProvider>(
                  builder: (context, achieve, child) {
                    return buildListOfAchieve(
                        context, achieve, isDark, appColors);
                  },
                ),
                BrandButton(
                    text: localeText(context, "continue"),
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(RouteHelper.setFavReciter);
                    }),
                SizedBox(
                  height: 20.h,
                ),
                SkipButton(onTap: () {
                  Navigator.of(context).pushNamed(RouteHelper.setFavReciter);
                })
              ],
            ),
          ),
        ),
      ),
    );
  }

  MediaQuery buildListOfAchieve(BuildContext context,
      OnBoardingProvider achieve, bool isDark, AppColorsProvider appColors) {
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
              achieve.addAchieveItem(achieveText, index);
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

  Container buildGoalsText(Color appColor) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(
        bottom: 15.h,
      ),
      child: Text(
          localeText(RouteHelper.currentContext,
              "choose_upto_3_goals_for_precise_personalization"),
          style: TextStyle(
              fontWeight: FontWeight.w400,
              fontFamily: 'satoshi',
              fontSize: 12.sp,
              color: appColor)),
    );
  }

  Container buildSubTitleContainer(bool isDark) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 15.h,
      ),
      child: Text(
        "We will provide custom recommendations to fit your individual goals.",
        style: TextStyle(
            fontFamily: 'satoshi',
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.grey4 : AppColors.grey2),
      ),
    );
  }
}

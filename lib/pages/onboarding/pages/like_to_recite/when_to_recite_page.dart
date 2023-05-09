import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../on_boarding_provider.dart';
import '../../widgets/on_boarding_text_widgets.dart';
import '../../../settings/pages/app_colors/app_colors_provider.dart';
import '../../../settings/pages/app_them/them_provider.dart';
import '../../../../shared/localization/localization_constants.dart';
import '../../../../shared/routes/routes_helper.dart';
import '../../../../shared/utills/app_colors.dart';
import '../../../../shared/widgets/brand_button.dart';
import 'package:provider/provider.dart';

class WhenToRecite extends StatelessWidget {
  const WhenToRecite({Key? key}) : super(key: key);

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
                    title: localeText(context, "when_do_you_like_to_recite?")),
                Consumer<OnBoardingProvider>(
                  builder: (context, provider, child) {
                    return buildTimingList(
                        context, provider, isDark, appColors);
                  },
                ),
                SizedBox(
                  height: 6.h,
                ),
                BrandButton(
                    text: localeText(context, "continue"),
                    onTap: () {
                      String selectedTime = Provider.of<OnBoardingProvider>(
                              context,
                              listen: false)
                          .selectTimeLikeToRecite;
                      Navigator.of(context).pushNamed(RouteHelper.quranReminder,
                          arguments: selectedTime);
                      print(selectedTime);
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  MediaQuery buildTimingList(BuildContext context, OnBoardingProvider provider,
      bool isDark, AppColorsProvider appColors) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      child: ListView.builder(
        itemCount: provider.likeToRecite.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          String whenToRecite = provider.likeToRecite[index];
          return InkWell(
            onTap: () {
              provider.selectTimeToRecite(index);
            },
            child: Container(
              margin: EdgeInsets.only(
                bottom: 10.h,
              ),
              padding: EdgeInsets.only(
                  left: 10.w, right: 10.w, top: 15.h, bottom: 15.h),
              decoration: BoxDecoration(
                  color: whenToRecite == provider.selectTimeLikeToRecite
                      ? isDark
                          ? AppColors.brandingDark
                          : AppColors.lightBrandingColor
                      : Colors.transparent,
                  border: Border.all(
                      color: whenToRecite == provider.selectTimeLikeToRecite
                          ? appColors.mainBrandingColor
                          : isDark
                              ? AppColors.grey3
                              : AppColors.grey5),
                  borderRadius: BorderRadius.circular(6.r)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    localeText(context, whenToRecite),
                    style: TextStyle(
                        fontFamily: 'satoshi',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500),
                  ),
                  whenToRecite == provider.selectTimeLikeToRecite
                      ? Stack(children: [
                          Icon(
                            Icons.circle,
                            size: 17.h,
                            color: isDark
                                ? Colors.white
                                : appColors.mainBrandingColor,
                          ),
                          Positioned(
                              left: 0,
                              right: 0,
                              top: 0,
                              bottom: 0,
                              child: Icon(
                                Icons.circle,
                                size: 9.h,
                                color: isDark
                                    ? appColors.mainBrandingColor
                                    : Colors.white,
                              ))
                        ])
                      : Icon(
                          Icons.circle,
                          size: 17.h,
                          color: AppColors.grey5,
                        )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

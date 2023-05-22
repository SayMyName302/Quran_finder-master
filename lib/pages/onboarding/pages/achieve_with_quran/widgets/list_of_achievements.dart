import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nour_al_quran/pages/onboarding/on_boarding_provider.dart';
import 'package:nour_al_quran/pages/settings/pages/app_colors/app_colors_provider.dart';
import 'package:nour_al_quran/shared/localization/localization_constants.dart';
import 'package:nour_al_quran/shared/utills/app_colors.dart';
import 'package:provider/provider.dart';

import '../../../../settings/pages/app_them/them_provider.dart';

class ListOfAchievements extends StatelessWidget {
  const ListOfAchievements({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isDark = context.read<ThemProvider>().isDark;
    var appColors = context.read<AppColorsProvider>();
    return Consumer<OnBoardingProvider>(
        builder: (context, achieve,child) {
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
                  onTap: (){
                    achieve.addAchieveItem(achieveText, index,context);
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 15.h,),
                    padding: EdgeInsets.only(left: 10.w,right: 10.w,top: 15.h,bottom: 15.h),
                    decoration: BoxDecoration(
                        color: achieve.selectAchieveWithQuranList.contains(achieveText) ? isDark ? AppColors.brandingDark :AppColors.lightBrandingColor : Colors.transparent,
                        border: Border.all(color: achieve.selectAchieveWithQuranList.contains(achieveText) ? appColors.mainBrandingColor : isDark ? AppColors.grey3 : AppColors.grey5),
                        borderRadius: BorderRadius.circular(6.r)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(localeText(context, achieveText),style: TextStyle(
                            fontFamily: 'satoshi',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500
                        ),),
                        Icon(achieve.selectAchieveWithQuranList.contains(achieveText) ? Icons.check_circle : Icons.circle,size: 23.h,color: achieve.selectAchieveWithQuranList.contains(achieveText) ? isDark ? Colors.white :appColors.mainBrandingColor : AppColors.grey5,)
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
    );
  }
}

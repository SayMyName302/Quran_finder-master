import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nour_al_quran/pages/onboarding/on_boarding_provider.dart';
import 'package:nour_al_quran/pages/onboarding/pages/achieve_with_quran/widgets/list_of_achievements.dart';
import 'package:nour_al_quran/pages/onboarding/widgets/on_boarding_text_widgets.dart';
import 'package:nour_al_quran/pages/onboarding/widgets/skip_button.dart';
import 'package:nour_al_quran/pages/settings/pages/app_colors/app_colors_provider.dart';
import 'package:nour_al_quran/shared/localization/localization_constants.dart';
import 'package:nour_al_quran/shared/routes/routes_helper.dart';
import 'package:nour_al_quran/shared/widgets/brand_button.dart';
import 'package:provider/provider.dart';


class AchieveWithQuranPage extends StatelessWidget {
  const AchieveWithQuranPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appColors = context.read<AppColorsProvider>();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(left: 20.w,right: 20.w,),
            child: Consumer<OnBoardingProvider>(
              builder: (context, achieve, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OnBoardingTitleText(title: localeText(context,"purpose_of_quran_app?")),
                    OnBoardingSubTitleText(title: localeText(context,"we_will_provide_custom_recommendations_to_fit_your_individual_goals")),
                    buildGoalsText(appColors.mainBrandingColor,context),
                    const ListOfAchievements(),
                    BrandButton(text: localeText(context, "continue"), onTap: (){
                      if(achieve.selectAchieveWithQuranList.length < 3){
                        ScaffoldMessenger.of(context)
                          ..removeCurrentSnackBar()
                          ..showSnackBar(const SnackBar(content: Text("Please Select At Least Three Goals"),duration: Duration(milliseconds: 500),));
                      }else{
                        Navigator.of(context).pushNamed(RouteHelper.reviewOne);
                      }

                    }),
                    SizedBox(height: 20.h,),
                    SkipButton(onTap: (){Navigator.of(context).pushNamed(RouteHelper.reviewOne);})
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }


  Container buildGoalsText(Color appColor,BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(bottom: 15.h,),
      child: Text(
          localeText(context,"choose_upto_3_goals_for_precise_personalization"),
          style: TextStyle(
              fontWeight: FontWeight.w400,
              fontFamily: 'satoshi',
              fontSize: 12.sp,
              color: appColor
          )),
    );
  }
}

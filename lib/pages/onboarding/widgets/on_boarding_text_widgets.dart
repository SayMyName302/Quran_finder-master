import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nour_al_quran/pages/settings/pages/app_colors/app_colors_provider.dart';
import 'package:nour_al_quran/pages/settings/pages/app_them/them_provider.dart';
import 'package:nour_al_quran/shared/utills/app_colors.dart';
import 'package:provider/provider.dart';

class OnBoardingTitleText extends StatelessWidget {
  final String title;
  const OnBoardingTitleText({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.h, top: 25.h),
      child: Center(
        // Wrap with Center widget
        child: Text(
          title,
          textAlign:
              TextAlign.center, // Center align the text within the container
          style: TextStyle(
            fontFamily: "DM Sans",
            fontSize: 22.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class OnBoardingSubTitleText extends StatelessWidget {
  final String title;
  final TextAlign? textAlign;
  const OnBoardingSubTitleText(
      {Key? key, required this.title, this.textAlign = TextAlign.justify})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isDark = context.read<ThemProvider>().isDark;
    final appColorsProvider = Provider.of<AppColorsProvider>(context);
    return Container(
      margin: EdgeInsets.only(
        bottom: 15.h,
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
              fontFamily: 'DM Sans',
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: appColorsProvider.mainBrandingColor),
          textAlign: textAlign,
        ),
      ),
    );
  }
}

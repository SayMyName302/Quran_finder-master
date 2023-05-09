import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../pages/settings/pages/fonts/font_provider.dart';
import '../utills/app_colors.dart';
import 'package:provider/provider.dart';

class DuaContainer extends StatelessWidget {
  final String? text;
  final String? translation;
  final String? ref;
  const DuaContainer(
      {Key? key, this.text = "", this.translation = "", this.ref})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: AppColors.grey6,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(
          color: AppColors.grey5,
        ),
        // color: AppColors.grey5
      ),
      margin: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 10.h),
      padding: EdgeInsets.only(left: 22.w, right: 22.w, top: 17.h, bottom: 9.h),
      child: Consumer<FontProvider>(
        builder: (context, fontProvider, child) {
          return Column(
            children: [
              Text(
                text == ""
                    ? 'رَبَّنَا وَاجْعَلْنَا مُسْلِمَیْنِ لَكَ وَمِن ذُرِّیَّتِنَآ أُمَّةً مُّسْلِمَةً لَّكَ وَأَرِنَا مَنَاسِكَنَا وَتُبْ عَلَیْنَآ إِنَّكَ أَنتَ التَّوَّابُ الرَّحِیمُ'
                    : text!,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: fontProvider.fontSizeArabic.sp,
                    fontFamily: fontProvider.finalFont),
              ),
              SizedBox(
                height: 12.h,
              ),
              Text('$translation\n– $ref –',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: fontProvider.fontSizeTranslation.sp,
                      fontFamily: 'satoshi'))
            ],
          );
        },
      ),
    );
  }
}

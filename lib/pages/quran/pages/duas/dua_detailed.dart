import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:nour_al_quran/pages/quran/pages/duas/dua_categories_page.dart';
import 'package:nour_al_quran/pages/quran/pages/duas/dua_provider.dart';
import 'package:provider/provider.dart';
import '../../../../shared/localization/localization_constants.dart';
import '../../../../shared/utills/app_colors.dart';
import '../../../../shared/widgets/app_bar.dart';
import '../../../../shared/widgets/dua_container1.dart';
import '../../../settings/pages/app_colors/app_colors_provider.dart';
import '../../../settings/pages/fonts/font_provider.dart';
// import '../../providers/quran_provider.dart';

class DuaDetail extends StatelessWidget {
  const DuaDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List arguments = ModalRoute.of(context)!.settings.arguments! as List;
    String duaIndexNumber = arguments[0];
    String duaTitle = arguments[1];
    String duaRef = arguments[2];
    String sentenceCount = arguments[3];
    String duaText = arguments[4];
    String duaTranslation = arguments[5];
    //print('text? $duaText');

    return Scaffold(
      appBar: buildAppBar(context: context, title: localeText(context, "dua")),
      body: Consumer2<DuaProvider, AppColorsProvider>(
          builder: (context, duaProvider, appColors, child) {
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(height: 15.h),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(
                  left: 20.w,
                  right: 20.w,
                  bottom: 8.h,
                ),
                // decoration: BoxDecoration(
                //   // color: AppColors.grey6,
                //   borderRadius: BorderRadius.circular(6.r),
                //   border: Border.all(
                //     color: AppColors.grey5,
                //   ),
                // ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 10.w, right: 10.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // color: AppColors.grey2
                          Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 4, bottom: 4),
                                child: CircleAvatar(
                                  radius: 19,
                                  backgroundColor: appColors.mainBrandingColor,
                                  child: Container(
                                    width: 25,
                                    height: 25,
                                    alignment: Alignment.center,
                                    child: Text(
                                      duaIndexNumber,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 11, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10.h,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    capitalize(duaTitle),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12.sp,
                                      fontFamily: "satoshi",
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    child: Text(
                                      duaRef,
                                      style: TextStyle(
                                          fontSize: 10.sp,
                                          fontFamily: "satoshi",
                                          color: AppColors.grey4),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 50.h,
                              ),
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: Colors.grey[300],
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  alignment: Alignment.center,
                                  child: Text(
                                    sentenceCount,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 11, color: Colors.black),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              Consumer<FontProvider>(builder: (context, fontProvider, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 480,
                      child: DuaContainer1(
                        text: duaText,
                        translation: duaTranslation,
                        ref: duaRef,
                      ),
                    ),
                    // Container(
                    //   decoration: BoxDecoration(
                    //     // color: AppColors.grey6,
                    //     borderRadius: BorderRadius.circular(1.r),
                    //     border: Border.all(
                    //       color: AppColors.grey5,
                    //     ),
                    //   ),
                    //   margin: EdgeInsets.only(
                    //       left: 20.w, right: 20.w, bottom: 10.h),
                    //   padding: EdgeInsets.only(
                    //       left: 22.w, right: 22.w, top: 17.h, bottom: 9.h),
                    //   child: Text(
                    //     duaText,
                    //     style: TextStyle(
                    //       fontWeight: FontWeight.w700,
                    //       fontSize: fontProvider.fontSizeArabic.sp,
                    //       fontFamily: "satoshi",
                    //     ),
                    //   ),
                    // ),
                  ],
                );
              }),
            ],
          ),
        ]);
      }),
    );
  }

  String capitalize(String text) {
    if (text.isEmpty) {
      return text;
    }
    return text[0].toUpperCase() + text.substring(1);
  }
}

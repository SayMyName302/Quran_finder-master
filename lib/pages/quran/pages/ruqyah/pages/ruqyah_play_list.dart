import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../shared/utills/app_colors.dart';
import '../../../../../shared/localization/languages.dart';
import '../../../../../shared/localization/localization_constants.dart';
import '../../../../../shared/widgets/app_bar.dart';
import '../../../../settings/pages/app_colors/app_colors_provider.dart';
import '../models/ruqyah.dart';
import '../provider/ruqyah_provider.dart';

class RuqyahPlayList extends StatelessWidget {
  const RuqyahPlayList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
          context: context,
          font: 16.sp,
          title: localeText(context, "playlist_dua")),
      body: Consumer2<AppColorsProvider, RuqyahProvider>(
        builder: (context, appColors, duaProvider, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: duaProvider.duaList.length,
                  itemBuilder: (context, duacategoryID) {
                    Ruqyah dua = duaProvider.duaList[duacategoryID];
                    String duaCount = dua.ayahCount.toString();

                    //This code is to give margin to container if lang == ar or ur
                    String? languageCode;
                    String currentLanguage =
                        Localizations.localeOf(context).languageCode;
                    languageCode = Languages.languages
                        .firstWhere(
                          (language) =>
                              language.languageCode.toLowerCase() ==
                              currentLanguage.toLowerCase(),
                        )
                        .languageCode;
                    //Till here

                    return InkWell(
                      onTap: () {
                        //       duaProvider.gotoDuaPlayerPage(dua.id!, context);
                        Navigator.pop(context);
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                          left: 20.w,
                          right: 20.w,
                          bottom: 8.h,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6.r),
                          border: Border.all(
                            color: AppColors.grey5,
                          ),
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin:
                                    EdgeInsets.only(left: 10.w, right: 10.w),
                                padding:
                                    const EdgeInsets.only(top: 5, bottom: 5),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5, bottom: 5),
                                      child: CircleAvatar(
                                        radius: 17,
                                        backgroundColor:
                                            appColors.mainBrandingColor,
                                        child: Container(
                                          width: 25,
                                          height: 25,
                                          alignment: Alignment.center,
                                          child: Text(
                                            "${duacategoryID + 1}",
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 11,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10.h),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          child: Text(
                                            localeText(context,
                                                dua.duaTitle.toString()),
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 15.sp,
                                              fontFamily: "satoshi",
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        SizedBox(height: 2.h),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          child: Text(
                                            dua.duaRef.toString(),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              fontFamily: "satoshi",
                                              color: AppColors.grey4,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  right: 10.h,
                                  left: (languageCode == 'ur' ||
                                          languageCode == 'ar')
                                      ? 10.h
                                      : 0,
                                  top: 5.h,
                                  bottom: 5.h,
                                  // left: 10.w,
                                ),
                                child: CircleAvatar(
                                  radius: 16.h,
                                  backgroundColor: Colors.grey[300],
                                  child: Container(
                                    width: 21.h,
                                    height: 21.h,
                                    alignment: Alignment.center,
                                    child: Text(
                                      duaCount,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String capitalize(String text) {
    if (text.isEmpty) {
      return text;
    }
    return text[0].toUpperCase() + text.substring(1);
  }
}

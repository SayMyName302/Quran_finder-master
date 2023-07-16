import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nour_al_quran/pages/recitation_category/models/recitation_all_category_model.dart';
import 'package:nour_al_quran/pages/recitation_category/pages/recitation_all_player.dart';
import 'package:nour_al_quran/pages/recitation_category/provider/recitation_category_provider.dart';
import 'package:provider/provider.dart';
import '../../../../shared/localization/localization_constants.dart';
import '../../../../shared/providers/dua_audio_player_provider.dart';
import '../../../../shared/utills/app_colors.dart';
import '../../../../shared/widgets/app_bar.dart';
import '../../settings/pages/app_colors/app_colors_provider.dart';
import '../../settings/pages/fonts/font_provider.dart';

class RecitationAllDetailPlayer extends StatelessWidget {
  const RecitationAllDetailPlayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RecitationCategoryProvider recitationProvider = Provider.of<RecitationCategoryProvider>(context);
    Map<String, dynamic> nextRecitationData = recitationProvider.getNextDuaRecitation();

    int index = nextRecitationData['index'];
    RecitationAllCategoryModel nextRecitation = nextRecitationData['dua'];
    String duaTitle = nextRecitation.title.toString();
    String duaRef = nextRecitation.reference.toString();
    String duaText = nextRecitation.title.toString();
    String duaCount = nextRecitation.ayahCount.toString();
    //String duaTranslation = nextDua.translations.toString();

    return WillPopScope(
      onWillPop: () async {
        context.read<DuaPlayerProvider>().closePlayer();
        return true;
      },
      child: Scaffold(
        appBar:
        buildAppBar(context: context, title: localeText(context, "dua")),
        body: SingleChildScrollView(
          child:
          Consumer<AppColorsProvider>(builder: (context, appColors, child) {
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15.h),
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          left: 20.w,
                          right: 20.w,
                          bottom: 8.h,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 17.w),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
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
                                              '$index',
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.h,
                                      ),
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
                                                0.6,
                                            child: Text(
                                              capitalize(duaTitle),
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 15.sp,
                                                fontFamily: "satoshi",
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 2.h,
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width *
                                                0.6,
                                            child: Text(
                                              duaRef,
                                              style: TextStyle(
                                                  fontSize: 12.sp,
                                                  fontFamily: "satoshi",
                                                  color: AppColors.grey4),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                          right: 7.h,
                                          top: 5.h,
                                          bottom: 5.h,
                                          left: 10.w,
                                        ),
                                        child: CircleAvatar(
                                          radius: 17.h,
                                          backgroundColor: Colors.grey[300],
                                          child: Container(
                                            width: 21.h,
                                            height: 21.h,
                                            alignment: Alignment.center,
                                            child: Text(
                                              duaCount.toString(),
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
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
                      Consumer<FontProvider>(
                          builder: (context, fontProvider, child) {
                            return Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                      left: 20.w,
                                      right: 20.w,
                                    ),
                                    padding: EdgeInsets.only(
                                      left: 22.w,
                                      right: 22.w,
                                    ),
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      duaText,
                                      textDirection: TextDirection.rtl,
                                      //  textAlign: TextAlign.end,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: fontProvider.fontSizeArabic.sp,
                                        fontFamily: 'satoshi',
                                      ),
                                    ),
                                  ),
                                  // DuaContainer1(
                                  //   translation: duaTranslation,
                                  //   ref: duaRef,
                                  // ),
                                  const SizedBox(height: 7),
                                  Container(
                                    margin: EdgeInsets.only(
                                      left: 20.w,
                                      right: 20.w,
                                    ),
                                    padding: EdgeInsets.only(
                                      left: 22.w,
                                      right: 22.w,
                                    ),
                                    child: Text(
                                      "Translation",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize:
                                        fontProvider.fontSizeTranslation.sp,
                                        fontFamily: 'satoshi',
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 7),
                                  /*Container(
                                    margin: EdgeInsets.only(
                                      left: 20.w,
                                      right: 20.w,
                                    ),
                                    padding: EdgeInsets.only(
                                      left: 22.w,
                                      right: 22.w,
                                    ),
                                    child: Text(
                                      duaTranslation,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'satoshi',
                                        fontSize:
                                        fontProvider.fontSizeTranslation.sp,
                                      ),
                                    ),
                                  ),*/
                                  const SizedBox(height: 7),
                                  // const SizedBox(height: 7),
                                  // Container(
                                  //   margin: EdgeInsets.only(
                                  //     left: 20.w,
                                  //     right: 20.w,
                                  //   ),
                                  //   padding: EdgeInsets.only(
                                  //     left: 22.w,
                                  //     right: 22.w,
                                  //   ),
                                  //   child: Text(
                                  //     "Benefit",
                                  //     textAlign: TextAlign.start,
                                  //     style: TextStyle(
                                  //       fontWeight: FontWeight.w700,
                                  //       fontSize: 17.sp,
                                  //       fontFamily: fontProvider.finalFont,
                                  //     ),
                                  //   ),
                                  // ),
                                  // const SizedBox(height: 7),
                                  // Container(
                                  //   margin: EdgeInsets.only(
                                  //     left: 20.w,
                                  //     right: 20.w,
                                  //   ),
                                  //   padding: EdgeInsets.only(
                                  //     left: 22.w,
                                  //     right: 22.w,
                                  //   ),
                                  //   child: Text(
                                  //     duaTranslation,
                                  //     textAlign: TextAlign.start,
                                  //     style: TextStyle(
                                  //       fontWeight: FontWeight.w400,
                                  //       fontFamily: 'satoshi',
                                  //       fontSize:
                                  //           fontProvider.fontSizeTranslation.sp,
                                  //     ),
                                  //   ),
                                  // ),
                                  // const SizedBox(height: 7),
                                  Container(
                                    margin: EdgeInsets.only(
                                      left: 20.w,
                                      right: 20.w,
                                    ),
                                    padding: EdgeInsets.only(
                                      left: 22.w,
                                      right: 22.w,
                                    ),
                                    child: Text(
                                      "Reference",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize:
                                        fontProvider.fontSizeTranslation.sp,
                                        fontFamily: 'satoshi',
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 7),
                                  Container(
                                    margin: EdgeInsets.only(
                                      left: 20.w,
                                      right: 20.w,
                                    ),
                                    padding: EdgeInsets.only(
                                      left: 22.w,
                                      right: 22.w,
                                    ),
                                    child: Text(
                                      duaRef,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'satoshi',
                                        fontSize:
                                        fontProvider.fontSizeTranslation.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                    ],
                  ),
                ]);
          }),
        ),
        bottomNavigationBar: const SizedBox(
          height: 275,
          child: RecitationAllAudioPlayer(),
        ),
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

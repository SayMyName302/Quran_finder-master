import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nour_al_quran/pages/quran/pages/duas/dua_provider.dart';
import 'package:provider/provider.dart';
import '../../../../shared/localization/localization_constants.dart';
import '../../../../shared/providers/dua_audio_player_provider.dart';
import '../../../../shared/utills/app_colors.dart';
import '../../../../shared/widgets/app_bar.dart';
import '../../../../shared/widgets/dua_container1.dart';
import '../../../../shared/widgets/dua_player.dart';
import '../../../settings/pages/app_colors/app_colors_provider.dart';
import '../../../settings/pages/fonts/font_provider.dart';
import 'models/dua.dart';

class DuaDetail extends StatelessWidget {
  const DuaDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DuaProvider duaProvider = Provider.of<DuaProvider>(context);
    Map<String, dynamic> nextDuaData = duaProvider.getNextDua();

    int index = nextDuaData['index'];
    Dua nextDua = nextDuaData['dua'];
    String duaTitle = nextDua.duaTitle.toString();
    String duaRef = nextDua.duaRef.toString();
    String duaText = nextDua.duaText.toString();
    List<String> sentences = duaText.split('.');
    int sentenceCount = sentences.length;
    String duaTranslation = nextDua.translations.toString();

    return WillPopScope(
      onWillPop: () async {
        context.read<DuaPlayerProvider>().closePlayer();
        return true;
      },
      child: Scaffold(
        appBar:
            buildAppBar(context: context, title: localeText(context, "dua")),
        body: SingleChildScrollView(
          child: Consumer2<DuaProvider, AppColorsProvider>(
              builder: (context, duaProvider, appColors, child) {
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
                                  // color: AppColors.grey2
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
                                              'Dua ${index + 1}',
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.white),
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
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.6,
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
                                      Container(
                                        margin: EdgeInsets.only(
                                          right: 7.h,
                                          top: 5.h,
                                          bottom: 5.h,
                                          left: 10.w,
                                        ),
                                        child: CircleAvatar(
                                          radius: 16.h,
                                          backgroundColor: Colors.grey[300],
                                          child: Container(
                                            width: 21.h,
                                            height: 21.h,
                                            alignment: Alignment.center,
                                            child: Text(
                                              sentenceCount.toString(),
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontSize: 11,
                                                color: Colors.black,
                                              ),
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
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: fontProvider.fontSizeArabic.sp,
                                    fontFamily: fontProvider.finalFont,
                                  ),
                                ),
                              ),
                              DuaContainer1(
                                translation: duaTranslation,
                                ref: duaRef,
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
                                  "Translation",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 17.sp,
                                    fontFamily: fontProvider.finalFont,
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
                                  duaTranslation,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'satoshi',
                                    fontSize:
                                        fontProvider.fontSizeTranslation.sp,
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
                                  "Benefit",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 17.sp,
                                    fontFamily: fontProvider.finalFont,
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
                                  duaTranslation,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'satoshi',
                                    fontSize:
                                        fontProvider.fontSizeTranslation.sp,
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
                                  "Reference",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 17.sp,
                                    fontFamily: fontProvider.finalFont,
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
                                  duaTranslation,
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
          height: 200,
          child: DuaAudioPlayer(),
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

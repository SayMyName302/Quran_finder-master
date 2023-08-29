import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../../shared/localization/localization_constants.dart';
import '../../../../../shared/providers/dua_audio_player_provider.dart';
import '../../../../../shared/utills/app_colors.dart';
import '../../../../../shared/widgets/app_bar.dart';
import '../../../../../shared/widgets/dua_player.dart';
import '../../settings/pages/app_colors/app_colors_provider.dart';
import '../../settings/pages/app_them/them_provider.dart';
import '../../settings/pages/fonts/font_provider.dart';
import '../../settings/pages/profile/profile_provider.dart';
import '../provider/dua_provider.dart';
import '../models/dua.dart';
import '../models/dua_category.dart';

class DuaDetail extends StatelessWidget {
  const DuaDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DuaProvider duaProvider = Provider.of<DuaProvider>(context);
    Dua nextDua = duaProvider.selectedDua!;

    int index = nextDua.duaNo!;
    String duaTitle = nextDua.duaTitle.toString();
    String duaRef = nextDua.duaRef.toString();
    String duaText = nextDua.duaText.toString();

    String currentLanguage = Localizations.localeOf(context).languageCode;
    duaProvider.setCurrentLanguage(currentLanguage);
    String translations = duaProvider.getTranslatedDua(nextDua);

    return WillPopScope(
      onWillPop: () async {
        context.read<DuaPlayerProvider>().closePlayer();
        return true;
      },
      child: Scaffold(
        appBar:
            buildAppBar(context: context, title: localeText(context, "dua")),
        body: SingleChildScrollView(
          child: Consumer5<ThemProvider, DuaPlayerProvider, AppColorsProvider,
                  DuaProvider, ProfileProvider>(
              builder:
                  (context, them, player, appColor, duaProv, profile, child) {
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
                        // decoration: BoxDecoration(
                        //   borderRadius: BorderRadius.circular(6.r),
                        //   border: Border.all(
                        //     color: AppColors.brandingDark,
                        //   ),
                        // ),
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
                                              appColor.mainBrandingColor,
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
                                              localeText(
                                                  context, duaTitle.toString()),
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
                                      InkWell(
                                        onTap: () async {
                                          int duaIndex = duaProv.duaList
                                              .indexWhere((element) =>
                                                  element.duaText == duaText);
                                          Dua dua =
                                              duaProvider.duaList[duaIndex];
                                          profile.addOrRemoveDuaBookmark(dua);
                                        },
                                        child: Container(
                                          height: 20.h,
                                          width: 20.w,
                                          margin: EdgeInsets.only(
                                              bottom: 7.h, top: 8.h),
                                          child: CircleAvatar(
                                            backgroundColor:
                                                appColor.mainBrandingColor,
                                            child: SizedBox(
                                              height: 16.h,
                                              width: 16.w,
                                              child: CircleAvatar(
                                                backgroundColor:
                                                    appColor.mainBrandingColor,
                                                child: SizedBox(
                                                  height: 21.h,
                                                  width: 21.w,
                                                  child: CircleAvatar(
                                                    backgroundColor: profile
                                                            .userProfile!
                                                            .duaBookmarksList
                                                            .any((element) =>
                                                                element
                                                                    .duaText ==
                                                                duaText)
                                                        ? appColor
                                                            .mainBrandingColor
                                                        : Colors.white,
                                                    child: Icon(
                                                      Icons.favorite,
                                                      color: profile
                                                              .userProfile!
                                                              .duaBookmarksList
                                                              .any((element) =>
                                                                  element
                                                                      .duaText ==
                                                                  duaText)
                                                          ? Colors.white
                                                          : appColor
                                                              .mainBrandingColor,
                                                      size: 13.h,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
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
                                  right: 30.w,
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
                                    fontFamily: 'Scheherazade Font',
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
                                  localeText(context, "translation"),
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
                                  translations,
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
                                  localeText(context, "reference"),
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
          height: 128,
          child: DuaAudioPlayer(),
        ),
      ),
    );
  }

  String getCategoryNameById(int categoryId, List<DuaCategory> categoryList) {
    for (DuaCategory category in categoryList) {
      if (category.categoryId == categoryId) {
        return category.categoryName!;
      }
    }
    return '';
  }
}

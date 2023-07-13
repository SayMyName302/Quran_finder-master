import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../shared/entities/bookmarks_ruqyah.dart';
import '../../../../shared/localization/localization_constants.dart';
import '../../../../shared/providers/dua_audio_player_provider.dart';
import '../../../../shared/utills/app_colors.dart';
import '../../../../shared/widgets/app_bar.dart';
import '../../../../shared/widgets/ruqyah_player.dart';
import '../../../duas/widgets/ruqyah_bookmark_provider.dart';
import '../../../settings/pages/app_colors/app_colors_provider.dart';
import '../../../settings/pages/app_them/them_provider.dart';
import '../../../settings/pages/fonts/font_provider.dart';
import 'models/ruqyah.dart';
import 'models/ruqyah_category.dart';
import 'models/ruqyah_provider.dart';

class RuqyahDetail extends StatelessWidget {
  const RuqyahDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RuqyahProvider duaProvider = Provider.of<RuqyahProvider>(context);
    Map<String, dynamic> nextDuaData = duaProvider.getNextDua();

    int index = nextDuaData['index'];
    Ruqyah nextDua = nextDuaData['dua'];
    String duaTitle = nextDua.duaTitle.toString();
    String duaRef = nextDua.duaRef.toString();
    String duaText = nextDua.duaText.toString();

    int? duaCount = nextDua.ayahCount;
    String duaTranslation = nextDua.translations.toString();
    int? fav = nextDua.isFav;
    int favindex = index - 1;
    String duaUrl = nextDua.duaUrl.toString();

    return WillPopScope(
      onWillPop: () async {
        context.read<DuaPlayerProvider>().closePlayer();
        return true;
      },
      child: Scaffold(
        appBar:
            buildAppBar(context: context, title: localeText(context, "dua")),
        body: SingleChildScrollView(
          child: Consumer4<ThemProvider, DuaPlayerProvider, AppColorsProvider,
                  RuqyahProvider>(
              builder:
                  (context, them, player, appColor, ruqyahProvider, child) {
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
                                      // Container(
                                      //   margin: EdgeInsets.only(
                                      //     right: 7.h,
                                      //     top: 5.h,
                                      //     bottom: 5.h,
                                      //     left: 10.w,
                                      //   ),
                                      //   child: CircleAvatar(
                                      //     radius: 17.h,
                                      //     backgroundColor: Colors.grey[300],
                                      //     child: Container(
                                      //       width: 21.h,
                                      //       height: 21.h,
                                      //       alignment: Alignment.center,
                                      //       child: Text(
                                      //         duaCount.toString(),
                                      //         textAlign: TextAlign.center,
                                      //         style: const TextStyle(
                                      //             fontSize: 12,
                                      //             color: Colors.black,
                                      //             fontWeight: FontWeight.bold),
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),
                                      InkWell(
                                        onTap: () async {
                                          int duaIndex = ruqyahProvider.duaList
                                              .indexWhere((element) =>
                                                  element.duaText == duaText);
                                          int? categoryId = ruqyahProvider
                                              .duaList[duaIndex].duaCategory;
                                          String categoryName =
                                              getCategoryNameById(
                                                  categoryId!,
                                                  ruqyahProvider
                                                      .duaCategoryList);
                                          int indx = ruqyahProvider
                                              .duaList[duaIndex].id!;
                                          int duaNo = ruqyahProvider
                                              .duaList[duaIndex].duaNo!;

                                          if (fav == 0) {
                                            ruqyahProvider.bookmark(
                                                duaIndex, 1);
                                            BookmarksRuqyah bookmark =
                                                BookmarksRuqyah(
                                                    duaId: indx,
                                                    duaNo: duaNo,
                                                    categoryId: categoryId,
                                                    categoryName: categoryName,
                                                    duaTitle: duaTitle,
                                                    duaRef: duaRef,
                                                    ayahCount: duaCount,
                                                    duaText: duaText,
                                                    duaTranslation:
                                                        duaTranslation,
                                                    bookmarkPosition: favindex,
                                                    duaUrl: duaUrl);
                                            context
                                                .read<BookmarkProviderRuqyah>()
                                                .addBookmark(bookmark);
                                          } else {
                                            ruqyahProvider.bookmark(
                                                duaIndex, 0);
                                            context
                                                .read<BookmarkProviderRuqyah>()
                                                .removeBookmark(
                                                    ruqyahProvider
                                                        .duaList[duaIndex].id!,
                                                    ruqyahProvider
                                                        .duaList[duaIndex]
                                                        .duaCategory!);
                                          }
                                          // }
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
                                                    backgroundColor: fav == 1
                                                        ? appColor
                                                            .mainBrandingColor
                                                        : Colors.white,
                                                    child: Icon(
                                                      Icons.favorite,
                                                      color: fav == 1
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
                                  // textAlign: TextAlign.end,
                                  textDirection: TextDirection.rtl,
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
          child: RuqyahAudioPlayer(),
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

  String getCategoryNameById(
      int categoryId, List<RuqyahCategory> categoryList) {
    for (RuqyahCategory category in categoryList) {
      if (category.categoryId == categoryId) {
        return category.categoryName!;
      }
    }
    return ''; // Return an empty string or handle the case when category is not found
  }
}

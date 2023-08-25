import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nour_al_quran/pages/recitation_category/models/recitation_all_category_model.dart';
import 'package:nour_al_quran/pages/settings/pages/app_colors/app_colors_provider.dart';
import 'package:nour_al_quran/shared/utills/app_colors.dart';
import 'package:nour_al_quran/shared/widgets/title_text.dart';
import 'package:provider/provider.dart';
import '../../../shared/localization/localization_constants.dart';
import '../../../shared/localization/localization_provider.dart';
import '../../../shared/routes/routes_helper.dart';
import '../provider/recitation_category_provider.dart';

class RecitationAllCategory extends StatelessWidget {
  const RecitationAllCategory({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // List arguments = ModalRoute.of(context)!.settings.arguments! as List;
    // String title = arguments[0];
    // String imageURl = arguments[1];
    // String collectionOfDua = arguments[2];
    //Split Collection
    // List<String> splitText = collectionOfDua.split(' ');
    // String duaCount = splitText[0];
    // String duasText = splitText.sublist(1).join(' ');
    final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

    return Scaffold(
      body: SafeArea(
        child: Consumer2<AppColorsProvider, RecitationCategoryProvider>(
          builder: (context, appColors, recitationProvider, child) {
            String collectionOfDua = LocalizationProvider().checkIsArOrUr()

                /// "{model.numberOfPrayers!} is change to numbers of surah as there is no column with number of prayer name
                ? "${recitationProvider.selectedRecitationCategory!.numberOfSurahs!}${localeText(context, 'duas')} ${localeText(context, 'collection_of')} "
                : "${localeText(context, 'playlist_of')} ${recitationProvider.selectedRecitationCategory!.numberOfSurahs!} ${localeText(context, 'duas')}";
            //Split Collection
            List<String> splitText = collectionOfDua.split(' ');
            String duaCount = splitText[0];
            String duasText = splitText.sublist(1).join(' ');
            final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.arrow_back_outlined),
                  padding: EdgeInsets.only(
                      left: 20.w, top: 13.41.h, bottom: 21.4.h, right: 20.w),
                  alignment: Alignment.topLeft,
                ),
                Container(
                  margin:
                      EdgeInsets.only(bottom: 18.h, left: 20.w, right: 20.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 110.h,
                        width: 120.w,
                        decoration: BoxDecoration(
                          color: Colors.amberAccent,
                          borderRadius: BorderRadius.circular(22),
                          image: DecorationImage(
                            image: NetworkImage(recitationProvider
                                .selectedRecitationCategory!.imageURl!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(top: 19.4.h, bottom: 18.h),
                          padding: EdgeInsets.only(
                              left: 17.w, top: 13.41.h, right: 20.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TitleText(
                                title: localeText(
                                    context,
                                    recitationProvider
                                        .selectedRecitationCategory!
                                        .playlistName!),
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 17.sp,
                                  fontFamily: "satoshi",
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 7.h),
                                child: RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14.sp,
                                      fontFamily: "satoshi",
                                      color: AppColors.darkColor,
                                    ),
                                    children: [
                                      TextSpan(text: duaCount),
                                      const TextSpan(text: ' '),
                                      TextSpan(
                                        text: duasText,
                                        style: TextStyle(
                                            color: appColors.mainBrandingColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: recitationProvider.selectedRecitationAll.isEmpty
                      ? const Center(
                          child: Text(
                            'Coming Soon',
                            style: TextStyle(fontSize: 18),
                          ),
                        )
                      : ListView.builder(
                          itemCount:
                              recitationProvider.selectedRecitationAll.length,
                          itemBuilder: (context, index) {
                            RecitationAllCategoryModel recitationModels =
                                recitationProvider.selectedRecitationAll[index];
                            String title = recitationModels.title!;
                            RecitationWithShortname recitationWithShortname =
                                recitationProvider
                                    .recitationsWithShortnames[index];
                            RecitationWithLongname recitationWithLongname =
                                recitationProvider
                                    .recitationsWithLongnames[index];

                            String reciterShortname =
                                recitationWithShortname.reciterShortname ?? '';
                            String reciterFullname =
                                recitationWithLongname.reciterFullname ?? '';

                            RecitationWithSurahname recitationWithSurahname =
                                recitationProvider
                                    .recitationsWithSurahnames[index];

                            String reciterSurahname =
                                recitationWithSurahname.surahFullname ?? '';

                            return InkWell(
                              onTap: () {
                                recitationProvider
                                    .gotoRecitationAudioPlayerPage(
                                  recitationModels,
                                  recitationProvider
                                      .selectedRecitationCategory!.imageURl!,
                                  context,
                                );
                                Navigator.of(context).pushNamed(
                                    RouteHelper.recitationAudioPlayer,
                                    arguments: [
                                      // title,
                                      reciterFullname,
                                      reciterSurahname
                                    ]);
                                analytics.logEvent(
                                  name: 'recitation_category_listview',
                                  parameters: {
                                    'index': index + 1,
                                    'Name': recitationModels.title.toString()
                                  },
                                );
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: 10.w, right: 10.w),
                                      padding: const EdgeInsets.only(
                                          top: 5, bottom: 5),
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
                                                  recitationModels.surahNo
                                                      .toString(),
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10.h),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                reciterShortname,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 15.sp,
                                                  fontFamily: "satoshi",
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(height: 2.h),
                                              Text(
                                                "Surah " + reciterSurahname,
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  fontFamily: "satoshi",
                                                  color: AppColors.grey4,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                        right: 10.h,
                                        top: 5.h,
                                        bottom: 5.h,
                                      ),
                                      child: CircleAvatar(
                                        radius: 17.h,
                                        backgroundColor: Colors.grey[300],
                                        child: Container(
                                          width: 21.h,
                                          height: 21.h,
                                          alignment: Alignment.center,
                                          child: Text(
                                            recitationModels.ayahCount
                                                .toString(),
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
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          },
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

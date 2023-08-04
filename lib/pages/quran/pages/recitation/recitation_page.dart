import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nour_al_quran/pages/home/widgets/home_row_widget.dart';
import 'package:nour_al_quran/pages/quran/pages/recitation/provider.dart';
import 'package:nour_al_quran/pages/quran/pages/recitation/reciter/player/player_provider.dart';

import 'package:nour_al_quran/pages/quran/pages/recitation/reciter/reciter_provider.dart';
import 'package:nour_al_quran/pages/quran/pages/recitation/recitation_provider.dart';
import 'package:nour_al_quran/pages/recitation_category/models/RecitationCategory.dart';

import 'package:nour_al_quran/pages/settings/pages/app_colors/app_colors_provider.dart';
import 'package:nour_al_quran/pages/tranquil_tales/models/TranquilCategory.dart';

import 'package:nour_al_quran/pages/tranquil_tales/provider/tranquil_tales_provider.dart';

import 'package:nour_al_quran/shared/entities/reciters.dart';
import 'package:nour_al_quran/pages/quran/widgets/subtitle_text.dart';
import 'package:nour_al_quran/shared/localization/localization_constants.dart';
import 'package:nour_al_quran/shared/localization/localization_provider.dart';
import 'package:nour_al_quran/shared/routes/routes_helper.dart';
import 'package:nour_al_quran/shared/utills/app_colors.dart';
import 'package:provider/provider.dart';

import '../../../recitation_category/models/bookmarks_recitation.dart';
import '../../../recitation_category/provider/recitation_category_provider.dart';
import '../../../settings/pages/profile/profile_provider.dart';
import '../../widgets/details_container_widget.dart';

class RecitationPage extends StatefulWidget {
  const RecitationPage({Key? key}) : super(key: key);

  @override
  _RecitationPageState createState() => _RecitationPageState();
}

class _RecitationPageState extends State<RecitationPage> {
  @override
  void initState() {
    super.initState();
    context.read<RecitationProvider>().getRecommendedReciters();
    context.read<RecitationProvider>().getPopularReciters();
    // context.read<RecitationProvider>().getFavReciter();
  }

  _addLastViewedRecitations(String type, dynamic model) {
    /// add last viewed recitation
    var recitationTypeMap = {"type": type, "value": model};
    Provider.of<RecitationProvider>(context, listen: false)
        .addTappedRecitationList(recitationTypeMap);
  }

  void navigateToReciterScreen(BuildContext context,
      RecitationProvider recitersValue, Reciters reciter) async {
    recitersValue.getSurahName();
    context
        .read<ReciterProvider>()
        .getAvailableDownloadAudiosAsListOfInt(reciter.reciterName!);
    // updateTappedSurahNames(reciter.reciterName!);
    Navigator.of(context).pushNamed(
      RouteHelper.reciter,
      arguments: reciter,
    );
    // tappedReciterNames.add(reciter.reciterName!);
    context
        .read<recentProviderRecitation>()
        .addTappedReciterName(reciter.reciterName!);
  }

  void navigateToRecitationCategory(RecitationCategoryModel model) {
    Future.delayed(
      Duration.zero,
      () => context.read<RecitationPlayerProvider>().pause(context),
    );
    Provider.of<RecitationCategoryProvider>(context, listen: false)
        .getSelectedRecitationAll(model.playlistId as int);
    Navigator.of(context).pushNamed(
      RouteHelper.recitationallcategory,
      arguments: [
        localeText(context, model.playlistName!),
        model.imageURl!,
        LocalizationProvider().checkIsArOrUr()
            ? "${model.numberOfSurahs!} ${localeText(context, 'duas')} ${localeText(context, 'collection_of')} "
            : "${localeText(context, 'playlist_of')} ${model.numberOfSurahs!} ${localeText(context, 'duas')}",
        model.playlistId!,
      ],
    );

    /// add last viewed recitation
    _addLastViewedRecitations("recitationCategory", model);
  }

  void navigateToTranquilTalesCategory(TranquilTalesCategoryModel model) {
    Future.delayed(
      Duration.zero,
      () => context.read<RecitationPlayerProvider>().pause(context),
    );
    Provider.of<TranquilCategoryProvider>(context, listen: false)
        .getSelectedRecitationAll(model.categoryId as int);
    Navigator.of(context).pushNamed(
      RouteHelper.tranquil_tales,
      arguments: [
        localeText(context, model.categoryName!),
        model.imageURl!,
        LocalizationProvider().checkIsArOrUr()
            ? "${model.numberOfPrayers!} ${localeText(context, 'duas')} ${localeText(context, 'collection_of')} "
            : "${localeText(context, 'playlist_of')} ${model.numberOfPrayers!} ${localeText(context, 'duas')}",
        model.categoryId!,
      ],
    );
    _addLastViewedRecitations("tranquilTalesCategory", model);
  }

  @override
  Widget build(BuildContext context) {
    var appColor = context.read<AppColorsProvider>().mainBrandingColor;
    final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    // loadTappedSurahNames();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: appColor.withOpacity(0.15),
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, right: 20.0, bottom: 5.0, top: 5),
                child: Text(
                  localeText(
                    context,
                    'last_viewed',
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontFamily: 'satoshi',
                    fontSize: 13.sp,
                  ),
                ),
              ),
            ),
            Consumer<RecitationProvider>(
              builder: (context, recitationProvider, child) {
                if (recitationProvider.tappedRecitationList.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Center(
                      child: Text(
                        localeText(
                          context,
                          'no_last_tapped_reciters',
                        ), // Your desired message
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontFamily: 'satoshi',
                          fontSize: 13.sp,
                          color: AppColors.grey3,
                          // Your desired style
                        ),
                      ),
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, bottom: 14.0, top: 10),
                    child: SizedBox(
                      height: 23.h,

                      /// Set the desired height constraint
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount:
                            recitationProvider.tappedRecitationList.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> map =
                              recitationProvider.tappedRecitationList[index];
                          String title = "";
                          if (map['value'] is Reciters) {
                            Reciters reciter = map['value'];
                            title = reciter.reciterName!;
                          } else if (map['value'] is RecitationCategoryModel) {
                            RecitationCategoryModel recitationCategoryModel =
                                map['value'];
                            title = localeText(
                                context, recitationCategoryModel.playlistName!);
                          } else if (map['value']
                              is TranquilTalesCategoryModel) {
                            TranquilTalesCategoryModel
                                tranquilTalesCategoryModel = map['value'];
                            title = localeText(context,
                                tranquilTalesCategoryModel.categoryName!);
                          }
                          return InkWell(
                            onTap: () {
                              if (map['value'] is Reciters) {
                                navigateToReciterScreen(
                                    context, recitationProvider, map['value']);
                              } else if (map['value']
                                  is RecitationCategoryModel) {
                                navigateToRecitationCategory(map['value']);
                              } else if (map['value']
                                  is TranquilTalesCategoryModel) {
                                navigateToTranquilTalesCategory(map['value']);
                              }
                            },
                            child: Container(
                              height: 23.h,
                              padding: const EdgeInsets.only(left: 9, right: 9),
                              margin: const EdgeInsets.only(right: 7),
                              decoration: BoxDecoration(
                                color: AppColors.grey6,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  title,
                                  // Use the appropriate property of the Reciters class
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'satoshi',
                                    fontSize: 15,
                                    color: AppColors.grey3,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }
              },
            ),
            Column(
              children: [
                HomeRowWidget(
                  text: localeText(context, 'Recitation_Category'),
                  buttonText: localeText(context, "view_all"),
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(RouteHelper.recitationPageList);
                    analytics.logEvent(
                      name: 'recitation_all_button',
                    );
                  },
                ),
                Consumer2<LocalizationProvider, RecitationCategoryProvider>(
                  builder: (context, language, recitationProvider, child) {
                    return SizedBox(
                      height: 150.h,
                      child: ListView.builder(
                        itemCount: recitationProvider.recitationCategory.length,
                        padding: EdgeInsets.only(
                            left: 20.w, right: 20.w, bottom: 14.h),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          try {
                            RecitationCategoryModel model =
                                recitationProvider.recitationCategory[index];
                            print(model.playlistName);
                            print(model.imageURl);
                            return InkWell(
                              onTap: () {
                                Future.delayed(
                                  Duration.zero,
                                  () => context
                                      .read<RecitationPlayerProvider>()
                                      .pause(context),
                                );
                                recitationProvider.getSelectedRecitationAll(
                                    model.playlistId!);
                                analytics.logEvent(
                                  name: 'recitation_section',
                                  parameters: {
                                    'title': model.playlistName.toString()
                                  },
                                );
                                _addLastViewedRecitations(
                                    "recitationCategory", model);
                                // updateTappedSurahNames(model.categoryName!);
                                Navigator.of(context).pushNamed(
                                  RouteHelper.recitationallcategory,
                                  arguments: [
                                    localeText(context, model.playlistName!),
                                    model.imageURl!,
                                    LocalizationProvider().checkIsArOrUr()
                                        ? "${model.numberOfSurahs!} ${localeText(context, 'duas')} ${localeText(context, 'collection_of')} "
                                        : "${localeText(context, 'playlist_of')} ${model.numberOfSurahs!} ${localeText(context, 'duas')}",
                                    model.playlistId!,
                                  ],
                                );
                                String categoryNames =
                                    model.playlistName!.replaceAll('_', ' ');
                                //   tappedRecitationNames.add(model.categoryName!);
                                context
                                    .read<recentProviderRecitation>()
                                    .addTappedReciterName(categoryNames!);
                              },
                              child: Container(
                                width: 209.w,
                                margin: EdgeInsets.only(right: 10.w),
                                decoration: BoxDecoration(
                                  color: Colors.amberAccent,
                                  borderRadius: BorderRadius.circular(8.r),
                                  image: DecorationImage(
                                    image: CachedNetworkImageProvider(
                                        model.imageURl!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.r),
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color.fromRGBO(0, 0, 0, 0),
                                        Color.fromRGBO(0, 0, 0, 1),
                                      ],
                                      begin: Alignment.center,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        left: 6.w, bottom: 8.h, right: 6.w),
                                    alignment: language.checkIsArOrUr()
                                        ? Alignment.bottomRight
                                        : Alignment.bottomLeft,
                                    child: Text(
                                      localeText(context, model.playlistName!),
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 17.sp,
                                          fontFamily: "satoshi",
                                          fontWeight: FontWeight.w900),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          } catch (error) {
                            print("Error: $error");

                            return Container(); // Placeholder for error handling
                          }
                        },
                      ),
                    );
                  },
                )
              ],
            ),

            SizedBox(height: 15.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SubTitleText(title: localeText(context, "popular_reciter")),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(RouteHelper.allReciters);
                    analytics.logEvent(
                      name: 'reciters_section_viewall_button',
                      parameters: {'title': 'reciters_viewall'},
                    );
                  },
                  child: Container(
                    margin:
                        EdgeInsets.only(bottom: 10.h, right: 20.w, left: 20.w),
                    child: Text(
                      localeText(context, "view_all"),
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w900,
                          color: appColor),
                    ),
                  ),
                ),
              ],
            ),

            // const RecitationCategorySection(),
            Consumer<RecitationProvider>(
              builder: (context, recitersValue, child) {
                return recitersValue.popularReciterList.isNotEmpty
                    ? SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          children: [
                            SizedBox(
                              height: 170,
                              width: 5 * (200.87.h) +
                                  3 * 5.w, // Adjust the width based on the item width and spacing
                              child: GridView.builder(
                                padding:
                                    EdgeInsets.only(left: 20.w, right: 20.w),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: 8,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 8,
                                  mainAxisExtent: 200.87.h,
                                  crossAxisSpacing: 5.w,
                                ),
                                itemBuilder: (BuildContext context, int index) {
                                  Reciters reciter =
                                      recitersValue.popularReciterList[index];
                                  return InkWell(
                                    onTap: () async {
                                      _addLastViewedRecitations(
                                          "reciter", reciter);
                                      recitersValue.getSurahName();
                                      // context.read<ReciterProvider>().setReciterList(reciter.downloadSurahList!);
                                      /// so that is now an other way
                                      context
                                          .read<ReciterProvider>()
                                          .getAvailableDownloadAudiosAsListOfInt(
                                              reciter.reciterName!);
                                      // updateTappedSurahNames(reciter.reciterName!);
                                      Navigator.of(context).pushNamed(
                                        RouteHelper.reciter,
                                        arguments: reciter,
                                      );

                                      context
                                          .read<recentProviderRecitation>()
                                          .addTappedReciterName(
                                              reciter.reciterName!);
                                    },
                                    child:
                                        buildReciterDetailsContainer(reciter),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    : CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(appColor),
                      );
              },
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SubTitleText(title: localeText(context, "reciters_page")),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(RouteHelper.allReciters);
                    analytics.logEvent(
                      name: 'reciters_section_viewall_button',
                      parameters: {'title': 'reciters_viewall'},
                    );
                  },
                  child: Container(
                    margin:
                        EdgeInsets.only(bottom: 10.h, right: 20.w, left: 20.w),
                    child: Text(
                      localeText(context, "view_all"),
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w900,
                          color: appColor),
                    ),
                  ),
                ),
              ],
            ),

            // const RecitationCategorySection(),
            Consumer<RecitationProvider>(
              builder: (context, recitersValue, child) {
                return recitersValue.recommendedReciterList.isNotEmpty
                    ? SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 5 * (200.87.h) + 3 * 5.w,

                              height:
                                  170, // Adjust the width based on the item width and spacing
                              child: GridView.builder(
                                padding:
                                    EdgeInsets.only(left: 20.w, right: 20.w),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: 8,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 8,
                                  mainAxisExtent: 200.87.h,
                                  crossAxisSpacing: 5.w,
                                ),
                                itemBuilder: (BuildContext context, int index) {
                                  Reciters reciter = recitersValue
                                      .recommendedReciterList[index];
                                  return InkWell(
                                    onTap: () async {
                                      _addLastViewedRecitations(
                                          "reciter", reciter);
                                      recitersValue.getSurahName();
                                      // context.read<ReciterProvider>().setReciterList(reciter.downloadSurahList!);
                                      /// so that is now an other way
                                      context
                                          .read<ReciterProvider>()
                                          .getAvailableDownloadAudiosAsListOfInt(
                                              reciter.reciterName!);
                                      // updateTappedSurahNames(reciter.reciterName!);
                                      Navigator.of(context).pushNamed(
                                        RouteHelper.reciter,
                                        arguments: reciter,
                                      );

                                      // tappedReciterNames.add(reciter.reciterName!);
                                      /// please delete this
                                      context
                                          .read<recentProviderRecitation>()
                                          .addTappedReciterName(
                                              reciter.reciterName!);
                                    },
                                    child:
                                        buildReciterDetailsContainer(reciter),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    : CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(appColor),
                      );
              },
            ),
            // Column(
            //   children: [
            //     HomeRowWidget(
            //       text: localeText(context, 'tranquil_tales'),
            //       buttonText: localeText(context, "view_all"),
            //       onTap: () {
            //         Navigator.of(context)
            //             .pushNamed(RouteHelper.tranquildstoriesviewall);
            //         analytics.logEvent(
            //           name: 'recitation_all_button',
            //         );
            //       },
            //     ),
            //     Consumer2<LocalizationProvider, TranquilCategoryProvider>(
            //       builder: (context, language, recitationProvider, child) {
            //         return SizedBox(
            //           height: 150.h,
            //           child: ListView.builder(
            //             itemCount: recitationProvider.recitationCategory.length,
            //             padding: EdgeInsets.only(
            //                 left: 20.w, right: 20.w, bottom: 14.h),
            //             scrollDirection: Axis.horizontal,
            //             itemBuilder: (context, index) {
            //               try {
            //                 TranquilTalesCategoryModel model =
            //                     recitationProvider.recitationCategory[index];
            //                 // print(model.categoryName);
            //                 // print(model.imageURl);
            //                 return InkWell(
            //                   onTap: () {
            //                     _addLastViewedRecitations(
            //                         "tranquilTalesCategory", model);
            //                     Future.delayed(
            //                       Duration.zero,
            //                       () => context
            //                           .read<RecitationPlayerProvider>()
            //                           .pause(context),
            //                     );
            //                     recitationProvider.getSelectedRecitationAll(
            //                         model.categoryId as int);
            //                     analytics.logEvent(
            //                       name: 'recitation_section',
            //                       parameters: {
            //                         'title': model.categoryName.toString()
            //                       },
            //                     );
            //                     // updateTappedSurahNames(model.categoryName!);
            //                     Navigator.of(context).pushNamed(
            //                       RouteHelper.tranquil_tales,
            //                       arguments: [
            //                         localeText(context, model.categoryName!),
            //                         model.imageURl!,
            //                         LocalizationProvider().checkIsArOrUr()
            //                             ? "${model.numberOfPrayers!} ${localeText(context, 'duas')} ${localeText(context, 'collection_of')} "
            //                             : "${localeText(context, 'playlist_of')} ${model.numberOfPrayers!} ${localeText(context, 'duas')}",
            //                         model.categoryId!,
            //                       ],
            //                     );
            //                     String categoryNames =
            //                         model.categoryName!.replaceAll('_', ' ');

            //                     context
            //                         .read<recentProviderRecitation>()
            //                         .addTappedReciterName(categoryNames!);
            //                   },
            //                   child: Container(
            //                     width: 209.w,
            //                     margin: EdgeInsets.only(right: 10.w),
            //                     decoration: BoxDecoration(
            //                       color: Colors.amberAccent,
            //                       borderRadius: BorderRadius.circular(8.r),
            //                       image: DecorationImage(
            //                         image: NetworkImage(model.imageURl!
            //                             // Replace "https://example.com/path/to/image.jpg" with your actual image URL
            //                             ),
            //                         fit: BoxFit.cover,
            //                       ),
            //                     ),
            //                     child: Container(
            //                       decoration: BoxDecoration(
            //                         borderRadius: BorderRadius.circular(8.r),
            //                         gradient: const LinearGradient(
            //                           colors: [
            //                             Color.fromRGBO(0, 0, 0, 0),
            //                             Color.fromRGBO(0, 0, 0, 1),
            //                           ],
            //                           begin: Alignment.center,
            //                           end: Alignment.bottomCenter,
            //                         ),
            //                       ),
            //                       child: Container(
            //                         margin: EdgeInsets.only(
            //                             left: 6.w, bottom: 8.h, right: 6.w),
            //                         alignment: language.locale.languageCode ==
            //                                     "ur" ||
            //                                 language.locale.languageCode == "ar"
            //                             ? Alignment.bottomRight
            //                             : Alignment.bottomLeft,
            //                         child: Text(
            //                           localeText(context, model.categoryName!),
            //                           textAlign: TextAlign.left,
            //                           style: TextStyle(
            //                               color: Colors.white,
            //                               fontSize: 17.sp,
            //                               fontFamily: "satoshi",
            //                               fontWeight: FontWeight.w900),
            //                         ),
            //                       ),
            //                     ),
            //                   ),
            //                 );
            //               } catch (error) {
            //                 print("Error: $error");

            //                 return Container(); // Placeholder for error handling
            //               }
            //             },
            //           ),
            //         );
            //       },
            //     )
            //   ],
            // ),
            Container(
                margin: EdgeInsets.only(top: 20.h),
                child: buildTitleContainer(localeText(context, "favorites"))),

            Consumer3<RecitationProvider, RecitationCategoryProvider,
                ProfileProvider>(
              builder: (context, recitation, rcp, profile, child) {
                // final bookmarkListReciter = recitation.favReciters;
                // final bookmarkListRecitation = rcp.bookmarkListTest;
                final bookmarkListRecitation =
                    profile.userProfile!.recitationBookmarkList;
                // final favRecitersList = recitation.favRecitersTest;
                final favRecitersList = profile.userProfile!.favRecitersList;

                final combinedBookmarkList = [
                  ...favRecitersList,
                  ...bookmarkListRecitation
                ];

                return combinedBookmarkList.isNotEmpty
                    ? MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        child: ListView.builder(
                          itemCount: combinedBookmarkList.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final bookmark = combinedBookmarkList[index];
                            String title;
                            String subTitle;
                            IconData icon;
                            String imageIcon;

                            if (bookmark is Reciters) {
                              title = bookmark.reciterName ?? '';
                              subTitle = localeText(context, "reciters");
                              icon = Icons.bookmark;
                              imageIcon =
                                  "assets/images/app_icons/bookmark.png";
                            } else if (bookmark is BookmarksRecitation) {
                              final recitationBookmark = bookmark;
                              title = recitationBookmark.recitationName ?? '';
                              subTitle = localeText(context, "recitation");
                              icon = Icons.bookmark;
                              imageIcon =
                                  "assets/images/app_icons/bookmark.png";
                            } else {
                              title = '';
                              subTitle = '';
                              icon = Icons.error;
                              imageIcon = '';
                            }

                            return InkWell(
                              onTap: () {
                                if (bookmark is Reciters) {
                                  recitation.getSurahName();
                                  context
                                      .read<ReciterProvider>()
                                      .setReciterList(
                                          bookmark.downloadSurahList!);
                                  Navigator.of(context).pushNamed(
                                    RouteHelper.reciter,
                                    arguments: bookmark,
                                  );
                                  final tappedRecitersProvider =
                                      context.read<recentProviderRecitation>();
                                } else if (bookmark is BookmarksRecitation) {
                                  Provider.of<RecitationCategoryProvider>(
                                          context,
                                          listen: false)
                                      .gotoRecitationAudioPlayerPage(
                                    bookmark.catID!,
                                    bookmark.recitationIndex!,
                                    bookmark.imageUrl!,
                                    context,
                                  );
                                  Navigator.of(context).pushNamed(
                                      RouteHelper.recitationAudioPlayer,
                                      arguments: [title]);
                                }
                              },
                              child: DetailsContainerWidget(
                                title: title,
                                subTitle: subTitle,
                                icon: icon,
                                imageIcon: imageIcon,
                                onTapIcon: () {
                                  if (bookmark is Reciters) {
                                    // recitation.addReciterFavOrRemove(
                                    //     bookmark.reciterId!);
                                    profile.addReciterFavOrRemove(
                                        bookmark.reciterId!);
                                  } else if (bookmark is BookmarksRecitation) {
                                    // rcp.addOrRemoveBookmark(bookmark);
                                    profile.addOrRemoveRecitationBookmark(
                                        bookmark);
                                  }
                                },
                              ),
                            );
                          },
                        ),
                      )
                    : messageContainer(
                        localeText(context, "no_fav_reciter_added_yet"));
              },
            ),
          ],
        ),
      ),
    );
  }

  Container buildTitleContainer(String title) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h, left: 20.w, top: 2.h, right: 20.w),
      child: Text(
        title,
        style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold),
      ),
    );
  }

  Container buildReciterDetailsContainer(Reciters reciter) {
    var appColors = context.watch<AppColorsProvider>().mainBrandingColor;
    return Container(
      margin: EdgeInsets.only(right: 7.w),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            height: 100.5.h,
            width: 100.5.w,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100.r),
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: reciter.imageUrl!,
                placeholder: (context, url) => CircularProgressIndicator(
                  color: appColors,
                ),
                errorWidget: (context, url, error) => const Icon(Icons.person),
              ),
            ),
          ),
          SizedBox(
            height: 3.h,
          ),
          Expanded(
            child: Text(
              reciter.reciterName!,
              softWrap: true,
              maxLines: 3,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                  height: 1.3.h,
                  fontFamily: "satoshi"),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }

  Container messageContainer(String msg) {
    return Container(
      height: 100.h,
      alignment: Alignment.center,
      child: Text(msg),
    );
  }
}


// Consumer2<RecitationProvider, RecitationCategoryProvider>(
//   builder: (context, recitation, rcp, child) {
//     final bookmarkListReciter = recitation.favReciters;
//     final bookmarkListRecitation = rcp.bookmarkList;
//
//     final combinedBookmarkList = [
//       ...bookmarkListReciter,
//       ...bookmarkListRecitation
//     ];
//
//     return combinedBookmarkList.isNotEmpty
//         ? MediaQuery.removePadding(
//             context: context,
//             removeTop: true,
//             child: ListView.builder(
//               itemCount: combinedBookmarkList.length,
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemBuilder: (context, index) {
//                 final bookmark = combinedBookmarkList[index];
//
//                 String title;
//                 String subTitle;
//                 IconData icon;
//                 String imageIcon;
//
//                 if (bookmark is Reciters) {
//                   title = bookmark.reciterName ?? '';
//                   subTitle = localeText(context, "reciters");
//                   icon = Icons.bookmark;
//                   imageIcon =
//                       "assets/images/app_icons/bookmark.png";
//                 } else if (bookmark is BookmarksRecitation) {
//                   final recitationBookmark = bookmark;
//                   title = recitationBookmark.recitationName ?? '';
//                   subTitle = localeText(context, "recitation");
//                   icon = Icons.bookmark;
//                   imageIcon =
//                       "assets/images/app_icons/bookmark.png";
//                 } else {
//                   title = '';
//                   subTitle = '';
//                   icon = Icons.error;
//                   imageIcon = '';
//                 }
//
//                 return InkWell(
//                   onTap: () {
//                     if (bookmark is Reciters) {
//                       recitation.getSurahName();
//                       context
//                           .read<ReciterProvider>()
//                           .setReciterList(
//                               bookmark.downloadSurahList!);
//                       Navigator.of(context).pushNamed(
//                         RouteHelper.reciter,
//                         arguments: bookmark,
//                       );
//                     } else if (bookmark is BookmarksRecitation) {
//                       Provider.of<RecitationCategoryProvider>(
//                               context,
//                               listen: false)
//                           .gotoRecitationAudioPlayerPage(
//                         bookmark.catID!,
//                         bookmark.recitationIndex!,
//                         bookmark.imageUrl!,
//                         context,
//                       );
//                       Navigator.of(context).pushNamed(
//                           RouteHelper.recitationAudioPlayer,
//                           arguments: [title]);
//                     }
//                   },
//                   child: DetailsContainerWidget(
//                     title: title,
//                     subTitle: subTitle,
//                     icon: icon,
//                     imageIcon: imageIcon,
//                     onTapIcon: () {
//                       if (bookmark is Reciters) {
//                         recitation
//                             .removeFavReciter(bookmark.reciterId!);
//                       } else if (bookmark is BookmarksRecitation) {
//                         rcp.removeBookmark(
//                             bookmark.recitationIndex!,
//                             bookmark.catID!);
//                       }
//                     },
//                   ),
//                 );
//               },
//             ),
//           )
//         : messageContainer(
//             localeText(context, "no_fav_reciter_added_yet"));
//   },
// ),

/// awais work for tapped recitations

// List<String> tappedReciterNames = [];
// void loadTappedSurahNames() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   setState(() {
//     tappedReciterNames = prefs.getStringList('tappedRecitationSection') ?? [];
//   });
// }

// Update the tapped surah names and save to shared preferences
// void updateTappedSurahNames(String surahName) async {
//   setState(() {
//     tappedReciterNames.add(surahName);
//   });
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   prefs.setStringList('tappedRecitationSection', tappedReciterNames);
// }

// Consumer<recentProviderRecitation>(
//   builder: (context, tappedRecitersProvider, child) {
//     if (tappedReciterNames.isEmpty) {
//       return Padding(
//         padding: const EdgeInsets.symmetric(vertical: 10),
//         child: Center(
//           child: Text(
//             localeText(
//               context,
//               'no_last_tapped_reciters',
//             ), // Your desired message
//             style: TextStyle(
//               fontWeight: FontWeight.w700,
//               fontFamily: 'satoshi',
//               fontSize: 13.sp,
//               color: AppColors.grey3,
//               // Your desired style
//             ),
//           ),
//         ),
//       );
//     } else {
//       return Consumer<RecitationProvider>(
//           builder: (context, recitersValue, child) {
//         return Padding(
//           padding: const EdgeInsets.only(
//               left: 20.0, right: 20.0, bottom: 14.0, top: 10),
//           child: SizedBox(
//             height: 23.h,
//
//             /// Set the desired height constraint
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               itemCount:
//                   tappedReciterNames.reversed.toSet().length > 3
//                       ? 3
//                       : tappedReciterNames.reversed.toSet().length,
//               itemBuilder: (context, index) {
//                 final surahNamesSet = tappedReciterNames.reversed.toSet();
//                 final surahName = surahNamesSet.elementAt(index);
//                 final recitersd = tappedReciterNames[index];
//                 Reciters reciters = recitersValue.popularReciterList[index];
//                 return InkWell(
//                   onTap: () => navigateToReciterScreen(
//                       context, recitersValue, reciters),
//                   child: Container(
//                     height: 23.h,
//                     padding: const EdgeInsets.only(left: 9, right: 9),
//                     margin: const EdgeInsets.only(right: 7),
//                     decoration: BoxDecoration(
//                       color: AppColors.grey6,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Center(
//                       child: Text(
//                         surahName,
//                         // Use the appropriate property of the Reciters class
//                         style: const TextStyle(
//                           fontWeight: FontWeight.w700,
//                           fontFamily: 'satoshi',
//                           fontSize: 15,
//                           color: AppColors.grey3,
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         );
//       });
//     }
//   },
// ),
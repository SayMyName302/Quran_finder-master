import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nour_al_quran/pages/quran/pages/recitation/provider.dart';
import 'package:nour_al_quran/pages/quran/pages/recitation/reciter/reciter_page.dart';
import 'package:nour_al_quran/pages/quran/pages/recitation/reciter/reciter_provider.dart';
import 'package:nour_al_quran/pages/quran/pages/recitation/recitation_provider.dart';
import 'package:nour_al_quran/pages/recitation_category/pages/recitation_category_page.dart';
import 'package:nour_al_quran/pages/settings/pages/app_colors/app_colors_provider.dart';
import 'package:nour_al_quran/pages/tranquil_tales/pages/recitation_category_page.dart';
import 'package:nour_al_quran/shared/database/quran_db.dart';
import 'package:nour_al_quran/shared/entities/reciters.dart';
import 'package:nour_al_quran/pages/quran/widgets/subtitle_text.dart';
import 'package:nour_al_quran/shared/localization/localization_constants.dart';
import 'package:nour_al_quran/shared/routes/routes_helper.dart';
import 'package:nour_al_quran/shared/utills/app_colors.dart';
import 'package:provider/provider.dart';

import '../../../recitation_category/pages/bookmarks_recitation.dart';
import '../../../recitation_category/provider/recitation_category_provider.dart';
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

  List<Reciters> tappedRecitersList = [];

  @override
  Widget build(BuildContext context) {
    var appColor = context.read<AppColorsProvider>().mainBrandingColor;
    final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Consumer<AppColorsProvider>(
              builder: (context, value, child) {
                return Container(
                  color: value.mainBrandingColor.withOpacity(0.15),
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
                );
              },
            ),
            Consumer<recentProviderRecitation>(
              builder: (context, tappedRecitersProvider, child) {
                List<Reciters> tappedRecitersList =
                    tappedRecitersProvider.tappedRecitersList;
                if (tappedRecitersList.isEmpty) {
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
                            tappedRecitersList.reversed.toSet().length > 3
                                ? 3
                                : tappedRecitersList.reversed.toSet().length,
                        itemBuilder: (context, index) {
                          final surahNamesSet =
                              tappedRecitersList.reversed.toSet();
                          final surahName = surahNamesSet.elementAt(index);
                          final reciter = tappedRecitersList[index];
                          return GestureDetector(
                            onTap: () async {
                              // Handle the tap on reciter
                              // Implement your logic here for when a reciter is tapped
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
                                  reciter
                                      .reciterName!, // Use the appropriate property of the Reciters class
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

            RecitationCategorySection(),
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
                return recitersValue.recitersList2.isNotEmpty
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
                                      recitersValue.recitersList2[index];
                                  return InkWell(
                                    onTap: () async {
                                      recitersValue.getSurahName();
                                      // context.read<ReciterProvider>().setReciterList(reciter.downloadSurahList!);
                                      /// so that is now an other way
                                      context
                                          .read<ReciterProvider>()
                                          .getAvailableDownloadAudiosAsListOfInt(
                                              reciter.reciterName!);
                                      Navigator.of(context).pushNamed(
                                        RouteHelper.reciter,
                                        arguments: reciter,
                                      );
                                      final tappedRecitersProvider = context
                                          .read<recentProviderRecitation>();
                                      tappedRecitersProvider
                                          .addReciter(reciter);
                                      print('Tapped Reciters List:');
                                      for (var tappedReciter
                                          in tappedRecitersList) {
                                        // Add more details you want to display about the tapped reciter
                                      }
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
                return recitersValue.recitersList.isNotEmpty
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
                                  Reciters reciter =
                                      recitersValue.recitersList[index];
                                  return InkWell(
                                    onTap: () async {
                                      recitersValue.getSurahName();
                                      // context.read<ReciterProvider>().setReciterList(reciter.downloadSurahList!);
                                      /// so that is now an other way
                                      context
                                          .read<ReciterProvider>()
                                          .getAvailableDownloadAudiosAsListOfInt(
                                              reciter.reciterName!);
                                      Navigator.of(context).pushNamed(
                                        RouteHelper.reciter,
                                        arguments: reciter,
                                      );
                                      final tappedRecitersProvider = context
                                          .read<recentProviderRecitation>();
                                      tappedRecitersProvider
                                          .addReciter(reciter);
                                      print(tappedRecitersList);
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
            tranquil_talesSection(),
            Container(
                margin: EdgeInsets.only(top: 20.h),
                child: buildTitleContainer(localeText(context, "favorites"))),
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
            Consumer2<RecitationProvider, RecitationCategoryProvider>(
              builder: (context, recitation, rcp, child) {
                // final bookmarkListReciter = recitation.favReciters;
                final bookmarkListRecitation = rcp.bookmarkListTest;
                final favRecitersList = recitation.favRecitersTest;

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
                                  tappedRecitersProvider.addReciter(bookmark);
                                  print(tappedRecitersList);
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
                                    recitation.addReciterFavOrRemove(
                                        bookmark.reciterId!);
                                  } else if (bookmark is BookmarksRecitation) {
                                    rcp.addOrRemoveBookmark(bookmark);
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

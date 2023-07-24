import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nour_al_quran/pages/quran/pages/recitation/reciter/reciter_provider.dart';
import 'package:nour_al_quran/pages/quran/pages/recitation/recitation_provider.dart';
import 'package:nour_al_quran/pages/recitation_category/pages/recitation_category_page.dart';
import 'package:nour_al_quran/pages/settings/pages/app_colors/app_colors_provider.dart';
import 'package:nour_al_quran/shared/entities/reciters.dart';
import 'package:nour_al_quran/pages/quran/widgets/subtitle_text.dart';
import 'package:nour_al_quran/shared/localization/localization_constants.dart';
import 'package:nour_al_quran/shared/routes/routes_helper.dart';
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
    context.read<RecitationProvider>().getReciters();
    // context.read<RecitationProvider>().getFavReciter();
  }

  @override
  Widget build(BuildContext context) {
    var appColor = context.read<AppColorsProvider>().mainBrandingColor;
    final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const RecitationCategorySection(),
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
                            Container(
                              width: 6 * (116.87.h) +
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
                                  mainAxisExtent: 116.87.h,
                                  crossAxisSpacing: 5.w,
                                ),
                                itemBuilder: (BuildContext context, int index) {
                                  Reciters reciter =
                                      recitersValue.recitersList[index];
                                  return InkWell(
                                    onTap: () async {
                                      recitersValue.getSurahName();
                                      // context.read<ReciterProvider>().setReciterList(reciter.downloadSurahList!);
                                      /// so that is now an
                                      context.read<ReciterProvider>().getAvailableDownloadAudioFilesFromLocal(reciter.reciterName!);
                                      print(reciter.audioUrl);
                                      Navigator.of(context).pushNamed(
                                        RouteHelper.reciter,
                                        arguments: reciter,
                                      );
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

                return combinedBookmarkList.isNotEmpty ? MediaQuery.removePadding(
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
                        imageIcon = "assets/images/app_icons/bookmark.png";
                      } else if (bookmark is BookmarksRecitation) {
                        final recitationBookmark = bookmark;
                        title = recitationBookmark.recitationName ?? '';
                        subTitle = localeText(context, "recitation");
                        icon = Icons.bookmark;
                        imageIcon = "assets/images/app_icons/bookmark.png";
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
                            context.read<ReciterProvider>().setReciterList(
                                bookmark.downloadSurahList!);
                            Navigator.of(context).pushNamed(
                              RouteHelper.reciter,
                              arguments: bookmark,
                            );
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
                              recitation.addReciterFavOrRemove(bookmark.reciterId!);
                            } else if (bookmark is BookmarksRecitation) {
                              rcp.removeBookmark(
                                  bookmark.recitationIndex!,
                                  bookmark.catID!);
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
            height: 71.18.h,
            width: 71.18.w,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(35.59.r),
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
          Text(
            reciter.reciterName!,
            softWrap: true,
            maxLines: 3,
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 11.sp,
                height: 1.3.h,
                fontFamily: "satoshi"),
            textAlign: TextAlign.center,
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

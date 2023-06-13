import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nour_al_quran/pages/duas/dua_bookmarks_provider.dart';
import 'package:nour_al_quran/pages/duas/dua_provider.dart';
import 'package:nour_al_quran/pages/duas/widgets/ruqyah_bookmark_provider.dart';
import 'package:nour_al_quran/pages/quran/pages/bookmarks/bookmarks_provider.dart';
import 'package:nour_al_quran/pages/quran/pages/ruqyah/models/ruqyah.dart';
import 'package:nour_al_quran/pages/quran/pages/ruqyah/models/ruqyah_provider.dart';
import 'package:nour_al_quran/pages/quran/widgets/details_container_widget.dart';
import 'package:nour_al_quran/shared/entities/bookmarks.dart';
import 'package:nour_al_quran/shared/entities/bookmarks_dua.dart';
import 'package:nour_al_quran/shared/entities/bookmarks_ruqyah.dart';
import 'package:nour_al_quran/shared/localization/localization_constants.dart';
import 'package:nour_al_quran/shared/localization/localization_provider.dart';
import 'package:provider/provider.dart';

import '../../shared/routes/routes_helper.dart';

class DuaBookmarkPage extends StatelessWidget {
  const DuaBookmarkPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            margin: EdgeInsets.only(
                bottom: 10.h, left: 20.h, top: 2.h, right: 20.w),
            child: Text(
              localeText(context, "dua_bookmarks"),
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
            )),
        Consumer<BookmarkProviderDua>(
          builder: (context, bookmarkValue, child) {
            return bookmarkValue.bookmarkList.isNotEmpty
                ? Expanded(
                    child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: ListView.builder(
                        itemCount: bookmarkValue.bookmarkList.length,
                        itemBuilder: (context, index) {
                          BookmarksDua bookmarks =
                              bookmarkValue.bookmarkList[index];
                          return InkWell(
                            onTap: () async {
                              // Provider.of<DuaProvider>(context,listen: false).getDua(bookmarks.categoryId!);
                              Provider.of<DuaProvider>(context, listen: false)
                                  .gotoDuaPlayerPage(bookmarks.categoryId!,
                                      bookmarks.duaText!, context);
                              Navigator.of(context).pushNamed(
                                RouteHelper.duaDetailed,
                              );
                              // bookmarkValue.goToAudioPlayer(bookmarks, context);
                            },
                            child: DetailsContainerWidget(
                              title: bookmarks.duaTitle!,
                              subTitle:
                                  "${localeText(context, "dua")} ${bookmarks.duaId} , ${bookmarks.duaRef}",
                              icon: Icons.bookmark,
                              onTapIcon: () {
                                bookmarkValue.removeBookmark(bookmarks.duaId!);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  )
                : Expanded(
                    child: Center(
                    child: Text(localeText(context, "no_bookmarks_added_yet")),
                  ));
          },
        ),
        Container(
            margin: EdgeInsets.only(
                bottom: 10.h, left: 20.h, top: 2.h, right: 20.w),
            child: Text(
              localeText(context, "ruqya_bookmarks"),
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
            )),
        Consumer<BookmarkProviderRuqyah>(
          builder: (context, bookmarkValue, child) {
            return bookmarkValue.bookmarkList.isNotEmpty
                ? Expanded(
                    child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: ListView.builder(
                        itemCount: bookmarkValue.bookmarkList.length,
                        itemBuilder: (context, index) {
                          BookmarksRuqyah bookmarks =
                              bookmarkValue.bookmarkList[index];
                          return InkWell(
                            onTap: () async {
                              // Provider.of<DuaProvider>(context,listen: false).getDua(bookmarks.categoryId!);
                              Provider.of<RuqyahProvider>(context,
                                      listen: false)
                                  .gotoDuaPlayerPage(bookmarks.categoryId!,
                                      bookmarks.duaText!, context);
                              Navigator.of(context).pushNamed(
                                RouteHelper.ruqyahDetailed,
                              );
                              // bookmarkValue.goToAudioPlayer(bookmarks, context);
                            },
                            child: DetailsContainerWidget(
                              title: bookmarks.duaTitle!,
                              subTitle:
                                  "${localeText(context, "dua")} ${bookmarks.duaId} , ${bookmarks.duaRef}",
                              icon: Icons.bookmark,
                              onTapIcon: () {
                                bookmarkValue.removeBookmark(bookmarks.duaId!);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  )
                : Expanded(
                    child: Center(
                    child: Text(localeText(context, "no_bookmarks_added_yet")),
                  ));
          },
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nour_al_quran/pages/duas/dua_bookmarks_provider.dart';
import 'package:nour_al_quran/pages/quran/pages/bookmarks/bookmarks_provider.dart';
import 'package:nour_al_quran/pages/quran/widgets/details_container_widget.dart';
import 'package:nour_al_quran/shared/entities/bookmarks.dart';
import 'package:nour_al_quran/shared/entities/bookmarks_dua.dart';
import 'package:nour_al_quran/shared/localization/localization_constants.dart';
import 'package:nour_al_quran/shared/localization/localization_provider.dart';
import 'package:provider/provider.dart';

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
                              bookmarkValue.goToAudioPlayer(bookmarks, context);
                            },
                            child: DetailsContainerWidget(
                              title: "ABC",
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
        )
      ],
    );
  }
}


// const SubTitleText(title: "Audio Bookmarks"),
// DetailsContainerWidget(title: 'Surah ${surah[1-1].surahName}',subTitle: "${surah[1-1].englishName}, Surah # ${surah[1-1].surahId}",icon: Icons.bookmark,onTapIcon: (){},),
// DetailsContainerWidget(title: 'Surah Al-Fatihah',subTitle: "The Opener, Surah # 1",icon: Icons.bookmark,onTapIcon: (){},),
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nour_al_quran/pages/duas/provider/dua_provider.dart';
import 'package:nour_al_quran/pages/duas/models/dua.dart';
import 'package:nour_al_quran/pages/quran/pages/ruqyah/models/ruqyah.dart';
import 'package:nour_al_quran/pages/quran/pages/ruqyah/provider/ruqyah_provider.dart';
import 'package:nour_al_quran/pages/quran/widgets/details_container_widget.dart';
import 'package:nour_al_quran/pages/settings/pages/profile/profile_provider.dart';
import 'package:nour_al_quran/shared/localization/localization_constants.dart';
import 'package:provider/provider.dart';
import '../../../shared/routes/routes_helper.dart';

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
        Expanded(
          child: Consumer<ProfileProvider>(
            builder: (context, profile, child) {
              List<Dua> bookmarkListDua = profile.userProfile!.duaBookmarksList;
              List<Ruqyah> bookmarkListRuqyah =
                  profile.userProfile!.ruqyahBookmarksList;

              List<dynamic> combinedBookmarkList = [
                ...bookmarkListDua,
                ...bookmarkListRuqyah
              ];

              return combinedBookmarkList.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: combinedBookmarkList.length,
                      itemBuilder: (context, index) {
                        final bookmark = combinedBookmarkList[index];
                        final isDuaBookmark = index < bookmarkListDua.length;

                        return InkWell(
                          onTap: () async {
                            if (isDuaBookmark) {
                              Provider.of<DuaProvider>(context, listen: false)
                                  .gotoDuaPlayerPage(
                                bookmark.duaCategoryId!,
                                bookmark.duaText!,
                                context,
                              );
                            } else {
                              Provider.of<RuqyahProvider>(context,
                                      listen: false)
                                  .gotoDuaPlayerPage(
                                bookmark.duaCategoryId!,
                                bookmark.duaText!,
                                context,
                              );
                              Navigator.of(context).pushNamed(
                                RouteHelper.ruqyahDetailed,
                              );
                            }
                          },
                          child: DetailsContainerWidget(
                            // ${localeText(context, bookmark.duaCategoryId!)}
                            // title: '${bookmark.duaTitle}',
                            title: localeText(context, bookmark.duaTitle),
                            subTitle:
                                "${localeText(context, "dua")} ${bookmark.duaNo} , ${bookmark.duaRef}",
                            icon: Icons.bookmark,
                            onTapIcon: () {
                              if (isDuaBookmark) {
                                profile.addOrRemoveDuaBookmark(bookmark);
                              } else {
                                profile.addOrRemoveRuqyaDuaBookmark(bookmark);
                              }
                            },
                          ),
                        );
                      },
                    )
                  : const Text('');
            },
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:nour_al_quran/pages/duas/models/dua_category.dart';
import 'package:nour_al_quran/pages/recitation_category/models/recitation_all_category_model.dart';
import 'package:nour_al_quran/pages/settings/pages/app_them/them_provider.dart';
import 'package:provider/provider.dart';
import '../../../shared/providers/dua_audio_player_provider.dart';
import '../../../shared/routes/routes_helper.dart';
import '../../../shared/utills/app_colors.dart';
import '../../../shared/widgets/circle_button.dart';
import '../../duas/dua_provider.dart';
import '../../settings/pages/app_colors/app_colors_provider.dart';
import '../provider/recitation_category_provider.dart';

class RecitationAllAudioPlayer extends StatelessWidget {
  const RecitationAllAudioPlayer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    RecitationCategoryProvider recitationProvider = Provider.of<RecitationCategoryProvider>(context);
    Map<String, dynamic> nextRecitationData = recitationProvider.getNextDuaRecitation();
    int index = nextRecitationData['index'];
    int favindex = index - 1;
    RecitationAllCategoryModel dua = nextRecitationData['dua'];
   //int? fav = dua.isFav;
    int part7 = recitationProvider.selectedRecitationAll.length;
    String duaTitle = dua.title.toString();
    String duaRef = dua.reference.toString();
    String duaText = dua.title.toString();
    int? duaCount = dua.ayahCount;
    //String duaTranslation = dua.translations.toString();
   // String duaUrl = dua.duaUrl.toString();

    final ValueNotifier<bool> isLoopMoreNotifier = ValueNotifier<bool>(false);
    // ignore: unused_local_variable
    bool isLoopMore = false;

    return Column(
      mainAxisSize: MainAxisSize.max,
      //mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          margin: EdgeInsets.only(left: 20.w, right: 20.w, top: 15.h),
          width: double.maxFinite,
          child: Consumer4<ThemProvider, DuaPlayerProvider, AppColorsProvider, RecitationCategoryProvider>(
            builder: (context, them, player, appColor, rectProv, child) {
              return Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 50.w, right: 35.w, top: 10.h),
                    //decoration: BoxDecoration(border: Border.all(width: 1)),
                    child: Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              duaTitle,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'satoshi',
                                fontWeight: FontWeight.w700,
                                fontSize: 19.sp,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            int duaIndex = rectProv.selectedRecitationAll.indexWhere((element) => element.title == duaText);
                            int indx = rectProv.selectedRecitationAll[duaIndex].surahNo!;
                            int? categoryId = rectProv.selectedRecitationAll[duaIndex].surahId;
                            String categoryName = getCategoryNameById(categoryId!, rectProv.selectedRecitationAll.cast<DuaCategory>());
                            int duaNo = rectProv.selectedRecitationAll[duaIndex].surahId!;
                           /* if (fav == 0) {
                              duaProv.bookmark(duaIndex, 1);
                              BookmarksDua bookmark = BookmarksDua(
                                  duaId: indx,
                                  duaNo: duaNo,
                                  categoryId: categoryId,
                                  categoryName: categoryName,
                                  duaTitle: duaTitle,
                                  duaRef: duaRef,
                                  ayahCount: duaCount,
                                  duaText: duaText,
                                  duaTranslation: duaTranslation,
                                  bookmarkPosition: favindex,
                                  duaUrl: duaUrl);
                              context
                                  .read<BookmarkProviderDua>()
                                  .addBookmark(bookmark);
                            } else {
                              // to change state
                              duaProv.bookmark(duaIndex, 0);
                              context
                                  .read<BookmarkProviderDua>()
                                  .removeBookmark(
                                  duaProvider.duaList[duaIndex].id!,
                                  duaProvider
                                      .duaList[duaIndex].duaCategory!);
                            }*/
                          },
                          child: Container(
                            height: 20.h,
                            width: 20.w,
                            margin: EdgeInsets.only(bottom: 7.h, top: 8.h),
                            child: CircleAvatar(
                              backgroundColor: appColor.mainBrandingColor,
                              child: SizedBox(
                                height: 16.h,
                                width: 16.w,
                                child: CircleAvatar(
                                  backgroundColor: appColor.mainBrandingColor,
                                  child: SizedBox(
                                    height: 21.h,
                                    width: 21.w,
                                    child: CircleAvatar(
                                      backgroundColor: 1 == 1
                                          ? appColor.mainBrandingColor
                                          : Colors.white,
                                      child: Icon(
                                        Icons.favorite,
                                        color: 1 == 1
                                            ? Colors.white
                                            : appColor.mainBrandingColor,
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
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Dua $index  (Total $part7)',
                        style: const TextStyle(
                          fontFamily: 'satoshi',
                          fontWeight: FontWeight.w700,
                          fontSize: 19.0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 70.h,
                  ),
                  Row(
                    children: [
                      Text(
                          "${player.duration.inHours}:${player.duration.inMinutes.remainder(60)}:${player.duration.inSeconds.remainder(60)}"),
                      SliderTheme(
                        data: SliderThemeData(
                            overlayShape: SliderComponentShape.noOverlay,
                            trackHeight: 9.h,
                            thumbShape: const RoundSliderThumbShape(
                              elevation: 0.0,
                              enabledThumbRadius: 6,
                            )),
                        child: Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: 7.w, right: 7.w),
                            child: Slider(
                              min: 0.0,
                              thumbColor: appColor.mainBrandingColor,
                              activeColor: appColor.mainBrandingColor,
                              inactiveColor: AppColors.lightBrandingColor,
                              max: player.duration.inSeconds.toDouble(),
                              value: player.position.inSeconds.toDouble(),
                              onChanged: (value) {
                                final position =
                                Duration(seconds: value.toInt());
                                player.audioPlayer.seek(position);
                              },
                            ),
                          ),
                        ),
                      ),
                      Text(
                          '- ${player.position.inMinutes.remainder(60)}:${player.position.inSeconds.remainder(60)}'),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (!isLoopMoreNotifier.value) {
                            isLoopMoreNotifier.value = true;
                            player.audioPlayer.setLoopMode(LoopMode.one);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content:
                                Text('Loop More On For ${'Dua $index'}')));
                          } else {
                            isLoopMoreNotifier.value = false;
                            player.audioPlayer.setLoopMode(LoopMode.off);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content:
                                Text('Loop More Off For ${'Dua $index'}')));
                          }
                        },
                        icon: ValueListenableBuilder<bool>(
                          valueListenable: isLoopMoreNotifier,
                          builder: (context, isLoopMore, child) {
                            return Image.asset(
                              'assets/images/app_icons/repeat.png',
                              height: 30.h,
                              width: 30.w,
                              color: isLoopMore
                                  ? appColor.mainBrandingColor
                                  : Theme.of(context).brightness ==
                                  Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                            );
                          },
                        ),
                        padding: EdgeInsets.zero,
                        alignment: Alignment.center,
                      ),
                      IconButton(
                        onPressed: () async {
                          Provider.of<DuaProvider>(context, listen: false)
                              .playPreviousDuaInCategory(context);
                        },
                        icon: Image.asset(
                          'assets/images/app_icons/previous.png',
                          height: 30.h,
                          width: 30.w,
                          color: them.isDark ? Colors.white : Colors.black,
                        ),
                        padding: EdgeInsets.zero,
                        alignment: Alignment.center,
                      ),
                      Stack(
                        children: [
                          InkWell(
                            onTap: () async {
                              if (!player.isPlaying) {
                                await player.play();
                              } else {
                                await player.pause();
                              }
                            },
                            child: player.isLoading
                                ? SizedBox(
                              height: 63.h,
                              width: 63.w,
                              child: CircularProgressIndicator(
                                  valueColor:
                                  AlwaysStoppedAnimation<Color>(
                                      appColor.mainBrandingColor)),
                            )
                                : CircleButton(
                              height: 63.h,
                              width: 63.h,
                              icon: Icon(
                                player.isPlaying
                                    ? Icons.pause_rounded
                                    : Icons.play_arrow_rounded,
                                size: 40.h,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () async {
                          Provider.of<DuaProvider>(context, listen: false)
                              .playNextDuaInCategory(context);
                        },
                        icon: Image.asset(
                          'assets/images/app_icons/next.png',
                          height: 30.h,
                          width: 30.w,
                          color: them.isDark ? Colors.white : Colors.black,
                        ),
                        padding: EdgeInsets.zero,
                        alignment: Alignment.center,
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                            RouteHelper.duaPlayList,
                          );
                        },
                        icon: Image.asset(
                          'assets/images/app_icons/list.png',
                          height: 30.h,
                          width: 30.w,
                          color: them.isDark ? Colors.white : Colors.black,
                        ),
                        padding: EdgeInsets.zero,
                        alignment: Alignment.center,
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ],
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

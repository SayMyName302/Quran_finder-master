import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';

import 'package:nour_al_quran/pages/settings/pages/app_colors/app_colors_provider.dart';
import 'package:nour_al_quran/pages/settings/pages/app_them/them_provider.dart';
import 'package:nour_al_quran/pages/tranquil_tales/provider/tranquil_tales_provider.dart';
import 'package:nour_al_quran/shared/localization/localization_constants.dart';
import 'package:nour_al_quran/shared/utills/app_colors.dart';
import 'package:nour_al_quran/shared/widgets/circle_button.dart';
import 'package:provider/provider.dart';

import '../../../shared/providers/story_n_basics_audio_player_provider.dart';
import '../../../shared/widgets/app_bar.dart';
import '../models/TranquilModel.dart';
import 'bookmarks_recitation.dart';

class TranquilAudioPlayer extends StatelessWidget {
  const TranquilAudioPlayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var recitationProv = Provider.of<TranquilCategoryProvider>(context);
    List arguments = ModalRoute.of(context)!.settings.arguments! as List;
    String title = arguments[0];

    TranquilCategoryProvider rcp =
        Provider.of<TranquilCategoryProvider>(context);
    Map<String, dynamic> nextDuaData = rcp.getNextDuaRecitation();
    TranquilTalesModel nextDua = nextDuaData['dua'];
    // int? fav = nextDua.isFav;
    String duaUrl = nextDua.contentUrl.toString();
    String reference = nextDua.reference.toString();
    print(duaUrl);
    final ValueNotifier<bool> isLoopMoreNotifier = ValueNotifier<bool>(false);
    return WillPopScope(
      onWillPop: () async {
        context.read<StoryAndBasicPlayerProvider>().closePlayer();
        return true;
      },
      child: Scaffold(
        appBar: buildAppBar(
            context: context,
            font: 16.sp,
            title: localeText(context, "now_playing")),
        body: Consumer4<ThemProvider, StoryAndBasicPlayerProvider,
            AppColorsProvider, TranquilCategoryProvider>(
          builder: (context, them, player, appColor, recitationCategoryProvider,
              child) {
            int recitationIndex = recitationProv.selectedRecitationAll
                .indexWhere((element) => element.reference == reference);
            int indx =
                recitationProv.selectedRecitationAll[recitationIndex].surahId!;
            int? categoryId = recitationProv
                .selectedRecitationAll[recitationIndex].categoryId;

            BookmarksRecitation bookmark = BookmarksRecitation(
                recitationIndex: indx,
                catID: categoryId,
                recitationName: title,
                recitationRef:
                    recitationProv.selectedRecitationStory!.reference!,
                contentUrl: duaUrl,
                imageUrl: player.image);
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 340.h,
                        width: 353.w,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24.r),
                            image: DecorationImage(
                                image: NetworkImage(
                                  player.image,
                                ),
                                fit: BoxFit.cover)),
                        margin: EdgeInsets.only(
                            left: 20.w, right: 20.w, bottom: 35.h),
                      ),
                      Text(
                        localeText(context, title),
                        // title,
                        style: TextStyle(
                            fontSize: 18.sp,
                            color:
                                them.isDark ? AppColors.grey4 : AppColors.grey3,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'satoshi'),
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      Text(
                        localeText(context,
                            recitationProv.selectedRecitationStory!.title!),
                        style: TextStyle(
                          fontFamily: 'satoshi',
                          fontWeight: FontWeight.w900,
                          fontSize: 22.sp,
                        ),
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      Text(
                        recitationProv.selectedRecitationStory!.reference!,
                        style: TextStyle(
                            fontSize: 16.sp,
                            fontFamily: 'satoshi',
                            color:
                                them.isDark ? AppColors.grey4 : AppColors.grey3,
                            fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      Text(
                        "Surah No: ${recitationProv.selectedRecitationStory!.surahNo!.toString()}",
                        style: TextStyle(
                            fontSize: 16.sp,
                            fontFamily: 'satoshi',
                            color:
                                them.isDark ? AppColors.grey4 : AppColors.grey3,
                            fontWeight: FontWeight.w700),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text(""),
                          const Text(""),
                          // InkWell(
                          //   onTap: () {
                          //     int recitationIndex = recitationProv
                          //         .selectedRecitationAll
                          //         .indexWhere((element) =>
                          //             element.reference == reference);
                          //     int indx = recitationProv
                          //         .selectedRecitationAll[recitationIndex]
                          //         .surahId!;
                          //     int? categoryId = recitationProv
                          //         .selectedRecitationAll[recitationIndex]
                          //         .categoryId;
                          //
                          //     if (fav == 0 || fav == null) {
                          //       rprovider.bookmark(recitationIndex, 1);
                          //       BookmarksRecitation bookmark =
                          //           BookmarksRecitation(
                          //               recitationIndex: indx,
                          //               catID: categoryId,
                          //               recitationName: title,
                          //               recitationRef: recitationProv
                          //                   .selectedRecitationStory!
                          //                   .reference!,
                          //               contentUrl: duaUrl,
                          //               imageUrl: player.image);
                          //
                          //       context
                          //           .read<RecitationCategoryProvider>()
                          //           .addBookmark(bookmark);
                          //     } else {
                          //       rprovider.bookmark(recitationIndex, 0);
                          //       context
                          //           .read<RecitationCategoryProvider>()
                          //           .removeBookmark(
                          //               indx,
                          //               recitationProv.selectedRecitationStory!
                          //                   .categoryId!);
                          //     }
                          //   },
                          //   child: Container(
                          //     height: 23.h,
                          //     width: 23.w,
                          //     margin: EdgeInsets.only(
                          //       top: 3.h,
                          //       bottom: 10.h,
                          //     ),
                          //     child: CircleAvatar(
                          //       backgroundColor: appColor.mainBrandingColor,
                          //       child: SizedBox(
                          //         height: 21.h,
                          //         width: 21.w,
                          //         child: CircleAvatar(
                          //           backgroundColor: fav == 1
                          //               ? appColor.mainBrandingColor
                          //               : Colors.white,
                          //           child: Icon(
                          //             Icons.favorite,
                          //             color: fav == 1
                          //                 ? Colors.white
                          //                 : appColor.mainBrandingColor,
                          //             size: 13.h,
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // )
                          InkWell(
                            onTap: () {
                              // recitationCategoryProvider
                              //     .addOrRemoveBookmark(bookmark);
                            },
                            child: Container(
                              height: 23.h,
                              width: 23.w,
                              margin: EdgeInsets.only(
                                top: 3.h,
                                bottom: 10.h,
                              ),
                              child: CircleAvatar(
                                backgroundColor: appColor.mainBrandingColor,
                                child: SizedBox(
                                  height: 21.h,
                                  width: 21.w,
                                  child: CircleAvatar(
                                    backgroundColor: recitationCategoryProvider
                                            .bookmarkListTest
                                            .any((element) =>
                                                element.recitationIndex ==
                                                bookmark.recitationIndex)
                                        ? appColor.mainBrandingColor
                                        : Colors.white,
                                    child: Icon(
                                      Icons.favorite,
                                      color: recitationCategoryProvider
                                              .bookmarkListTest
                                              .any((element) =>
                                                  element.recitationIndex ==
                                                  bookmark.recitationIndex)
                                          ? Colors.white
                                          : appColor.mainBrandingColor,
                                      size: 13.h,
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
                  Container(
                    margin: EdgeInsets.only(
                        left: 20.w, right: 20.w, bottom: 30.h, top: 10.h),
                    width: double.maxFinite,
                    child: Column(
                      children: [
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
                                  margin:
                                      EdgeInsets.only(left: 7.w, right: 7.w),
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
                          height: 20.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                              onPressed: () {
                                if (!isLoopMoreNotifier.value) {
                                  isLoopMoreNotifier.value = true;
                                  player.audioPlayer.setLoopMode(LoopMode.one);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Loop Mode On For ${recitationProv.selectedRecitationStory!.surahNo!}')));
                                } else {
                                  isLoopMoreNotifier.value = false;
                                  player.audioPlayer.setLoopMode(LoopMode.off);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Loop Mode Off For ${recitationProv.selectedRecitationStory!.surahNo!}')));
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
                                                      appColor
                                                          .mainBrandingColor)),
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
                                player.setSpeed();
                              },
                              icon: Row(
                                children: [
                                  Image.asset(
                                    'assets/images/app_icons/speed.png',
                                    height: 15.h,
                                    width: 18.75.w,
                                    color: them.isDark
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  Text(
                                    "${player.speed}x",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'satoshi',
                                        fontSize: 12.sp),
                                  )
                                ],
                              ),
                              padding: EdgeInsets.zero,
                              alignment: Alignment.center,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
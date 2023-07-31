import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:nour_al_quran/pages/settings/pages/app_them/them_provider.dart';
import 'package:provider/provider.dart';
import '../models/ruqyah_category.dart';
import '../provider/ruqyah_provider.dart';
import '../../../../settings/pages/app_colors/app_colors_provider.dart';
import '../../../../../shared/providers/dua_audio_player_provider.dart';
import '../../../../../shared/routes/routes_helper.dart';
import '../../../../../shared/utills/app_colors.dart';
import '../../../../../shared/widgets/circle_button.dart';

class RuqyahAudioPlayer extends StatelessWidget {
  const RuqyahAudioPlayer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    RuqyahProvider ruqyahProvider = Provider.of<RuqyahProvider>(context);
    // Map<String, dynamic> nextDuaData = ruqyahProvider.getNextDua();
    // int index = nextDuaData['index'];
    int index = ruqyahProvider.selectedDua!.duaNo!;

    final ValueNotifier<bool> isLoopMoreNotifier = ValueNotifier<bool>(false);
    // ignore: unused_local_variable
    bool isLoopMore = false;
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          margin: EdgeInsets.only(left: 20.w, right: 20.w),
          width: double.maxFinite,
          child: Consumer4<ThemProvider, DuaPlayerProvider, AppColorsProvider,
              RuqyahProvider>(
            builder: (context, them, player, appColor, dua, child) {
              return Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 50.w, right: 35.w, top: 10.h),
                    child: const Row(
                      children: [],
                    ),
                  ),
                  Row(
                    children: [
                      Text("${player.duration.inHours}:${player.duration.inMinutes.remainder(60)}:${player.duration.inSeconds.remainder(60)}"),
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
                      Text('- ${player.position.inMinutes.remainder(60)}:${player.position.inSeconds.remainder(60)}'),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // SizedBox(
                      //   width: 15.h,
                      // ),

                      // IconButton(
                      //   onPressed: () {
                      //     Navigator.of(context).pushNamed(
                      //       RouteHelper.ruqyahPlayList,
                      //       // arguments: [
                      //       //   // categoryId,
                      //       //   // categoryName,
                      //       // ],
                      //     );
                      //   },
                      //   icon: Image.asset(
                      //     'assets/images/app_icons/list.png',
                      //     height: 30.h,
                      //     width: 30.w,
                      //     color: them.isDark ? Colors.white : Colors.black,
                      //   ),
                      //   padding: EdgeInsets.zero,
                      //   alignment: Alignment.center,
                      // ),

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
                          Provider.of<RuqyahProvider>(context, listen: false)
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
                      // SizedBox(
                      //   width: 20.h,
                      // ),
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
                      // SizedBox(
                      //   width: 20.h,
                      // ),
                      IconButton(
                        onPressed: () async {
                          Provider.of<RuqyahProvider>(context, listen: false)
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
                      // const Spacer(),
                      // IconButton(
                      //   onPressed: () async {
                      //     player.setSpeed();
                      //   },
                      //   icon: Row(
                      //     children: [
                      //       Image.asset(
                      //         'assets/images/app_icons/speed.png',
                      //         height: 15.h,
                      //         width: 18.75.w,
                      //         color: them.isDark ? Colors.white : Colors.black,
                      //       ),
                      //       SizedBox(
                      //         width: 5.w,
                      //       ),
                      //       Text(
                      //         "${player.speed}x",
                      //         style: TextStyle(
                      //             fontWeight: FontWeight.w700,
                      //             fontFamily: 'satoshi',
                      //             fontSize: 12.sp),
                      //       )
                      //     ],
                      //   ),
                      //   padding: EdgeInsets.zero,
                      //   alignment: Alignment.center,
                      // ),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                            RouteHelper.ruqyahPlayList,
                            // arguments: [
                            //   // categoryId,
                            //   // categoryName,
                            // ],
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

                      // SizedBox(
                      //   width: 15.h,
                      // ),
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

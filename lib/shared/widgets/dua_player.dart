import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nour_al_quran/pages/settings/pages/app_them/them_provider.dart';
import 'package:provider/provider.dart';

import '../../pages/quran/pages/duas/dua_provider.dart';
import '../../pages/settings/pages/app_colors/app_colors_provider.dart';
import '../providers/dua_audio_player_provider.dart';
import '../utills/app_colors.dart';
import 'circle_button.dart';

class DuaAudioPlayer extends StatelessWidget {
  const DuaAudioPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    var fromWhere = ModalRoute.of(context)!
        .settings
        .arguments; // Use this variable for playlist!!!
    return Container(
      margin: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 30.h, top: 20.h),
      width: double.maxFinite,
      child: Consumer4<ThemProvider, DuaPlayerProvider, AppColorsProvider,
          DuaProvider>(
        builder: (context, them, player, appColor, dua, child) {
          return Column(
            children: [
              Row(
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
                    height: 20.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        onPressed: () {
                          // Here Implement Logic to Show PlayList for User, he can choose any Dua from list!!!
                          // if (fromWhere == "fromStory") {
                          //   story.goToStoryContentPage(
                          //       story.currentStoryIndex, context);
                          // } else {
                          //   basics.goToBasicsContentPage(
                          //       basics.currentIslamBasics, context);
                          // }
                        },
                        icon: Image.asset(
                          'assets/images/app_icons/story.png',
                          height: 18.h,
                          width: 18.w,
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
                          player.setSpeed();
                        },
                        icon: Row(
                          children: [
                            Image.asset(
                              'assets/images/app_icons/speed.png',
                              height: 15.h,
                              width: 18.75.w,
                              color: them.isDark ? Colors.white : Colors.black,
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
            ],
          );
        },
      ),
    );
  }
}

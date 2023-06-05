import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nour_al_quran/pages/settings/pages/app_them/them_provider.dart';
import 'package:provider/provider.dart';

import 'package:nour_al_quran/pages/duas/models/dua.dart';

import '../../pages/duas/dua_provider.dart';

import '../../pages/settings/pages/app_colors/app_colors_provider.dart';
import '../providers/dua_audio_player_provider.dart';
import '../routes/routes_helper.dart';
import '../utills/app_colors.dart';
import 'circle_button.dart';

class DuaAudioPlayer extends StatelessWidget {
  const DuaAudioPlayer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    DuaProvider duaProvider = Provider.of<DuaProvider>(context);
    Map<String, dynamic> nextDuaData = duaProvider.getNextDua();
    int part1 = nextDuaData['index'];
    Dua nextDua = nextDuaData['dua'];
    int part7 = duaProvider.duaList.length;
    String duaTitle = nextDua.duaTitle.toString();

    return Column(
      mainAxisSize: MainAxisSize.max,
      //mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          margin: EdgeInsets.only(left: 20.w, right: 20.w, top: 30.h),
          width: double.maxFinite,
          child: Consumer4<ThemProvider, DuaPlayerProvider, AppColorsProvider,
              DuaProvider>(
            builder: (context, them, player, appColor, dua, child) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        duaTitle,
                        style: TextStyle(
                            fontFamily: 'satoshi',
                            fontWeight: FontWeight.w700,
                            fontSize: 19.sp),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Dua $part1  (Total $part7)',
                        style: TextStyle(
                            fontFamily: 'satoshi',
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
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
                    height: 20.h,
                  ),
                  Row(
                    children: [
                      // SizedBox(
                      //   width: 15.h,
                      // ),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                            RouteHelper.duaPlayList,
                            // arguments: [
                            //   // categoryId,
                            //   // categoryName,
                            // ],
                          );
                        },
                        icon: Image.asset(
                          'assets/images/app_icons/list.png',
                          height: 18.h,
                          width: 18.w,
                          color: them.isDark ? Colors.white : Colors.black,
                        ),
                        padding: EdgeInsets.zero,
                        alignment: Alignment.center,
                      ),
                      const Spacer(),
                      CircleButton(
                        height: 37.h,
                        width: 37.h,
                        icon: InkWell(
                          onTap: () {
                            Provider.of<DuaProvider>(context, listen: false)
                                .playPreviousDuaInCategory(context);
                          },
                          child: Icon(
                            Icons.skip_previous,
                            size: 30.h,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20.h,
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
                      SizedBox(
                        width: 20.h,
                      ),
                      CircleButton(
                        height: 37.h,
                        width: 37.h,
                        icon: InkWell(
                          onTap: () {
                            Provider.of<DuaProvider>(context, listen: false)
                                .playNextDuaInCategory(context);
                          },
                          child: Icon(
                            Icons.skip_next,
                            size: 30.h,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const Spacer(),
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
}

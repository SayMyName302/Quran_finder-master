import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:nour_al_quran/pages/settings/pages/app_them/them_provider.dart';
import 'package:provider/provider.dart';
import '../../pages/duas/models/dua.dart';
import '../../pages/duas/dua_provider.dart';
import '../../pages/settings/pages/app_colors/app_colors_provider.dart';
import '../providers/dua_audio_player_provider.dart';
import '../routes/routes_helper.dart';
import '../utills/app_colors.dart';
import '../widgets/circle_button.dart';

class DuaAudioPlayer extends StatelessWidget {
  const DuaAudioPlayer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    //Dua? duaa = ModalRoute.of(context)!.settings.arguments as Dua;

    DuaProvider duaProvider = Provider.of<DuaProvider>(context);
    Map<String, dynamic> nextDuaData = duaProvider.getNextDua();
    int part1 = nextDuaData['index'];
    Dua nextDua = nextDuaData['dua'];
    int part7 = duaProvider.duaList.length;
    String duaTitle = nextDua.duaTitle.toString();
    //print(nextDua);

    final ValueNotifier<bool> isLoopMoreNotifier = ValueNotifier<bool>(false);
    bool isLoopMore = false;
    return Column(
      mainAxisSize: MainAxisSize.max,
      //mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          margin: EdgeInsets.only(left: 20.w, right: 20.w),
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
                  // SizedBox(
                  //   height: 5.h,
                  // ),
                  Row(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Dua $part1  (Total $part7)',
                            style: const TextStyle(
                              fontFamily: 'satoshi',
                              fontWeight: FontWeight.w500,
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ),
                      //Spacer(),
                      SizedBox(
                        width: 135.h,
                      ),
                      InkWell(
                        onTap: () {
                          // if (reciters.isFav == 0) {
                          //   recitationProvider
                          //       .addFav(reciters.reciterId!);
                          // } else {
                          //   recitationProvider
                          //       .removeFavReciter(reciters.reciterId!);
                          // }
                        },
                        child: Consumer<AppColorsProvider>(
                            builder: (context, appColors, child) {
                          return Container(
                            height: 23.h,
                            width: 23.w,
                            margin: EdgeInsets.only(
                              top: 29.4.h,
                              bottom: 25.h,
                            ),
                            child: CircleAvatar(
                              backgroundColor: appColors.mainBrandingColor,
                              child: SizedBox(
                                height: 21.h,
                                width: 21.w,
                                child: CircleAvatar(
                                  backgroundColor: nextDua.isFav == 1
                                      ? appColors.mainBrandingColor
                                      : Colors.white,
                                  child: Icon(
                                    Icons.favorite,
                                    color: nextDua.isFav == 1
                                        ? Colors.white
                                        : appColors.mainBrandingColor,
                                    size: 13.h,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      )
                    ],
                  ),
                  // SizedBox(
                  //   height: 5.h,
                  // ),
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
                    children: [
                      // IconButton(
                      //   onPressed: () {
                      //     Navigator.of(context).pushNamed(
                      //       RouteHelper.duaPlayList,
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
                                    Text('Loop More On For ${'Dua $part1'}')));
                          } else {
                            isLoopMoreNotifier.value = false;
                            player.audioPlayer.setLoopMode(LoopMode.off);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content:
                                    Text('Loop More Off For ${'Dua $part1'}')));
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
                      const Spacer(),
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
                      const Spacer(),
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

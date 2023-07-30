import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:nour_al_quran/pages/duas/models/dua_category.dart';
import 'package:nour_al_quran/pages/settings/pages/app_them/them_provider.dart';
import 'package:provider/provider.dart';
import '../../pages/duas/provider/dua_provider.dart';
// import '../../pages/duas/models/dua_category.dart';
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
    DuaProvider duaProvider = Provider.of<DuaProvider>(context);
    // Map<String, dynamic> nextDuaData = duaProvider.getNextDua();
    // int index = nextDuaData['index'];

    final ValueNotifier<bool> isLoopMoreNotifier = ValueNotifier<bool>(false);
    // ignore: unused_local_variable
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
            builder: (context, them, player, appColor, duaProv, child) {
              return Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 50.w, right: 35.w, top: 10.h),
                    //decoration: BoxDecoration(border: Border.all(width: 1)),
                    child: const Row(
                      children: [],
                    ),
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
                                content: Text('Loop More On For ${'Dua ${duaProvider.selectedDua!.duaNo!}'}')));
                          } else {
                            isLoopMoreNotifier.value = false;
                            player.audioPlayer.setLoopMode(LoopMode.off);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content:
                                    Text('Loop More Off For ${'Dua ${duaProvider.selectedDua!.duaNo!}'}')));
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
                          Provider.of<DuaProvider>(context, listen: false).playNextDuaInCategory(context);
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

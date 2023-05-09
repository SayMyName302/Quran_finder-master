import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../basics_of_quran/islam_basics_provider.dart';
import '../../../settings/pages/app_colors/app_colors_provider.dart';
import '../../../settings/pages/app_them/them_provider.dart';
import '../../../../shared/localization/localization_constants.dart';
import '../../../../shared/utills/app_colors.dart';
import '../../../../shared/widgets/circle_button.dart';
import '../../../../shared/widgets/title_row.dart';
import 'package:provider/provider.dart';

import '../quran stories/quran_stories_provider.dart';
import 'story_player_provider.dart';

class StoryPlayer extends StatelessWidget {
  const StoryPlayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var fromWhere = ModalRoute.of(context)!.settings.arguments;
    return WillPopScope(
      onWillPop: () async {
        context.read<StoryPlayerProvider>().closePlayer();
        return true;
      },
      child: Scaffold(
        appBar: buildAppBar(
            context: context,
            font: 16.sp,
            title: localeText(context, "now_playing")),
        body: Consumer5<ThemProvider, StoryPlayerProvider, AppColorsProvider,
            QuranStoriesProvider, IslamBasicsProvider>(
          builder: (context, them, player, appColor, story, basics, child) {
            return Column(
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
                              image: Image.asset(
                                player.image,
                              ).image,
                              fit: BoxFit.cover)),
                      margin: EdgeInsets.only(
                          left: 20.w, right: 20.w, bottom: 25.h),
                    ),
                    Text(
                      localeText(
                          context,
                          fromWhere == "fromStory"
                              ? story.selectedQuranStory!.storyTitle!
                              : basics.selectedIslamBasics!.title!),
                      style: TextStyle(
                          fontFamily: 'satoshi',
                          fontWeight: FontWeight.w900,
                          fontSize: 22.sp),
                    )
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: 20.w, right: 20.w, bottom: 30.h, top: 20.h),
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
                              if (fromWhere == "fromStory") {
                                story.goToStoryDetailsPage(
                                    story.currentStoryIndex, context);
                              } else {
                                basics.goToIslamTopicPage(
                                    basics.currentIslamBasics, context);
                              }
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
                          InkWell(
                            onTap: () async {
                              if (!player.isPlaying) {
                                await player.play();
                              } else {
                                await player.pause();
                              }
                            },
                            child: CircleButton(
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
                                  color:
                                      them.isDark ? Colors.white : Colors.black,
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
            );
          },
        ),
      ),
    );
  }
}

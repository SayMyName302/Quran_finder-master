import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:nour_al_quran/pages/featured/provider/featured_provider.dart';
import 'package:nour_al_quran/pages/recitation_category/provider/recitation_category_provider.dart';
import 'package:nour_al_quran/pages/settings/pages/app_colors/app_colors_provider.dart';
import 'package:nour_al_quran/pages/settings/pages/app_them/them_provider.dart';
import 'package:nour_al_quran/shared/localization/localization_constants.dart';
import 'package:nour_al_quran/shared/utills/app_colors.dart';
import 'package:nour_al_quran/shared/widgets/circle_button.dart';
import 'package:provider/provider.dart';

import '../../../shared/providers/story_n_basics_audio_player_provider.dart';
import '../../../shared/widgets/app_bar.dart';
import '../../basics_of_quran/provider/islam_basics_provider.dart';
import '../../quran stories/quran_stories_provider.dart';


class RecitationAudioPlayer extends StatelessWidget {
  const
  RecitationAudioPlayer({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    var recitationProv = Provider.of<RecitationCategoryProvider>(context);
    var fromWhere = ModalRoute.of(context)!.settings.arguments;
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
        body: Consumer6<
            ThemProvider,
            StoryAndBasicPlayerProvider,
            AppColorsProvider,
            QuranStoriesProvider,
            IslamBasicsProvider,
            FeatureProvider>(
          builder:
              (context, them, player, appColor, story, basics, feature, child) {
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
                        fromWhere == "fromRecitation"
                          ?recitationProv.selectedRecitationStory!.title!
                            :''
                           /* ? story.selectedQuranStory!.storyTitle!
                            .toLowerCase()
                            : fromWhere == "fromFeature"
                            ? feature.selectedFeatureStory!.storyTitle!
                            .toLowerCase()
                            : fromWhere == "fromBasic"
                            ? basics.selectedIslamBasics!.title!
                            .toLowerCase()
                            : fromWhere == "fromRecitation"
                            ? recitationProv.selectedRecitationStory!.title!
                            : '', // Add an empty string as a fallback*/
                      ),
                      style: TextStyle(
                        fontFamily: 'satoshi',
                        fontWeight: FontWeight.w900,
                        fontSize: 22.sp,
                      ),
                    ),
                   //Text(recitationProv.selectedRecitationStory!.reference!)

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
                              if (!isLoopMoreNotifier.value) {
                                isLoopMoreNotifier.value = true;
                                player.audioPlayer.setLoopMode(LoopMode.one);
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content:
                                    Text('Loop Mode On For ${recitationProv.selectedRecitationStory!.surahNo!}')));
                              } else {
                                isLoopMoreNotifier.value = false;
                                player.audioPlayer.setLoopMode(LoopMode.off);
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content:
                                    Text('Loop Mode Off For ${recitationProv.selectedRecitationStory!.surahNo!}')));
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
                                      valueColor: AlwaysStoppedAnimation<
                                          Color>(
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
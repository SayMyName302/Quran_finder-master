import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nour_al_quran/pages/qaida/screens/tutorial_player.dart';
import 'package:nour_al_quran/pages/settings/pages/app_them/them_provider.dart';
import 'package:provider/provider.dart';
import '../../../shared/localization/localization_constants.dart';
import '../../../shared/routes/routes_helper.dart';
import '../../../shared/widgets/circle_button.dart';
import '../../quran/pages/recitation/reciter/player/player_provider.dart';
import '../../settings/pages/app_colors/app_colors_provider.dart';
import 'dart:math' as math;

class QaidaPlayer extends StatefulWidget {
  final bool updateLoopVal;
  final bool isAudioPlaying;
  final void Function() stopAudio;
  final Function(bool) toggleLoop;
  final void Function() playButton;
  final VoidCallback onIndexPressed;
  final void Function() skipPrevious;
  final void Function() skipNext;
  final bool updateMultipleSelectionEnabled;
  final void Function(bool value) selectWords;
  final int selectedIndex; // Added argument for selected index
  final void Function() clearstate;

  const QaidaPlayer({
    super.key,
    required this.selectWords, //To pass the updated value to swipePages
    required this.playButton, //To pass the updated value to swipePages
    required this.stopAudio,
    required this.isAudioPlaying, //To pass the updated value to swipePages
    required this.toggleLoop, // Passing val from this screen to swipe
    required this.updateLoopVal, //Receiving val from swipe to this screen
    required this.onIndexPressed, // Added callback for index pressed
    required this.skipPrevious,
    required this.skipNext,
    required this.updateMultipleSelectionEnabled, //To Disable Select Words After the Audio is played/OnPage Changed
    required this.selectedIndex,
    required this.clearstate, // To clear Start/End Index Icon when Multi-Play is tapped
  });

  @override
  // ignore: library_private_types_in_public_api
  _QaidaPlayerState createState() => _QaidaPlayerState();
}

class _QaidaPlayerState extends State<QaidaPlayer> {
  int currentTab = 0;
  bool isAudioPlaying = false;
  bool isActive = false;
  bool loop = false;

  @override
  Widget build(BuildContext context) {
    String currentLanguage = Localizations.localeOf(context).languageCode;

    isActive = widget.updateMultipleSelectionEnabled;
    loop = widget.updateLoopVal;
    Color appColor = context.read<AppColorsProvider>().mainBrandingColor;
    final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    ThemProvider them = Provider.of<ThemProvider>(context);
    Future.delayed(
      Duration.zero,
      () => context.read<RecitationPlayerProvider>().pause(context),
    );

    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          margin: EdgeInsets.only(left: 20.w, right: 20.w),
          //  decoration: BoxDecoration(border: Border.all(width: 1)),
          width: double.maxFinite,
          child: Column(
            children: [
              Container(
                width: double.maxFinite,
                //decoration: BoxDecoration(border: Border.all(width: 1)),
                margin: EdgeInsets.only(left: 14.w),
                child: Column(
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              isActive = !isActive;
                            });
                            widget.selectWords(isActive);
                            if (!isActive) {
                              widget.clearstate();
                            }
                            analytics.logEvent(
                              name: 'qaida_checkbox_tap',
                            );
                          },
                          child: Row(
                            children: [
                              Checkbox(
                                activeColor: appColor,
                                value: isActive,
                                onChanged: (value) {
                                  setState(() {
                                    isActive = !isActive;
                                  });
                                  widget.selectWords(isActive);
                                  if (!isActive) {
                                    widget.clearstate();
                                  }
                                  analytics.logEvent(
                                    name: 'qaida_checkbox_tap',
                                  );
                                },
                                visualDensity: VisualDensity.compact,
                              ),
                              Text(
                                localeText(context, 'multi_play'),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 8.h,
                        ),
                        InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Stack(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Container(
                                        color: Colors.black.withOpacity(0.5),
                                      ),
                                    ),
                                    Dialog(
                                      alignment: Alignment.topCenter,
                                      backgroundColor: Colors.transparent,
                                      elevation: 0.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      child: const FractionallySizedBox(
                                        widthFactor: 1.12,
                                        heightFactor: 0.8,
                                        child: VideoPlayerWidget(),
                                      ),
                                    ),
                                    Positioned(
                                      top: 10.0,
                                      right: 10.0,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 24.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                            analytics.logEvent(
                              name: 'qaida_tutorialbutton_tap',
                            );
                          },
                          child: Image.asset(
                            'assets/images/app_icons/info.png',
                            height: 18.h,
                            width: 18.w,
                          ),
                        ),

                        // SizedBox(
                        //   width: 220.h,
                        // ),
                        const Spacer(),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        loop = !loop;
                      });
                      widget.toggleLoop(loop);
                      //  print('value of loop is : $loop');
                      analytics.logEvent(
                        name: 'qaida_loopmore_tap',
                      );
                    },
                    icon: Image.asset(
                      'assets/images/app_icons/repeat.png',
                      height: 30.h,
                      width: 30.w,
                      color: loop
                          ? appColor
                          : (Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black),
                    ),
                    padding: EdgeInsets.zero,
                    alignment: Alignment.center,
                  ),
                  Transform(
                    alignment:
                        currentLanguage == 'ar' || currentLanguage == 'ur'
                            ? Alignment.center
                            : Alignment.center,
                    transform: Matrix4.rotationY(
                      (currentLanguage == 'ar' || currentLanguage == 'ur')
                          ? math.pi
                          : 0,
                    ),
                    child: IconButton(
                      onPressed: () async {
                        // Provider.of<DuaProvider>(context, listen: false)
                        //     .playPreviousDuaInCategory(context);
                        widget.skipNext();
                        analytics.logEvent(
                          name: 'qaida_skipNext_tap',
                        );
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
                  ),
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          widget.playButton();
                          // print('play button tapped');

                          analytics.logEvent(
                            name: 'qaida_playButton_tap',
                          );
                        },
                        child: CircleButton(
                          height: 63.h,
                          width: 63.h,
                          icon: Icon(
                            widget.isAudioPlaying
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            size: 40.h,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Transform(
                    alignment:
                        currentLanguage == 'ar' || currentLanguage == 'ur'
                            ? Alignment.center
                            : Alignment.center,
                    transform: Matrix4.rotationY(
                      (currentLanguage == 'ar' || currentLanguage == 'ur')
                          ? math.pi
                          : 0,
                    ),
                    child: IconButton(
                      onPressed: () async {
                        widget.skipPrevious();

                        analytics.logEvent(
                          name: 'qaida_skipPrevious_tap',
                        );
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
                  ),
                  IconButton(
                    onPressed: () {
                      widget.stopAudio();
                      Navigator.pushNamed(context, RouteHelper.qaidapageindex);
                      widget.onIndexPressed();
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
          ),
        ),
      ],
    );
  }
}

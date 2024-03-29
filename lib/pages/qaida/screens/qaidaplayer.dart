import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nour_al_quran/pages/qaida/screens/tutorial_player.dart';
import 'package:nour_al_quran/pages/settings/pages/app_them/them_provider.dart';
import 'package:provider/provider.dart';
import '../../../shared/routes/routes_helper.dart';
import '../../../shared/widgets/circle_button.dart';
import '../../quran/pages/recitation/reciter/player/player_provider.dart';
import '../../settings/pages/app_colors/app_colors_provider.dart';

class QaidaPlayer extends StatefulWidget {
  final bool updateLoopVal;
  final bool isAudioPlaying;
  final void Function() stopAudio;
  final Function(bool) toggleLoop;
  final void Function() playButton;
  final VoidCallback onIndexPressed;
  final bool updateMultipleSelectionEnabled;
  final void Function(bool value) selectWords;
  final int selectedIndex; // Added argument for selected index

  const QaidaPlayer({
    super.key,
    required this.selectWords, //To pass the updated value to swipePages
    required this.playButton, //To pass the updated value to swipePages
    required this.stopAudio,
    required this.isAudioPlaying, //To pass the updated value to swipePages
    required this.toggleLoop, // Passing val from this screen to swipe
    required this.updateLoopVal, //Receiving val from swipe to this screen
    required this.onIndexPressed, // Added callback for index pressed
    required this.updateMultipleSelectionEnabled, //To Disable Select Words After the Audio is played/OnPage Changed
    required this.selectedIndex,
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
    isActive = widget.updateMultipleSelectionEnabled;
    loop = widget.updateLoopVal;
    Color appColor = context.read<AppColorsProvider>().mainBrandingColor;
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
                margin: EdgeInsets.only(left: 10.w),
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
                          },
                          child: Row(
                            children: [
                              Checkbox(
                                value: isActive,
                                onChanged: (value) {
                                  setState(() {
                                    isActive = !isActive;
                                  });
                                  widget.selectWords(isActive);
                                },
                                visualDensity: VisualDensity.compact,
                              ),
                              const Text('Multi-Play'),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 30.h,
                        ),
                        InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const AlertDialog(
                                  backgroundColor: Colors.transparent,
                                  elevation: 0.0,
                                  contentPadding: EdgeInsets.zero,
                                  content: SizedBox(
                                    width: double.maxFinite,
                                    height: 500.0,
                                    child: VideoPlayerWidget(),
                                  ),
                                );
                              },
                            );
                          },
                          child: Image.asset(
                            'assets/images/app_icons/info.png',
                            height: 15.h,
                            width: 15.w,
                            // color: them.isDark ? Colors.white : Colors.black,
                          ),
                        ),
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
                  IconButton(
                    onPressed: () async {
                      // Provider.of<DuaProvider>(context, listen: false)
                      //     .playPreviousDuaInCategory(context);
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
                      GestureDetector(
                        onTap: () {
                          widget.playButton();
                          // print('play button tapped');
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
                  IconButton(
                    onPressed: () async {
                      // Provider.of<DuaProvider>(context, listen: false)
                      //     .playNextDuaInCategory(context);
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

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:just_audio/just_audio.dart';
import 'package:nour_al_quran/pages/settings/pages/app_them/them_provider.dart';
import 'package:provider/provider.dart';

// import '../../../shared/utills/app_colors.dart';
import '../../../shared/widgets/circle_button.dart';

class QaidaPlayer extends StatefulWidget {
  final void Function(bool value) selectWords;
  final void Function() playButton;
  final void Function() stopButton;
  final bool isAudioPlaying;
  // final Function(bool) updateMultipleSelectionEnabled;

  const QaidaPlayer({
    super.key,
    required this.selectWords,
    required this.playButton,
    required this.stopButton,
    required this.isAudioPlaying,
    // required this.updateMultipleSelectionEnabled,
  });

  @override
  // ignore: library_private_types_in_public_api
  _QaidaPlayerState createState() => _QaidaPlayerState();
}

class _QaidaPlayerState extends State<QaidaPlayer> {
  int currentTab = 0;
  // double _currentSliderValue = 0;
  bool isAudioPlaying = false;
  bool isActive = false;

  @override
  Widget build(BuildContext context) {
    ThemProvider them = Provider.of<ThemProvider>(context);

    // DuaProvider duaProvider = Provider.of<DuaProvider>(context);
    // Map<String, dynamic> nextDuaData = duaProvider.getNextDua();
    // int? index = nextDuaData['index'];
    // Dua nextDua = nextDuaData['dua'];
    // int part7 = duaProvider.duaList.length;
    // String duaTitle = nextDua.duaTitle.toString();
    // String duaRef = nextDua.duaRef.toString();
    // String duaText = nextDua.duaText.toString();
    // int? duaCount = nextDua.ayahCount;
    // String duaTranslation = nextDua.translations.toString();

    //print(nextDua);
    // final ValueNotifier<bool> isLoopMoreNotifier = ValueNotifier<bool>(false);
    // // ignore: unused_local_variable
    // bool isLoopMore = false;

    return Column(mainAxisSize: MainAxisSize.max, children: [
      Container(
          margin: EdgeInsets.only(left: 10.w, top: 30.h),
          width: double.maxFinite,
          child: Column(
            children: [
              // Row(
              //   children: [
              //     Text(
              //         "${player.duration.inHours}:${player.duration.inMinutes.remainder(60)}:${player.duration.inSeconds.remainder(60)}"),
              //     SliderTheme(
              //       data: SliderThemeData(
              //           overlayShape: SliderComponentShape.noOverlay,
              //           trackHeight: 9.h,
              //           thumbShape: const RoundSliderThumbShape(
              //             elevation: 0.0,
              //             enabledThumbRadius: 6,
              //           )),
              //       child: Expanded(
              //         child: Container(
              //           margin: EdgeInsets.only(left: 7.w, right: 7.w),
              //           child: Slider(
              //             min: 0.0,
              //             thumbColor: appColor.mainBrandingColor,
              //             activeColor: appColor.mainBrandingColor,
              //             inactiveColor: AppColors.lightBrandingColor,
              //             max: player.duration.inSeconds.toDouble(),
              //             value: player.position.inSeconds.toDouble(),
              //             onChanged: (value) {
              //               final position =
              //                   Duration(seconds: value.toInt());
              //               player.audioPlayer.seek(position);
              //             },
              //           ),
              //         ),
              //       ),
              //     ),
              //     Text(
              //         '- ${player.position.inMinutes.remainder(60)}:${player.position.inSeconds.remainder(60)}'),
              //   ],
              // ),
              // SizedBox(
              //   height: 10.h,
              // ),
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
                  // IconButton(
                  //   onPressed: () {

                  //   },
                  //   icon: ValueListenableBuilder<bool>(
                  //     valueListenable: isLoopMoreNotifier,
                  //     builder: (context, isLoopMore, child) {
                  //       return Image.asset(
                  //         'assets/images/app_icons/repeat.png',
                  //         height: 30.h,
                  //         width: 30.w,
                  //         color: isLoopMore
                  //             ? appColor.mainBrandingColor
                  //             : Theme.of(context).brightness ==
                  //                     Brightness.dark
                  //                 ? Colors.white
                  //                 : Colors.black,
                  //       );
                  //     },
                  //   ),
                  //   padding: EdgeInsets.zero,
                  //   alignment: Alignment.center,
                  // ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        isActive = !isActive;
                      });
                      widget.selectWords(isActive);
                      print('Button Value: $isActive');
                    },
                    child: Text(
                      'Select Specific words',
                      style: TextStyle(
                        fontSize: 10,
                        decoration: TextDecoration.underline,
                        color: isActive || widget.isAudioPlaying
                            ? Colors.green
                            : Colors.black,
                      ),
                    ),
                  ),

                  const Spacer(),
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
                  SizedBox(
                    width: 15.h,
                  ),
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          widget.playButton();
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

                  SizedBox(
                    width: 15.h,
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
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      // Navigator.of(context).pushNamed(
                      //   RouteHelper.duaPlayList,
                      // );
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

                  SizedBox(
                    width: 15.h,
                  ),
                ],
              ),
            ],
          ))
    ]);
  }
}

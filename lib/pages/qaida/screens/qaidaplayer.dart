import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:just_audio/just_audio.dart';
import 'package:nour_al_quran/pages/settings/pages/app_them/them_provider.dart';
import 'package:provider/provider.dart';

// import '../../../shared/utills/app_colors.dart';
import '../../../shared/routes/routes_helper.dart';
import '../../../shared/widgets/circle_button.dart';
import '../../settings/pages/app_colors/app_colors_provider.dart';

class QaidaPlayer extends StatefulWidget {
  final void Function(bool value) selectWords;
  final void Function() playButton;
  final void Function() stopButton;
  final bool isAudioPlaying;
  final bool updateMultipleSelectionEnabled;

  const QaidaPlayer({
    super.key,
    required this.selectWords, //To pass the updated value to swipePages
    required this.playButton, //To pass the updated value to swipePages
    required this.stopButton, //To pass the updated value to swipePages
    required this.isAudioPlaying, //To pass the updated value to swipePages
    required this.updateMultipleSelectionEnabled, //To Disable Select Words After the Audio is played
  });

  @override
  // ignore: library_private_types_in_public_api
  _QaidaPlayerState createState() => _QaidaPlayerState();
}

class _QaidaPlayerState extends State<QaidaPlayer> {
  int currentTab = 0;
  bool isAudioPlaying = false;
  bool isActive = false;

  @override
  Widget build(BuildContext context) {
    Color appColor = context.read<AppColorsProvider>().mainBrandingColor;
    ThemProvider them = Provider.of<ThemProvider>(context);

    final ValueNotifier<bool> isLoopMoreNotifier = ValueNotifier<bool>(false);
    // ignore: unused_local_variable
    bool isLoopMore = false;

    return Column(mainAxisSize: MainAxisSize.max, children: [
      Container(
          margin: EdgeInsets.only(top: 25.h),
          //decoration: BoxDecoration(border: Border.all(width: 1)),
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            isActive = !isActive;
                          });
                          widget.selectWords(isActive);
                          isActive = widget.updateMultipleSelectionEnabled;
                        },
                        child: Row(
                          //    crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 20.h,
                            ),
                            Text(
                              'Select Words',
                              style: TextStyle(
                                fontSize: 10,
                                decoration: TextDecoration.underline,
                                color: isActive || widget.isAudioPlaying
                                    ? Colors.green
                                    : Colors.black,
                              ),
                            ),
                            // Checkbox(
                            //   value: isActive,
                            //   onChanged: (bool? newValue) {
                            //     setState(() {
                            //       isActive = newValue ?? false;
                            //     });
                            //     widget.selectWords(isActive);
                            //     //      print('Checkbox Value: $isActive');
                            //   },
                            //   visualDensity: VisualDensity.compact,
                            // ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: ValueListenableBuilder<bool>(
                          valueListenable: isLoopMoreNotifier,
                          builder: (context, isLoopMore, child) {
                            return Image.asset(
                              'assets/images/app_icons/repeat.png',
                              height: 30.h,
                              width: 30.w,
                              color: isLoopMore
                                  ? appColor
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
                    ],
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
                    width: 10.h,
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

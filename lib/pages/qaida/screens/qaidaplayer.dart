import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:just_audio/just_audio.dart';
import 'package:nour_al_quran/pages/settings/pages/app_them/them_provider.dart';
import 'package:provider/provider.dart';

// import '../../../shared/utills/app_colors.dart';
import '../../../shared/routes/routes_helper.dart';
import '../../../shared/widgets/circle_button.dart';
import '../../quran/pages/recitation/reciter/player/player_provider.dart';
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
    isActive = widget.updateMultipleSelectionEnabled;
    Color appColor = context.read<AppColorsProvider>().mainBrandingColor;
    ThemProvider them = Provider.of<ThemProvider>(context);
    Future.delayed(
      Duration.zero,
      () => context.read<RecitationPlayerProvider>().pause(context),
    );

    final ValueNotifier<bool> isLoopMoreNotifier = ValueNotifier<bool>(false);
    bool isLoopMore = false;

    return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
              margin: EdgeInsets.only(left: 20.w, right: 20.w),
              //    decoration: BoxDecoration(border: Border.all(width: 1)),
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
                          // mainAxisAlignment: MainAxisAlignment.start,

                          // crossAxisAlignment: CrossAxisAlignment.end,
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
                                  const Text('Select Words'),
                                ],
                              ),
                            ),
                            // Text('dsdds'),
                            // Text('dsdds'),
                            // Text('dsdds'),
                            // Text('dsdds'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
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
                    ],
                  ),
                ],
              ))
        ]);
  }
}

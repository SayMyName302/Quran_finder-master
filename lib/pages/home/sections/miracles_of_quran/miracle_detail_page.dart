import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:nour_al_quran/pages/settings/pages/app_colors/app_colors_provider.dart';
import 'package:nour_al_quran/pages/settings/pages/fonts/font_provider.dart';
import '../../../../shared/localization/localization_constants.dart';
import '../../../../shared/widgets/circle_button.dart';
import '../../../../shared/widgets/title_row.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'miracles.dart';
import 'miracles_of_quran_provider.dart';

class MiraclesDetailsPage extends StatefulWidget {
  const MiraclesDetailsPage({Key? key}) : super(key: key);

  @override
  State<MiraclesDetailsPage> createState() => _MiraclesDetailsPageState();
}

class _MiraclesDetailsPageState extends State<MiraclesDetailsPage> {
  late VideoPlayerController _controller;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(
        context.read<MiraclesOfQuranProvider>().videoUrl!)
      ..initialize().then((value) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FontProvider fontProvider = Provider.of<FontProvider>(context);
    Miracles miracles =
        context.read<MiraclesOfQuranProvider>().selectedMiracle!;
    return Scaffold(
      appBar: buildAppBar(
          context: context,
          title: localeText(context, miracles.title!.toLowerCase())),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          _controller.value.isInitialized
              ? InkWell(
                  onTap: () {
                    setState(() {
                      _controller.value.isPlaying
                          ? _controller.pause()
                          : _controller.play();
                    });
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                          height: 200,
                          margin: EdgeInsets.only(
                              left: 20.w, right: 20.w, top: 10.h),
                          width: double.maxFinite,
                          color: Colors.red,
                          child: AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: VideoPlayer(_controller),
                          )),
                      Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Container(
                              height: 15.h,
                              margin: EdgeInsets.only(left: 20.w, right: 20.w),
                              child: VideoProgressIndicator(_controller,
                                  allowScrubbing: true))),
                      Positioned(
                          left: 0,
                          right: 0,
                          child: !_controller.value.isPlaying
                              ? CircleButton(
                                  height: 50.h,
                                  width: 50.h,
                                  icon: const Icon(Icons.play_arrow_rounded),
                                )
                              : const SizedBox.shrink())
                    ],
                  ),
                )
              : const SizedBox.shrink(),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(
                    left: 20.w, right: 20.w, top: 16.h, bottom: 16.h),
                alignment: Alignment.center,
                child: HtmlWidget(
                  miracles.text!,
                  textStyle: TextStyle(
                    fontFamily: 'satoshi',
                    fontSize: fontProvider.fontSizeTranslation.sp,
                  ),
                  customStylesBuilder: (element) {
                    // Check if the element is <em>
                    if (element.localName == 'em') {
                      final appColorsProvider =
                          Provider.of<AppColorsProvider>(context);
                      final brandingColor = appColorsProvider.mainBrandingColor;
                      final colorValue =
                          '#${brandingColor.value.toRadixString(16).substring(2)}';
                      return {
                        'color': colorValue
                      }; // Apply mainBrandingColor to the text color
                    }
                    if (element.localName == 'p' &&
                        element.classes.contains('arabic')) {
                      final appColorsProvider =
                          Provider.of<AppColorsProvider>(context);
                      final brandingColor = appColorsProvider.mainBrandingColor;
                      final colorValue =
                          '#${brandingColor.value.toRadixString(16).substring(2)}';
                      return {
                        'color': colorValue
                      }; // Apply mainBrandingColor to the text color
                    }
                    return null; // Return null for other elements to apply default style
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

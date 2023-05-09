import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../../../../settings/pages/app_colors/app_colors_provider.dart';
import '../../../../../shared/localization/localization_constants.dart';

import '../../../../../shared/utills/app_colors.dart';
import '../../../../../shared/widgets/circle_button.dart';
import '../../../../../shared/widgets/title_row.dart';
import 'package:provider/provider.dart';

import '../quran_stories_provider.dart';

class StoryDetailsPage extends StatelessWidget {
  const StoryDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer2<QuranStoriesProvider, AppColorsProvider>(
      builder: (context, story, appColors, child) {
        return Scaffold(
          appBar: buildAppBar(
              context: context,
              title:
                  localeText(context, story.selectedQuranStory!.storyTitle!)),
          body: story.selectedQuranStory!.text != null
              ? SafeArea(
                  child: SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.only(
                          left: 20.w, right: 20.w, top: 16.h, bottom: 16.h),
                      child: story.selectedQuranStory!.text != null
                          ? HtmlWidget(
                              story.selectedQuranStory!.text!,
                              textStyle: TextStyle(
                                fontSize: 12.sp,
                                fontFamily: 'satoshi',
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          : const Center(
                              child: Text('pending'),
                            ),
                    ),
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
          bottomNavigationBar: Container(
            height: 0,
            color: appColors.mainBrandingColor,
            child: Column(
              children: [
                story.isDownloading
                    ? const LinearProgressIndicator()
                    : const SizedBox.shrink(),
                Container(
                  height: 50.h,
                  padding: EdgeInsets.only(left: 20.w, right: 20.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      story.currentStoryIndex > 0
                          ? buildNextPreviousContainer(
                              img: "p",
                              text: "Previous Story",
                              onPress: () {
                                story.gotoNextOrPreviousStory("p");
                              },
                            )
                          : const SizedBox.shrink(),
                      buildPlayContainer(
                          onTap: !story.isDownloading
                              ? () async {
                                  /// audio play and download button for story
                                  // story.checkAudioExist(story.selectedQuranStory!.storyId!, context);
                                }
                              : null,
                          state: "l"),
                      story.currentStoryIndex < story.stories.length - 1
                          ? buildNextPreviousContainer(
                              img: "n",
                              text: "Next Story",
                              onPress: () {
                                story.gotoNextOrPreviousStory("n");
                              })
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  buildPlayContainer({VoidCallback? onTap, required String state}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(left: 3.w, right: 9.w, top: 5.h, bottom: 5.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r), color: Colors.white),
        child: Row(
          children: [
            CircleButton(
              height: 20.h,
              width: 20.w,
              icon: Image.asset(
                "assets/images/app_icons/play_mini.png",
                height: 5.h,
                width: 5.w,
              ),
            ),
            SizedBox(
              width: 9.w,
            ),
            Text(
              state == "l" ? "listening" : 'listen Story',
              style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.mainBrandingColor,
                  fontFamily: 'satoshi',
                  fontWeight: FontWeight.w700),
            )
          ],
        ),
      ),
    );
  }

  buildNextPreviousContainer(
      {required String img,
      required String text,
      required VoidCallback onPress}) {
    return InkWell(
      onTap: onPress,
      child: Container(
        padding: EdgeInsets.only(
            left: img == "p" ? 12.w : 5.w,
            right: img == "p" ? 5.w : 12.w,
            top: 5.h,
            bottom: 5.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: Colors.white)),
        child: Row(
          children: [
            img == "p"
                ? Image.asset(
                    "assets/images/app_icons/previous.png",
                    color: Colors.white,
                    height: 9.h,
                    width: 9.75.w,
                  )
                : const SizedBox.shrink(),
            SizedBox(
              width: 6.w,
            ),
            Text(
              text,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontFamily: 'satoshi',
                  color: Colors.white,
                  fontSize: 10.sp),
            ),
            img == "n"
                ? SizedBox(
                    width: 6.w,
                  )
                : const SizedBox.shrink(),
            img == "n"
                ? Image.asset(
                    "assets/images/app_icons/next.png",
                    color: Colors.white,
                    height: 9.h,
                    width: 9.75.w,
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}

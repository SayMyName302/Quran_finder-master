import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../shared/localization/localization_constants.dart';
import '../../quran/pages/recitation/reciter/player/player_provider.dart';
import '../models/quran_stories.dart';
import '../quran_stories_provider.dart';

class QuranStoriesList extends StatelessWidget {
  const QuranStoriesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int network = Provider.of<int>(context);
    final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

    return Expanded(
      child: Consumer<QuranStoriesProvider>(
        builder: (context, storiesProvider, child) {
          List<QuranStories> activeStories = storiesProvider.stories
              .where((model) => model.status == 'active')
              .toList();
          return storiesProvider.stories.isNotEmpty
              ? GridView.builder(
                  padding: EdgeInsets.only(left: 10.w, right: 0.w),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: activeStories.length,
                  itemBuilder: (context, index) {
                    QuranStories model = activeStories[index];
                    if (model.status != 'active') {
                      return Container(); // Skip inactive items
                    }
                    return InkWell(
                      onTap: () {
                        if (network == 1) {
                          /// if recitation player is on So this line is used to pause the player
                          Future.delayed(
                              Duration.zero,
                              () => context
                                  .read<RecitationPlayerProvider>()
                                  .pause(context));
                          storiesProvider.gotoStoryPlayerPage(
                              model.storyId!, context, index);
                          analytics.logEvent(
                            name: 'quran_stories_section',
                            parameters: {
                              'story_title': model.storyTitle,
                            },
                          );
                        } else {
                          ScaffoldMessenger.of(context)
                            ..removeCurrentSnackBar()
                            ..showSnackBar(
                                const SnackBar(content: Text("No Internet")));
                        }
                      },
                      child: Container(
                        height: 149.h,
                        margin: EdgeInsets.only(right: 9.w, bottom: 9.h),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            image: DecorationImage(
                                image: NetworkImage(model.image!),
                                fit: BoxFit.cover)),
                        child: Container(
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            gradient: const LinearGradient(
                              colors: [
                                Color.fromRGBO(0, 0, 0, 0),
                                Color.fromRGBO(0, 0, 0, 1),
                              ],
                              begin: Alignment.center,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          child: Container(
                            width: double.maxFinite,
                            margin: EdgeInsets.only(
                                left: 6.w, bottom: 8.h, right: 9.w),
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              localeText(
                                  context, model.storyTitle!.toLowerCase()),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.sp,
                                  fontFamily: "satoshi",
                                  fontWeight: FontWeight.w900),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                )
              : const Center(
                  child: CircularProgressIndicator(
                    color: Colors.red,
                  ),
                );
        },
      ),
    );
  }
}

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nour_al_quran/pages/featured/provider/featurevideoProvider.dart';
import 'package:nour_al_quran/pages/miracles_of_quran/provider/miracles_of_quran_provider.dart';
import 'package:nour_al_quran/pages/popular_section/models/PopularModel';
import 'package:nour_al_quran/pages/popular_section/provider/popular_provider.dart';
import 'package:provider/provider.dart';

import '../../../shared/localization/localization_constants.dart';
import '../../quran/pages/recitation/reciter/player/player_provider.dart';

class PopularList extends StatelessWidget {
  const PopularList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int network = Provider.of<int>(context);
    final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

    return Expanded(
      child: Consumer2<PopularProvider, FeaturedMiraclesOfQuranProvider>(
        builder: (context, featureProvider, featuremiraclesProvider, child) {
          List<PopularModelClass> activeStories = featureProvider.feature
              .where((model) => model.status == 'active')
              .toList();
          return featureProvider.feature.isNotEmpty
              ? GridView.builder(
                  padding: EdgeInsets.only(left: 10.w, right: 0.w),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: activeStories.length,
                  itemBuilder: (context, index) {
                    PopularModelClass model = activeStories[index];
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
                          if (model.contentType == "audio") {
                            featureProvider.gotoFeaturePlayerPage(
                                model.surahId!, context, index);
                            analytics.logEvent(
                              name: 'featured_section_audiotiles',
                              parameters: {'title': model.title},
                            );
                          } else if (model.contentType == "Video") {
                            // print(index);
                            // print(model.storyTitle!);

                            /// two ways without creating any separate provider
                            /// directly using MiraclesOfQuranProvider
                            Provider.of<MiraclesOfQuranProvider>(context,
                                    listen: false)
                                .goToMiracleDetailsPageFromFeatured(
                                    model.title!, context, index);
                            analytics.logEvent(
                              name: 'featured_section_videotiles',
                              parameters: {'title': model.title},
                            );

                            /// else u can use your own provider as u create both work fine u can check and give me some
                            /// feedback tomorrow
                            /// u can un comment this and commit out MiraclesOfQuranProvider this provider line to check both
                            // featuremiraclesProvider.goToMiracleDetailsPage(
                            //     model.storyTitle!, context, index);
                          }
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
                                image: AssetImage(
                                    "assets/images/popular_recitations/${model.image!}"),
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
                              localeText(context, model.title!.toLowerCase()),
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

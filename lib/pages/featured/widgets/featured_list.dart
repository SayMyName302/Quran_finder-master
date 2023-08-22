import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nour_al_quran/pages/featured/models/featured.dart';
import 'package:nour_al_quran/pages/featured/provider/featured_provider.dart';
import 'package:nour_al_quran/pages/featured/provider/featurevideoProvider.dart';
import 'package:nour_al_quran/pages/miracles_of_quran/provider/miracles_of_quran_provider.dart';
import 'package:provider/provider.dart';

import '../../../shared/localization/localization_constants.dart';
import '../../../shared/localization/localization_provider.dart';
import '../../../shared/routes/routes_helper.dart';
import '../../quran/pages/recitation/reciter/player/player_provider.dart';
import '../../recitation_category/models/RecitationCategory.dart';
import '../../recitation_category/provider/recitation_category_provider.dart';

class FeaturedList extends StatelessWidget {
  const FeaturedList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int network = Provider.of<int>(context);
    final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

    return Expanded(
      child: Consumer4<FeatureProvider, FeaturedMiraclesOfQuranProvider,
          RecitationCategoryProvider, LocalizationProvider>(
        builder: (context, storiesProvider, featuremiraclesProvider,
            recitationProvider, language, child) {
          List<dynamic> combinedList = [];
          if (storiesProvider.feature.isNotEmpty) {
            combinedList.add(storiesProvider.feature.first);
            if (recitationProvider.recitationCategoryItem.isNotEmpty) {
              combinedList.add(recitationProvider.recitationCategoryItem.first);
            }
            combinedList.addAll(storiesProvider.feature.sublist(1));
          }
          return combinedList.isNotEmpty
              ? GridView.builder(
                  padding: EdgeInsets.only(left: 10.w, right: 0.w),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: combinedList.length,
                  itemBuilder: (context, index) {
                    dynamic model = combinedList[index];

                    return InkWell(
                        onTap: () {
                          if (network == 1) {
                            Future.delayed(
                                Duration.zero,
                                () => context
                                    .read<RecitationPlayerProvider>()
                                    .pause(context));
                            if (model is FeaturedModel) {
                              if (model.contentType == "audio") {
                                storiesProvider.gotoFeaturePlayerPage(
                                    model.storyId!, context, index);
                                analytics.logEvent(
                                  name: 'featured_section_tile_homescreen',
                                  parameters: {'title': model.title},
                                );
                              } else if (model.contentType == "Video") {
                                Provider.of<MiraclesOfQuranProvider>(context,
                                        listen: false)
                                    .goToMiracleDetailsPageFromFeatured(
                                        model.storyTitle!, context, index);
                                analytics.logEvent(
                                  name:
                                      'featured_section_miracle_tile_homescreen',
                                  parameters: {'title': model.title},
                                );
                              }
                            } else if (model is RecitationCategoryModel) {
                              recitationProvider
                                  .getSelectedRecitationAll(model.playlistId!);
                              recitationProvider
                                  .setSelectedRecitationCategory(model);
                              Navigator.of(context).pushNamed(
                                RouteHelper.recitationallcategory,
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context)
                              ..removeCurrentSnackBar()
                              ..showSnackBar(
                                  const SnackBar(content: Text("No Internet")));
                          }
                        },
                        child: Container(
                          width: 209.w,
                          margin: EdgeInsets.only(right: 9.w, bottom: 9.h),
                          decoration: BoxDecoration(
                            color: Colors.amberAccent,
                            borderRadius: BorderRadius.circular(8.r),
                            image: DecorationImage(
                              image: model is RecitationCategoryModel
                                  ? CachedNetworkImageProvider(model.imageURl!)
                                  : NetworkImage("${model.image!}")
                                      as ImageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Container(
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
                              margin: EdgeInsets.only(
                                  left: 6.w, bottom: 8.h, right: 6.w),
                              alignment: language.checkIsArOrUr()
                                  ? Alignment.bottomRight
                                  : Alignment.bottomLeft,
                              child: Text(
                                localeText(
                                  context,
                                  model is RecitationCategoryModel
                                      ? model.playlistName!
                                      : model.storyTitle!,
                                ),
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17.sp,
                                  fontFamily: "satoshi",
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ),
                        ));
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

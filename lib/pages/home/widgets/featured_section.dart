import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nour_al_quran/pages/featured/models/featured.dart';
import 'package:nour_al_quran/pages/featured/provider/featured_provider.dart';
import 'package:nour_al_quran/pages/home/models/friday_content.dart';
import 'package:nour_al_quran/pages/miracles_of_quran/provider/miracles_of_quran_provider.dart';

import 'package:nour_al_quran/shared/localization/localization_provider.dart';
import 'package:nour_al_quran/shared/routes/routes_helper.dart';
import 'package:provider/provider.dart';

import '../../../shared/localization/localization_constants.dart';

import '../../quran/pages/recitation/reciter/player/player_provider.dart';
import '../../recitation_category/models/RecitationCategory.dart';
import '../../recitation_category/provider/recitation_category_provider.dart';
import 'home_row_widget.dart';

class FeaturedSection extends StatelessWidget {
  const FeaturedSection({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    int network = Provider.of<int>(context);
    return Column(
      children: [
        HomeRowWidget(
          text: localeText(context, 'featured'),
          buttonText: localeText(context, "view_all"),
          onTap: () {
            Navigator.of(context).pushNamed(RouteHelper.featured);
            analytics.logEvent(
              name: 'featured_section_viewall_button',
              parameters: {'title': 'featured_viewall'},
            );
          },
        ),
        Consumer4<LocalizationProvider, FeatureProvider,
            RecitationCategoryProvider, MiraclesOfQuranProvider>(
          builder: (context, language, storiesProvider, recitationProvider,
              miraclesProvider, child) {
            List<dynamic> combinedList = [];

            if (storiesProvider.feature.isNotEmpty) {
              combinedList.add(storiesProvider.feature.first);

              if (recitationProvider.recitationCategoryItem.isNotEmpty) {
                combinedList
                    .add(recitationProvider.recitationCategoryItem.first);
              }
              combinedList.addAll(storiesProvider.feature.sublist(1));
            }

            //This code is For Friday Filter
            if (miraclesProvider.friday.isNotEmpty &&
                miraclesProvider.friday.first.contentType == "video") {
              combinedList.add(miraclesProvider.friday.first);
            } else if (storiesProvider.friday.isNotEmpty &&
                storiesProvider.friday.first.contentType == "audio") {
              combinedList.add(storiesProvider.friday.first);
            }

            return SizedBox(
              height: 150.h,
              child: ListView.builder(
                itemCount: combinedList.length,
                padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 14.h),
                scrollDirection: Axis.horizontal,
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
                              name: 'featured_section_miracle_tile_homescreen',
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
                        } else if (model is Friday) {
                          if (model.contentType == "audio") {
                            print('<<<<<<<>>>>>>>>');
                            print(model.recitationId);
                            storiesProvider.gotoFeaturePlayerPageF(
                                model.recitationId!, context, index);
                          } else if (model.contentType == "video") {
                            miraclesProvider.gotoMiracleDetailsPage(
                                model.title!, context, model.recitationId!);
                          }
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
                      margin: EdgeInsets.only(right: 10.w),
                      decoration: BoxDecoration(
                        color: Colors.amberAccent,
                        borderRadius: BorderRadius.circular(8.r),
                        image: DecorationImage(
                          image: model is RecitationCategoryModel
                              ? CachedNetworkImageProvider(model.imageURl!)
                              : model is FeaturedModel
                                  ? NetworkImage(model.image!)
                                  : model is Friday
                                      ? NetworkImage(model.appImageUrl!)
                                          as ImageProvider
                                      : const AssetImage(
                                          'path_to_fallback_image'),
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
                                  : model is FeaturedModel
                                      ? model.storyTitle!
                                      : model is Friday
                                          ? model
                                              .title! // Adjust property accordingly
                                          : "",
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
                    ),
                  );
                },
              ),
            );
          },
        )
      ],
    );
  }
}

//
// Consumer3<LocalizationProvider, FeatureProvider,
//             RecitationCategoryProvider>(
//           builder:
//               (context, language, storiesProvider, recitationProvider, child) {
//             // Combine the recitation categories and featured stories
//             List<dynamic> combinedList = [
//               ...storiesProvider.feature,
//               ...recitationProvider.recitationCategoryList,
//             ];
//             return SizedBox(
//               height: 150.h,
//               child: ListView.builder(
//                 itemCount: combinedList.length,
//                 padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 14.h),
//                 scrollDirection: Axis.horizontal,
//                 itemBuilder: (context, index) {
//                   dynamic model = combinedList[index];

//                   // FeaturedModel model = storiesProvider.feature[index];
//                   // print('Inside listview: ${model.storyTitle}');
//                   // if (model.status != 'active') {
//                   //   return Container();
//                   // }
//                   return InkWell(
//                     onTap: () {
//                       if (network == 1) {
//                         Future.delayed(
//                             Duration.zero,
//                             () => context
//                                 .read<RecitationPlayerProvider>()
//                                 .pause(context));
//                         if (model.contentType == "audio") {
//                           storiesProvider.gotoFeaturePlayerPage(
//                               model.storyId!, context, index);
//                           analytics.logEvent(
//                             name: 'featured_section_tile_homescreen',
//                             parameters: {'title': model.title},
//                           );
//                         } else if (model.contentType == "Video") {
//                           Provider.of<MiraclesOfQuranProvider>(context,
//                                   listen: false)
//                               .goToMiracleDetailsPageFromFeatured(
//                                   model.storyTitle!, context, index);
//                           analytics.logEvent(
//                             name: 'featured_section_miracle_tile_homescreen',
//                             parameters: {'title': model.title},
//                           );
//                         }
//                       } else {
//                         ScaffoldMessenger.of(context)
//                           ..removeCurrentSnackBar()
//                           ..showSnackBar(
//                               const SnackBar(content: Text("No Internet")));
//                       }
//                     },
//                     child: Container(
//                       width: 209.w,
//                       margin: EdgeInsets.only(right: 10.w),
//                       decoration: BoxDecoration(
//                         color: Colors.amberAccent,
//                         borderRadius: BorderRadius.circular(8.r),
//                         image: DecorationImage(
//                           image: model is RecitationCategoryModel
//                               ? CachedNetworkImageProvider(model.imageURl!)
//                               : AssetImage(
//                                       "assets/images/quran_feature/${model.image!}")
//                                   as ImageProvider,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                       child: Container(
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(8.r),
//                           gradient: const LinearGradient(
//                             colors: [
//                               Color.fromRGBO(0, 0, 0, 0),
//                               Color.fromRGBO(0, 0, 0, 1),
//                             ],
//                             begin: Alignment.center,
//                             end: Alignment.bottomCenter,
//                           ),
//                         ),
//                         child: Container(
//                           margin: EdgeInsets.only(
//                               left: 6.w, bottom: 8.h, right: 6.w),
//                           alignment: language.checkIsArOrUr()
//                               ? Alignment.bottomRight
//                               : Alignment.bottomLeft,
//                           child: Text(
//                             localeText(
//                               context,
//                               model is RecitationCategoryModel
//                                   ? model.playlistName!
//                                   : model.storyTitle!,
//                             ),
//                             textAlign: TextAlign.left,
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 17.sp,
//                               fontFamily: "satoshi",
//                               fontWeight: FontWeight.w900,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             );
//           },
//         )


/*
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nour_al_quran/pages/featured/models/featured.dart';
import 'package:nour_al_quran/pages/featured/provider/featured_provider.dart';
import 'package:nour_al_quran/pages/miracles_of_quran/provider/miracles_of_quran_provider.dart';

import 'package:nour_al_quran/shared/localization/localization_provider.dart';
import 'package:nour_al_quran/shared/routes/routes_helper.dart';
import 'package:provider/provider.dart';

import '../../../shared/localization/localization_constants.dart';

import '../../quran/pages/recitation/reciter/player/player_provider.dart';
import 'home_row_widget.dart';

class FeaturedSection extends StatelessWidget {
  const FeaturedSection({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    int network = Provider.of<int>(context);
    return Column(
      children: [
        HomeRowWidget(
          text: localeText(context, 'featured'),
          buttonText: localeText(context, "view_all"),
          onTap: () {
            Navigator.of(context).pushNamed(RouteHelper.featured);
            analytics.logEvent(
              name: 'featured_section_viewall_button',
              parameters: {'title': 'featured_viewall'},
            );
          },
        ),
        Consumer2<LocalizationProvider, FeatureProvider>(
          builder: (context, language, storiesProvider, child) {
            return SizedBox(
              height: 150.h,
              child: ListView.builder(
                itemCount: storiesProvider.feature.length,
                padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 14.h),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  try {
                    FeaturedModel model = storiesProvider.feature[index];
                    if (model.status != 'active') {
                      return Container();
                    }
                    return InkWell(
                      onTap: () {
                        if (network == 1) {
                          Future.delayed(
                              Duration.zero,
                              () => context
                                  .read<RecitationPlayerProvider>()
                                  .pause(context));
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
                              name: 'featured_section_miracle_tile_homescreen',
                              parameters: {'title': model.title},
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
                        margin: EdgeInsets.only(right: 10.w),
                        decoration: BoxDecoration(
                            color: Colors.amberAccent,
                            borderRadius: BorderRadius.circular(8.r),
                            image: DecorationImage(
                                image: AssetImage(
                                    "assets/images/quran_feature/${model.image!}"),
                                fit: BoxFit.cover)),
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
                            alignment: language.locale.languageCode == "ur" ||
                                    language.locale.languageCode == "ar"
                                ? Alignment.bottomRight
                                : Alignment.bottomLeft,
                            child: Text(
                              localeText(context, model.storyTitle!),
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17.sp,
                                  fontFamily: "satoshi",
                                  fontWeight: FontWeight.w900),
                            ),
                          ),
                        ),
                      ),
                    );
                  } catch (error) {
                    print("Error: $error");
                    return Container(); // Placeholder for error handling
                  }
                },
              ),
            );
          },
        )
      ],
    );
  }
}

*/
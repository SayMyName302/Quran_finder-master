import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nour_al_quran/pages/featured/provider/featurevideoProvider.dart';
import 'package:nour_al_quran/pages/home/provider/home_provider.dart';
import 'package:nour_al_quran/pages/miracles_of_quran/provider/miracles_of_quran_provider.dart';
import 'package:nour_al_quran/pages/popular_section/provider/popular_provider.dart';

import 'package:nour_al_quran/shared/localization/localization_provider.dart';
import 'package:nour_al_quran/shared/routes/routes_helper.dart';
import 'package:provider/provider.dart';

import '../../../shared/localization/localization_constants.dart';

import '../../quran/pages/recitation/reciter/player/player_provider.dart';
import 'home_row_widget.dart';
import 'package:nour_al_quran/pages/popular_section/models/popular_model.dart';

class PopularSection extends StatelessWidget {
  const PopularSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    int network = Provider.of<int>(context);
    // final authProvider = Provider.of<SignInProvider>(context);

    final user = Provider.of<HomeProvider>(context);
    String? selectedTitleText = user.selectedTitleText;
    // final userEmail = authProvider.userEmail;
    // bool isSpecialUser = (userEmail == "u@u.com" ||
    //     userEmail == "ahsanalikhan200@gmail.com" ||
    //     userEmail == "ahsanalikhan538@gmail.com" ||
    //     userEmail == "canzinternal3@gmail.com");
    return Column(
      children: [
        HomeRowWidgetTest(
          text: selectedTitleText ?? 'Popular Recitations',
          buttonText: localeText(context, "view_all"),
          onTap: () {
            Navigator.of(context).pushNamed(RouteHelper.popular);
            analytics.logEvent(
              name: 'popular_section_viewall_button',
              parameters: {'title': 'popular_viewall'},
            );
          },
        ),
        //  HomeRowWidget(
        //     text: localeText(context, 'popular'),
        //     buttonText: localeText(context, "view_all"),
        //     onTap: () {
        //       Navigator.of(context).pushNamed(RouteHelper.popular);
        //       analytics.logEvent(
        //         name: 'popular_section_viewall_button',
        //         parameters: {'title': 'popular_viewall'},
        //       );
        //     },
        //   ),
        Consumer3<LocalizationProvider,PopularProvider, FeaturedMiraclesOfQuranProvider>(
          builder: (context, language, storiesProvider, featureMiraclesProvider,  child) {
            return SizedBox(
              height: 150.h,
              child: ListView.builder(
                itemCount: storiesProvider.feature.length,
                padding:
                EdgeInsets.only(left: 20.w, right: 20.w, bottom: 14.h),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  // try {
                    PopularModelClass model = storiesProvider.feature[index];

                    if (model.status != 'active') {
                      return Container(); // Skip inactive items
                    }
                    return InkWell(
                      onTap: () {
                        if (network == 1) {
                          Future.delayed(Duration.zero, () => context.read<RecitationPlayerProvider>().pause(context));
                          if (model.contentType == "audio") {
                            storiesProvider.gotoFeaturePlayerPage(model.surahId!, context, index);
                            analytics.logEvent(
                              name: 'featured_section_tile_homescreen',
                              parameters: {'title': model.title},
                            );
                          } else if (model.contentType == "Video") {
                            // print(index);
                            // print(model.storyTitle!);
                            /// two ways without creating any separate provider
                            /// directly using MiraclesOfQuranProvider
                            Provider.of<MiraclesOfQuranProvider>(context, listen: false).goToMiracleDetailsPageFromFeatured(
                                model.title!, context, index);
                            analytics.logEvent(
                              name:
                              'featured_section_miracle_tile_homescreen',
                              parameters: {'title': model.title},
                            );

                            /// else u can use your own provider as u create both work fine u can check and give me some
                            /// feedback tomorrow
                            /// u can un comment this and commit out MiraclesOfQuranProvider this provider line to check both
                            // featuremiraclesProvider.goToMiracleDetailsPage(
                            //     model.title!, context, index);
                          }
                          // storiesProvider.gotoFeaturePlayerPage(
                          //     model.storyId!, context, index);
                        } else {
                          ScaffoldMessenger.of(context)
                            ..removeCurrentSnackBar()
                            ..showSnackBar(const SnackBar(
                                content: Text("No Internet")));
                        }
                      },
                      child: Container(
                        width: 250.w,
                        margin: EdgeInsets.only(right: 10.w),
                        decoration: BoxDecoration(
                          color: Colors.amberAccent,
                          borderRadius: BorderRadius.circular(8.r),
                          image: DecorationImage(
                            image: AssetImage(
                                "assets/images/popular_recitations/${model.image}"),
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
                            alignment:
                            language.checkIsArOrUr()
                                ? Alignment.bottomRight
                                : Alignment.bottomLeft,
                            child: Column(
                              crossAxisAlignment:
                              language.checkIsArOrUr()
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  localeText(context, model.title!),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17.sp,
                                    fontFamily: "satoshi",
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                SizedBox(height: 4.h), // Add some space between the title and reference text
                                // Text(localeText(context, model.reference!), // Display the reference text
                                //   textAlign: language.locale.languageCode ==
                                //       "ur" ||
                                //       language.locale.languageCode ==
                                //           "ar"
                                //       ? TextAlign.right
                                //       : TextAlign.left,
                                //   style: TextStyle(
                                //     color: Colors.white,
                                //     fontSize: 15.sp,
                                //     fontFamily:
                                //     "satoshi", // Replace with the actual font family
                                //     fontWeight: FontWeight
                                //         .bold, // Customize the style as needed
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  // } catch (error) {
                  //   print("Error:>> $error");
                  //   return Container(); // Placeholder for error handling
                  // }
                },
              ),
            );
          },
        )
      ],
    );
  }
}

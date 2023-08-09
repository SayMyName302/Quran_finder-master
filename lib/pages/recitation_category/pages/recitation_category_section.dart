// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:nour_al_quran/pages/quran/pages/recitation/provider.dart';
// import 'package:nour_al_quran/pages/recitation_category/models/RecitationCategory.dart';
//
// import 'package:nour_al_quran/shared/localization/localization_provider.dart';
// import 'package:nour_al_quran/shared/routes/routes_helper.dart';
// import 'package:provider/provider.dart';
//
// import '../../../shared/localization/localization_constants.dart';
//
// import '../../home/widgets/home_row_widget.dart';
// import '../../quran/pages/recitation/reciter/player/player_provider.dart';
// import '../provider/recitation_category_provider.dart';
//
// class RecitationCategorySection extends StatefulWidget {
//   const RecitationCategorySection({Key? key}) : super(key: key);
//
//   @override
//   State<RecitationCategorySection> createState() =>
//       _RecitationCategorySectionState();
// }
//
// class _RecitationCategorySectionState extends State<RecitationCategorySection> {
//   final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         HomeRowWidget(
//           text: localeText(context, 'Recitation_Category'),
//           buttonText: localeText(context, "view_all"),
//           onTap: () {
//             Navigator.of(context).pushNamed(RouteHelper.recitationPageList);
//             analytics.logEvent(
//               name: 'recitation_all_button',
//             );
//           },
//         ),
//         Consumer<LocalizationProvider>(
//           builder: (context, language, child) {
//             return SizedBox(
//               height: 150.h,
//               child: Consumer<RecitationCategoryProvider>(
//                 builder: (context, recitationProvider, child) {
//                   return ListView.builder(
//                     itemCount: recitationProvider.recitationCategory.length,
//                     padding:
//                         EdgeInsets.only(left: 20.w, right: 20.w, bottom: 14.h),
//                     scrollDirection: Axis.horizontal,
//                     itemBuilder: (context, index) {
//                       try {
//                         RecitationCategoryModel model = recitationProvider.recitationCategory[index];
//                         return InkWell(
//                           onTap: () {
//                             /// pause reciter recitation player
//                             Future.delayed(Duration.zero, () => context.read<RecitationPlayerProvider>().pause(context),);
//                             recitationProvider.getSelectedRecitationAll(model.playlistId as int);
//                             recitationProvider.setSelectedRecitationCategory(model);
//                             analytics.logEvent(
//                               name: 'recitation_section',
//                               parameters: {
//                                 'title': model.playlistName.toString()
//                               },
//                             );
//                             Navigator.of(context).pushNamed(
//                               RouteHelper.recitationallcategory,
//                               arguments: [
//                                 localeText(context, model.playlistName!),
//                                 model.imageURl!,
//                                 LocalizationProvider().checkIsArOrUr()
//                                 /// "{model.numberOfPrayers!} is change to numbers of surah as there is no column with number of prayer name
//                                     ?  "${model.numberOfSurahs!}${localeText(context, 'duas')} ${localeText(context, 'collection_of')} "
//                                     : "${localeText(context, 'playlist_of')} ${model.numberOfSurahs!} ${localeText(context, 'duas')}",
//                                 model.playlistId!,
//                               ],
//                             );
//                             // tappedRecitationNames.add(model.categoryName!);
//                             // context.read<recentProviderRecitation>().addTappedReciterName(model.categoryName!);
//                           },
//                           child: Container(
//                             width: 209.w,
//                             margin: EdgeInsets.only(right: 10.w),
//                             decoration: BoxDecoration(
//                               color: Colors.amberAccent,
//                               borderRadius: BorderRadius.circular(8.r),
//                               image: DecorationImage(
//                                 image:
//                                     CachedNetworkImageProvider(model.imageURl!),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(8.r),
//                                 gradient: const LinearGradient(
//                                   colors: [
//                                     Color.fromRGBO(0, 0, 0, 0),
//                                     Color.fromRGBO(0, 0, 0, 1),
//                                   ],
//                                   begin: Alignment.center,
//                                   end: Alignment.bottomCenter,
//                                 ),
//                               ),
//                               child: Container(
//                                 margin: EdgeInsets.only(
//                                     left: 6.w, bottom: 8.h, right: 6.w),
//                                 alignment: language.checkIsArOrUr()
//                                     ? Alignment.bottomRight
//                                     : Alignment.bottomLeft,
//                                 child: Text(
//                                   localeText(context, model.playlistName!),
//                                   textAlign: TextAlign.left,
//                                   style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 17.sp,
//                                       fontFamily: "satoshi",
//                                       fontWeight: FontWeight.w900),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         );
//                       } catch (error) {
//                         print("Error: $error");
//                         return Container(); // Placeholder for error handling
//                       }
//                     },
//                   );
//                 },
//               ),
//             );
//           },
//         )
//       ],
//     );
//   }
// }

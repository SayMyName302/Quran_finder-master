// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:nour_al_quran/shared/widgets/title_row.dart';
// import 'package:nour_al_quran/pages/quran%20stories/chapters/chapters.dart';
// import 'package:nour_al_quran/pages/quran%20stories/quran_stories_provider.dart';
// import 'package:nour_al_quran/shared/utills/app_colors.dart';
// import 'package:provider/provider.dart';
//
// class ChaptersPage extends StatelessWidget {
//   const ChaptersPage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     var storiesProvider = context.watch<QuranStoriesProvider>();
//     return Scaffold(
//       appBar: buildAppBar(context: context,title: storiesProvider.title!),
//       body: ListView.builder(
//           itemCount: storiesProvider.chapters.length,
//           itemBuilder: (context, index) {
//             Chapters chapters = storiesProvider.chapters[index];
//             return InkWell(
//               onTap: (){
//                 storiesProvider.goToChapterDetailsPage(index, context);
//               },
//               child: Container(
//                 margin: EdgeInsets.only(bottom: 10.h,left: 20.w,right: 20.w),
//                 padding: EdgeInsets.only(top: 10.h,left: 10.w,right: 10.w,bottom: 12.h),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(6.r),
//                   border: Border.all(color: AppColors.grey5),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('chapter ${chapters.chapterId}',style: TextStyle(fontFamily: 'satoshi',fontWeight: FontWeight.w500,fontSize: 10.sp),),
//                     Text(chapters.chaptersName!,
//                         style: TextStyle(fontFamily: 'satoshi',fontWeight: FontWeight.w700,fontSize: 12.sp))
//                   ],
//                 ),
//               ),
//             );
//           },),
//     );
//   }
// }

export './screens/page1.dart';
export './screens/page2.dart';
export './screens/page3.dart';
export './screens/page4.dart';
export './screens/page5.dart';
export './screens/page6.dart';
export './screens/page7.dart';
export './screens/page8.dart';
export './screens/page9.dart';
export './screens/page10.dart';
export './screens/page11.dart';
export './screens/page12.dart';
export './screens/page13.dart';
export './screens/page14.dart';
export './screens/page15.dart';
export './screens/page16.dart';
export './screens/page17.dart';
export './screens/page18.dart';
export './screens/page19.dart';

// class QaidaPage extends StatelessWidget {
//   const QaidaPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//               margin: EdgeInsets.only(left: 20.w, top: 60.h,bottom: 12.h,right: 20.w),
//               child: const TitleText(title: "Qaida",)),
//           Expanded(
//             child: MediaQuery.removePadding(
//               context: context,
//               removeTop: true,
//               child: ListView.builder(
//                 itemCount: 5,
//                   itemBuilder: (context, index) {
//                     return Container(
//                       // height: 54.h,
//                       margin: EdgeInsets.only(left: 20.w,right: 20.w,bottom: 10.h),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(6.r),
//                         border: Border.all(color: AppColors.grey4),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Container(
//                             margin: EdgeInsets.only(left: 10.w,top: 19.h,bottom: 19.h,right: 10.w),
//                             child: Text("Lesson 01",style: TextStyle(
//                               fontWeight: FontWeight.w700,
//                               fontSize: 12.sp,
//                               fontFamily: "satoshi",
//                               // color: AppColors.grey2
//                             ),),
//                           ),
//                           Consumer<AppColorsProvider>(
//                             builder: (context, colors, child) {
//                               return Container(
//                               height: 27.h,
//                               width: 27.w,
//                               margin: EdgeInsets.only(right: 10.w, top: 17.h, bottom: 16.h,left: 10.w),
//                               child: CircleAvatar(
//                                 backgroundColor: colors.mainBrandingColor,
//                                 child: Icon(
//                                   Icons.arrow_forward_ios,
//                                   color: Colors.white,
//                                   size: 9.h,
//                                 ),
//                               ),
//                             );
//                               },)
//                         ],
//                       ),
//                     );
//                   },),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

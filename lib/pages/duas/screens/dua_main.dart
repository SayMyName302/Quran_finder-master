import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nour_al_quran/pages/duas/provider/dua_provider.dart';
import 'package:provider/provider.dart';
import '../../../../../shared/localization/localization_constants.dart';
import '../../../shared/utills/app_colors.dart';
import '../../../shared/widgets/title_text.dart';
import '../../quran/pages/ruqyah/provider/ruqyah_provider.dart';
import '../../settings/pages/app_colors/app_colors_provider.dart';


class DuaCategoriesMain extends StatefulWidget with RouteAware {
  const DuaCategoriesMain({Key? key}) : super(key: key);

  @override
  State<DuaCategoriesMain> createState() => _DuaCategoriesMainState();
}

class _DuaCategoriesMainState extends State<DuaCategoriesMain> {
  @override
  void initState() {
    super.initState();
    context.read<DuaProvider>().getDuaCategories();
    context.read<RuqyahProvider>().getRDuaCategories();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<DuaProvider>().setCurrentPage(0);
        return true;
      },
      child: Scaffold(
        body: Consumer2<DuaProvider, AppColorsProvider>(
          builder: (context, duaProvider, appColors, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(
                      left: 20.w, top: 60.h, bottom: 12.h, right: 20.w),
                  child: TitleText(
                    title: localeText(context, "duas"),
                    style: TextStyle(
                      fontFamily: 'satoshi',
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  height: 23.h,
                  margin: EdgeInsets.only(bottom: 15.h),
                  child: ListView.builder(
                    padding: EdgeInsets.only(left: 20.w, right: 20.w),
                    itemCount: duaProvider.pageNames.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () async {
                          duaProvider.setCurrentPage(index);
                        },
                        child: Container(
                          height: 23.h,
                          padding: EdgeInsets.only(left: 9.w, right: 9.w),
                          margin: EdgeInsets.only(right: 7.w),
                          decoration: BoxDecoration(
                            color: index == duaProvider.currentPage
                                ? appColors.mainBrandingColor
                                : AppColors.grey6,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Center(
                            child: Text(
                              localeText(context, duaProvider.pageNames[index]),
                              style: TextStyle(
                                color: index == duaProvider.currentPage
                                    ? Colors.white
                                    : AppColors.grey3,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'satoshi',
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Expanded(child: duaProvider.pages[duaProvider.currentPage]),
              ],
            );
          },
        ),
      ),
    );
  }
}

// @override
// Widget build(BuildContext context) {
//   var appColors = context.read<AppColorsProvider>().mainBrandingColor;
//   return Scaffold(
//     appBar: buildAppBar(context: context, title: localeText(context, "dua")),
//     body: DefaultTabController(
//       length: 2,
//       child: Column(
//         children: [
//           TabBar(
//             indicatorColor: appColors,
//             tabs: const [
//               Tab(text: 'Dua'),
//               Tab(text: 'Al-Ruqyah'),
//             ],
//           ),
//           Expanded(
//               child: TabBarView(
//             children: [
//               Column(
//                 children: const [
//                   Expanded(
//                     child: DuaCategoriesPage(),
//                   ),
//                 ],
//               ),
//               Column(
//                 children: const [
//                   Expanded(
//                     child: RuqyahCategoriesPage(),
//                   ),
//                 ],
//               ),
//             ],
//           )),
//         ],
//       ),
//     ),
//   );
// }
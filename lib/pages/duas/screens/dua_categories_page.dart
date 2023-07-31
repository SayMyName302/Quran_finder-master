import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nour_al_quran/pages/quran/pages/recitation/reciter/player/player_provider.dart';
import 'package:nour_al_quran/pages/settings/pages/app_colors/app_colors_provider.dart';
import 'package:nour_al_quran/shared/localization/localization_constants.dart';
import 'package:nour_al_quran/shared/routes/routes_helper.dart';
import 'package:provider/provider.dart';

import '../provider/dua_provider.dart';
import '../models/dua_category.dart';

class DuaCategoriesPage extends StatelessWidget {
  const DuaCategoriesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appColors = context.read<AppColorsProvider>().mainBrandingColor;
    return Consumer<DuaProvider>(
      builder: (context, duaProvider, child) {
        return duaProvider.duaCategoryList.isNotEmpty
            ? GridView.builder(
                padding: EdgeInsets.only(left: 10.w, right: 0.w),
                itemCount: duaProvider.duaCategoryList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemBuilder: (context, index) {
                  DuaCategory duaCategory = duaProvider.duaCategoryList[index];
                  return InkWell(
                    onTap: () async {
                      /// pause recitation player
                      Future.delayed(Duration.zero, () => context.read<RecitationPlayerProvider>().pause(context),);
                      duaProvider.getDuaBasedOnCategoryId(duaCategory.categoryId!);
                      duaProvider.setSelectedCategory(index);
                      Navigator.of(context).pushNamed(
                        RouteHelper.dua,
                      );
                    },
                    child: Container(
                      height: 149.h,
                      margin: EdgeInsets.only(right: 9.w, bottom: 9.h),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(8.r),
                        image: DecorationImage(
                          image: AssetImage(duaCategory.imageUrl!),
                          fit: BoxFit.cover,
                        ),
                      ),
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
                            left: 6.w,
                            bottom: 8.h,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                localeText(context, duaCategory.categoryName!),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                  fontFamily: "satoshi",
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
            : Center(
                child: CircularProgressIndicator(
                  color: appColors,
                ),
              );
      },
    );
  }
}


// arguments: [
//   localeText(context, duaCategory.categoryName!),
//   duaCategory.imageUrl,
//   LocalizationProvider().checkIsArOrUr()
//       ? "${duaCategory.noOfDua!} ${localeText(context, 'duas')} ${localeText(context, 'collection_of')} "
//       : "${localeText(context, 'playlist_of')} ${duaCategory.noOfDua!} ${localeText(context, 'duas')}",
//   duaCategory.categoryId,
// ],

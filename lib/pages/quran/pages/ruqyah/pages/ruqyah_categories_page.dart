import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nour_al_quran/pages/quran/pages/recitation/reciter/player/player_provider.dart';
import 'package:nour_al_quran/pages/settings/pages/app_colors/app_colors_provider.dart';
import 'package:nour_al_quran/shared/localization/localization_constants.dart';
import 'package:nour_al_quran/shared/routes/routes_helper.dart';
import 'package:provider/provider.dart';
import '../../../../../shared/localization/languages.dart';
import '../models/ruqyah_category.dart';
import '../provider/ruqyah_provider.dart';

class RuqyahCategoriesPage extends StatelessWidget {
  const RuqyahCategoriesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appColors = context.read<AppColorsProvider>().mainBrandingColor;
    return Consumer<RuqyahProvider>(
      builder: (context, duaValue, child) {
        return duaValue.duaCategoryList.isNotEmpty
            ? GridView.builder(
                padding: EdgeInsets.only(
                  left: 10.w,
                  right: 0.w,
                ),
                itemCount: duaValue.duaCategoryList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemBuilder: (context, index) {
                  RuqyahCategory duaCategory = duaValue.duaCategoryList[index];

                  //This code is to give margin to Text inside Container if lang == ar or ur
                  String? languageCode;
                  String currentLanguage =
                      Localizations.localeOf(context).languageCode;
                  languageCode = Languages.languages
                      .firstWhere(
                        (language) =>
                            language.languageCode.toLowerCase() ==
                            currentLanguage.toLowerCase(),
                      )
                      .languageCode;
                  //Till here

                  return InkWell(
                    onTap: () async {
                      /// if recitation player is on So this line is used to pause the player
                      Future.delayed(
                        Duration.zero,
                        () => context
                            .read<RecitationPlayerProvider>()
                            .pause(context),
                      );
                      duaValue.setSelectedCategory(index);
                      duaValue
                          .getRDuaBasedOnCategoryId(duaCategory.categoryId!);
                      Navigator.of(context).pushNamed(
                        RouteHelper.ruqyah,
                      );
                    },
                    child: Container(
                      height: 149.h,
                      margin: EdgeInsets.only(right: 9.w, bottom: 9.h),
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(8.r),
                          image: DecorationImage(
                              image: NetworkImage(duaCategory.imageUrl!),
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
                          width: double.maxFinite,
                          margin: EdgeInsets.only(
                            left: 6.w,
                            bottom: 8.h,
                            right:
                                (languageCode == 'ur' || languageCode == 'ar')
                                    ? 6.w
                                    : 0,
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
                                    fontWeight: FontWeight.w700),
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

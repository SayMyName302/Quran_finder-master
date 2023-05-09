import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dua_provider.dart';
import 'models/dua_category.dart';
import '../../widgets/subtitle_text.dart';
import '../../../settings/pages/app_colors/app_colors_provider.dart';
import '../../../../shared/localization/localization_constants.dart';
import '../../../../shared/routes/routes_helper.dart';
import 'package:provider/provider.dart';

class DuaCategoriesPage extends StatelessWidget {
  const DuaCategoriesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appColors = context.read<AppColorsProvider>().mainBrandingColor;
    context.read<DuaProvider>().getDuaCategories();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SubTitleText(title: localeText(context, "dua_categories")),
        Consumer<DuaProvider>(
          builder: (context, duaValue, child) {
            return duaValue.duaCategoryList.isNotEmpty
                ? Expanded(
                    child: GridView.builder(
                      padding: EdgeInsets.only(
                          top: 10.h, left: 20.w, right: 20.w, bottom: 10.h),
                      itemCount: duaValue.duaCategoryList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 9.w,
                          mainAxisSpacing: 10.h),
                      itemBuilder: (context, index) {
                        DuaCategory duaCategory =
                            duaValue.duaCategoryList[index];
                        return InkWell(
                          onTap: () async {
                            duaValue.getDua(duaCategory.categoryId!);
                            // context.read<QuranDbProvider>().setDuaList(await QuranDatabase().getDua(duaCategory.categoryId!));
                            Navigator.of(context).pushNamed(RouteHelper.dua,
                                arguments: [
                                  duaCategory.categoryName,
                                  duaCategory.noOfDua
                                ]);
                          },
                          child: Container(
                            height: 175.h,
                            decoration: BoxDecoration(
                                color: Colors.amberAccent,
                                borderRadius: BorderRadius.circular(8.r),
                                image: DecorationImage(
                                    image: AssetImage(duaCategory.imageUrl!),
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      duaCategory.categoryName!,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14.sp,
                                          fontFamily: "satoshi",
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(duaCategory.noOfDua!,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10.sp,
                                            fontFamily: "satoshi",
                                            fontWeight: FontWeight.w500))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : Expanded(
                    child: Center(
                    child: CircularProgressIndicator(
                      color: appColors,
                    ),
                  ));
          },
        )
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:nour_al_quran/pages/tranquil_tales/models/TranquilCategory.dart';
import 'package:nour_al_quran/pages/tranquil_tales/provider/tranquil_tales_provider.dart';
import 'package:provider/provider.dart';

import '../../../shared/localization/localization_constants.dart';
import '../../../shared/localization/localization_provider.dart';
import '../../../shared/routes/routes_helper.dart';

class TranquilPageList extends StatelessWidget {
  const TranquilPageList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Consumer<TranquilCategoryProvider>(
        builder: (context, tranquilProvider, child) {
          return tranquilProvider.recitationCategory.isNotEmpty
              ? GridView.builder(
                  padding: EdgeInsets.only(left: 10.w, right: 0.w),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: tranquilProvider.recitationCategory.length,
                  itemBuilder: (context, index) {
                    TranquilTalesCategoryModel model = tranquilProvider.recitationCategory[index];
                    return InkWell(
                      onTap: () {
                        tranquilProvider.getSelectedRecitationAll(model.categoryId!);
                        Navigator.of(context).pushNamed(
                          RouteHelper.tranquil_tales,
                          arguments: [
                            localeText(context, model.categoryName!),
                            model.imageURl!,
                            LocalizationProvider().checkIsArOrUr()
                                ? "${model.numberOfPrayers!} ${localeText(context, 'duas')} ${localeText(context, 'collection_of')} "
                                : "${localeText(context, 'playlist_of')} ${model.numberOfPrayers!} ${localeText(context, 'duas')}",
                            model.categoryId!,
                          ],
                        );
                      },
                      child: Container(
                        height: 149.h,
                        margin: EdgeInsets.only(right: 9.w, bottom: 9.h),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            image: DecorationImage(
                                image: NetworkImage(model.imageURl!),
                                fit: BoxFit.cover)),
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
                                left: 6.w, bottom: 8.h, right: 9.w),
                            alignment: Alignment.bottomLeft,
                            child: Text(localeText(context, model.categoryName!.toLowerCase()),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.sp,
                                  fontFamily: "satoshi",
                                  fontWeight: FontWeight.w900),
                            ),
                          ),
                        ),
                      ),
                    );
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

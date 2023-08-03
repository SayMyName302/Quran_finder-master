import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nour_al_quran/pages/recitation_category/models/RecitationCategory.dart';
import 'package:nour_al_quran/pages/recitation_category/provider/recitation_category_provider.dart';
import 'package:provider/provider.dart';

import '../../../shared/localization/localization_constants.dart';
import '../../../shared/localization/localization_provider.dart';
import '../../../shared/routes/routes_helper.dart';

class RecitationCategoryPageList extends StatelessWidget {
  const RecitationCategoryPageList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// Test By Farhan
    return Expanded(
      child: Consumer<RecitationCategoryProvider>(
        builder: (context, recitationProvider, child) {
          return recitationProvider.recitationCategory.isNotEmpty
              ? GridView.builder(
                  padding: EdgeInsets.only(left: 10.w, right: 0.w),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: recitationProvider.recitationCategory.length,
                  itemBuilder: (context, index) {
                    RecitationCategoryModel model =
                        recitationProvider.recitationCategory[index];
                    return InkWell(
                      onTap: () {
                        recitationProvider
                            .getSelectedRecitationAll(model.playlistId!);
                        Navigator.of(context).pushNamed(
                          RouteHelper.recitationallcategory,
                          arguments: [
                            localeText(context, model.playlistName!),
                            model.imageURl!,
                            LocalizationProvider().checkIsArOrUr()
                                ? "${model.numberOfSruahs!} ${localeText(context, 'duas')} ${localeText(context, 'collection_of')} "
                                : "${localeText(context, 'playlist_of')} ${model.numberOfSruahs!} ${localeText(context, 'duas')}",
                            model.playlistId!,
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
                            child: Text(
                              localeText(
                                  context, model.playlistName!.toLowerCase()),
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

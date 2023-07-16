import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nour_al_quran/pages/recitation_category/models/RecitationCategory.dart';

import 'package:nour_al_quran/shared/localization/localization_provider.dart';
import 'package:nour_al_quran/shared/routes/routes_helper.dart';
import 'package:provider/provider.dart';

import '../../../shared/localization/localization_constants.dart';

import '../../home/widgets/home_row_widget.dart';
import '../provider/recitation_category_provider.dart';

class RecitationCategorySection extends StatelessWidget {
  const RecitationCategorySection({Key? key}) : super(key: key);

  @override
  @override
  Widget build(BuildContext context) {
    // int network = Provider.of<int>(context);
    // final recition = Provider.of<RecitationCategoryProvider>(context);
    return Column(
      children: [
        HomeRowWidget(
          text: localeText(context, 'Recitation_Category'),
          buttonText: localeText(context, "view_all"),
          onTap: () {
            Navigator.of(context).pushNamed(RouteHelper.recitationPageList);
          },
        ),
        Consumer<LocalizationProvider>(
          builder: (context, language, child) {
            return SizedBox(
              height: 150.h,
              child: Consumer<RecitationCategoryProvider>(
                builder: (context, recitationProvider, child) {
                  return ListView.builder(
                    itemCount: recitationProvider.recitationCategory.length,
                    padding:
                        EdgeInsets.only(left: 20.w, right: 20.w, bottom: 14.h),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      try {
                        RecitationCategoryModel model =
                            recitationProvider.recitationCategory[index];
                        print(model.categoryName);
                        print(model.imageURl);
                        return InkWell(
                          onTap: () {
                            recitationProvider.getSelectedRecitationAll(
                                model.categoryId as int);
                            Navigator.of(context).pushNamed(
                              RouteHelper.recitationallcategory,
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
                            width: 209.w,
                            margin: EdgeInsets.only(right: 10.w),
                            decoration: BoxDecoration(
                              color: Colors.amberAccent,
                              borderRadius: BorderRadius.circular(8.r),
                              image: DecorationImage(
                                image: NetworkImage(model.imageURl!
                                    // Replace "https://example.com/path/to/image.jpg" with your actual image URL
                                    ),
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
                                    language.locale.languageCode == "ur" ||
                                            language.locale.languageCode == "ar"
                                        ? Alignment.bottomRight
                                        : Alignment.bottomLeft,
                                child: Text(
                                  localeText(context, model.categoryName!),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17.sp,
                                      fontFamily: "satoshi",
                                      fontWeight: FontWeight.w900),
                                ),
                              ),
                            ),
                          ),
                        );
                      } catch (error) {
                        print("Error: $error");

                        return Container(); // Placeholder for error handling
                      }
                    },
                  );
                },
              ),
            );
          },
        )
      ],
    );
  }
}

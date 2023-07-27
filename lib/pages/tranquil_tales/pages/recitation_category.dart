import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:nour_al_quran/shared/localization/localization_constants.dart';
import 'package:nour_al_quran/shared/widgets/title_text.dart';

import 'recitation_category_page_list.dart';

class TranquilStoriesViewAll extends StatelessWidget {
  const TranquilStoriesViewAll({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              margin: EdgeInsets.only(
                  left: 20.w, top: 60.h, bottom: 12.h, right: 20.w),
              child: TitleText(
                  title: localeText(context, "tranquil_tales"),
                  style: TextStyle(
                      fontFamily: 'satoshi',
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold))),
          const TranquilPageList()
        ],
      ),
    );
  }
}

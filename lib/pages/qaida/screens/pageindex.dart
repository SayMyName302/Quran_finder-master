import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../shared/localization/localization_constants.dart';
import '../../../shared/utills/app_colors.dart';
import '../../../shared/widgets/app_bar.dart';
import '../../settings/pages/app_colors/app_colors_provider.dart';
import '../../settings/pages/app_them/them_provider.dart';

class QaidaPageIndex extends StatelessWidget {
  final int selectedIndex;

  final List<String> listData = [
    'alphabet_recognition',
    'pronunciation_and_joining_of_letter_1',
    'pronunciation_and_joining_of_letter_2',
    'pronunciation_and_joining_of_letter_3',
    'pronunciation_and_joining_of_letter_4',
    'pronunciation_and_joining_of_letter_5',
    'pronunciation_and_joining_of_letter_6',
    'compound_letters_(murakkabat)',
    'concept_of_harakat',
    'tanween-fathatayn_&_kasratayn',
    'tanween-dhammatayn',
    'tashdeed_and_haroof_leen',
    'tashdeed_in_words',
    'tajweed_fundamentals_(ikhfa_and_izhaar)',
    'tajweed_fundamentals_(iqlab)',
    'tajweed_fundamentals_(idgham_and_maddat)',
    'long_vowels_(madd)',
    "muqatta'at_letters",
    'bayan_al-alaam',
  ];

  QaidaPageIndex({super.key, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    var appColors = context.read<AppColorsProvider>();
    var isDark = context.read<ThemProvider>().isDark;
    Color appColor = context.read<AppColorsProvider>().mainBrandingColor;
    final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

    return Scaffold(
      appBar: buildAppBar(
        context: context,
        title: localeText(context, "qaida_index"),
      ),
      body: ListView.builder(
        itemCount: listData.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              Navigator.pop(context, index);
              analytics.logEvent(
                name: 'qaida_index_page',
                parameters: {
                  'Name': listData[index].toString(),
                  'index': index,
                },
              );
            },
            child: Container(
              margin: EdgeInsets.only(
                left: 20.w,
                right: 20.w,
                bottom: 8.h,
              ),
              decoration: BoxDecoration(
                color: selectedIndex == index
                    ? isDark
                        ? appColor.withOpacity(0.3)
                        : appColor.withOpacity(0.3)
                    : Colors.transparent,
                border: Border.all(
                  color: selectedIndex == index
                      ? appColors.mainBrandingColor
                      : isDark
                          ? AppColors.grey3
                          : AppColors.grey5,
                ),
                borderRadius: BorderRadius.circular(6.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  localeText(context, listData[index]),
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontFamily: "satoshi",
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

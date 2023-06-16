import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nour_al_quran/pages/qaida/screens/swipe.dart';

import '../../../shared/localization/localization_constants.dart';
import '../../../shared/utills/app_colors.dart';
import '../../../shared/widgets/app_bar.dart';

class QaidaPageIndex extends StatelessWidget {
  final List<String> listData = [
    'Page 1',
    'Page 2',
    'Page 3',
    'Page 4',
    'Page 5',
    'Page 6',
    'Page 7',
    'Page 8',
    'Page 9',
    'Page 10',
    'Page 11',
    'Page 12',
    'Page 13',
    'Page 14',
    'Page 15',
    'Page 16',
    'Page 17',
    'Page 18',
    'Page 19',
  ];

  QaidaPageIndex({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
          context: context, title: localeText(context, "qaida_index")),
      body: ListView.builder(
        itemCount: listData.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: EdgeInsets.only(
              left: 20.w,
              right: 20.w,
              bottom: 8.h,
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.r),
                border: Border.all(
                  color: AppColors.grey5,
                )),
            child: ListTile(
              title: Text(listData[index]),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SwipePages(initialPage: index),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

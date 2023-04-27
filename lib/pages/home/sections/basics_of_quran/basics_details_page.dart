import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:nour_al_quran/shared/localization/localization_constants.dart';
import 'package:nour_al_quran/shared/widgets/title_row.dart';
import 'package:provider/provider.dart';

import 'islam_basics_provider.dart';

class IslamBasicDetailsPage extends StatelessWidget {
  const IslamBasicDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var islamicBasic = context.read<IslamBasicsProvider>().selectedIslamBasics;
    return Scaffold(
      appBar: buildAppBar(context: context,title: localeText(context, islamicBasic!.title!)),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(left: 20.w,right: 20.w,top: 16.h,bottom: 16.h),
            child: HtmlWidget(
                islamicBasic.text!
            ),
          ),
        ),
      ),
    );
  }
}

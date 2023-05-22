import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:nour_al_quran/shared/localization/localization_constants.dart';
import 'package:provider/provider.dart';
import '../../../shared/widgets/app_bar.dart';
import '../provider/islam_basics_provider.dart';

class IslamBasicDetailsPage extends StatelessWidget {
  const IslamBasicDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var islamicBasic = Provider.of<IslamBasicsProvider>(context,listen: false).selectedIslamBasics;
    return Scaffold(
      appBar: buildAppBar(context: context,title: localeText(context, islamicBasic!.title!.toLowerCase())),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 20.w,right: 20.w,top: 16.h,bottom: 16.h),
          /// html widget will load html content from home.db
          child: HtmlWidget(
              islamicBasic.text!
          ),
        ),
      ),
    );
  }
}

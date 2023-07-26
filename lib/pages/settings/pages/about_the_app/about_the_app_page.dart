import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:nour_al_quran/pages/settings/pages/about_the_app/provider/about_provider.dart';
import 'package:nour_al_quran/shared/localization/localization_constants.dart';
import 'package:provider/provider.dart';

import '../../../../shared/widgets/app_bar.dart';

class AboutTheAppPage extends StatelessWidget {
  const AboutTheAppPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
          context: context, title: localeText(context, "about_the_app")),
      body: Container(
        margin: EdgeInsets.only(left: 20.w, right: 20.w),
        child: Column(
          children: [
            Container(
              height: 116.h,
              width: 116.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14.r),
                  image: DecorationImage(
                      image:
                          Image.asset('assets/images/splash/icon.png').image)),
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: Consumer<AboutProvider>(
                builder: (context, about, child) {
                  final appInfo = about.appInfo;
                  final aboutText =
                      appInfo.isNotEmpty ? appInfo[0].aboutText : null;
                  return aboutText != null
                      ? SingleChildScrollView(
                          child: HtmlWidget(aboutText),
                        )
                      : const Text('No information available');
                },
              ),
            ),
            SizedBox(height: 20.h),
            Container(
              margin: EdgeInsets.only(bottom: 8.h),
              alignment: Alignment.centerLeft,
              child: Text(
                'Developers',
                style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: 'satoshi',
                    fontWeight: FontWeight.w500),
              ),
            ),
            Container(
                alignment: Alignment.centerLeft,
                child: Text("CANZ Studios",
                    style: TextStyle(
                        fontSize: 14.sp,
                        fontFamily: 'satoshi',
                        fontWeight: FontWeight.w700))),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}

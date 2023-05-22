import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';

import '../provider/miracles_of_quran_provider.dart';
import '../models/miracles.dart';

class MiraclesContentText extends StatelessWidget {
  const MiraclesContentText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Miracles miracles = context.read<MiraclesOfQuranProvider>().selectedMiracle!;
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 20.w,right: 20.w,top: 16.h,bottom: 16.h),
          alignment: Alignment.center,
          child: HtmlWidget(
            miracles.text!,
            textStyle: TextStyle(
              fontFamily: 'satoshi',
              fontSize: 14.sp,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nour_al_quran/shared/widgets/title_text.dart';

import '../../pages/more/pages/salah_timer/salah_timer_settings.dart';

AppBar buildAppBar({String? title,required BuildContext context,double? font,String? icon}){
  return AppBar(
    centerTitle: true,
    elevation: 0.0,
    backgroundColor: Colors.transparent,
    title: TitleText(title: title!,fontSize: font ?? 22.sp,),
    actions: [
      icon != null ? IconButton(onPressed: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const SalahTimerSetting()));
      }, icon: ImageIcon(const AssetImage('assets/images/app_icons/settings.png'),size: 16.5.h,)) : const SizedBox.shrink(),
    ],
  );
}
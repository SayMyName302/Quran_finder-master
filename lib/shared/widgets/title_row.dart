import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nour_al_quran/pages/more/pages/salah_timer/salah_timer_settings.dart';
import 'package:nour_al_quran/shared/widgets/title_text.dart';

class TitleRow extends StatelessWidget {
  final String title;
  final double? fontSize;
  final double? height;
  const TitleRow({Key? key, required this.title,this.fontSize = 0,this.height = 0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(left: 20.w, top: 60.h,right: 20.w),
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const ImageIcon(AssetImage('assets/images/app_icons/back.png')),
            ),
          ),
          Container(
              margin: EdgeInsets.only(top: height == 0 ? 60.h : height!),
              alignment: Alignment.center,
              child: TitleText(title: title,fontSize: fontSize,)),
        ],
      ),
    );
  }
}

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

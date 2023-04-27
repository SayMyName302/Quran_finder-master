import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TitleText extends StatelessWidget {
  final String title;
  final double? fontSize;
  const TitleText({Key? key,required this.title,this.fontSize = 0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(title,style: TextStyle(fontSize: fontSize == 0 ? 22.sp : fontSize,fontFamily: "satoshi"),);
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:nour_al_quran/pages/more/pages/tasbeeh/tasbeeh_provider.dart';
import 'package:nour_al_quran/shared/widgets/title_row.dart';
import 'package:nour_al_quran/pages/settings/pages/app_colors/app_colors_provider.dart';
import 'package:nour_al_quran/shared/localization/localization_constants.dart';
import 'package:nour_al_quran/shared/localization/localization_provider.dart';
import 'package:nour_al_quran/pages/settings/pages/app_them/them_provider.dart';
import 'package:nour_al_quran/shared/utills/app_colors.dart';
import 'package:nour_al_quran/shared/widgets/brand_button.dart';
import 'package:provider/provider.dart';

class TasbeehPage extends StatelessWidget {
  const TasbeehPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer4<LocalizationProvider,TasbeehProvider,ThemProvider,AppColorsProvider>(
      builder: (context, language,tasbeehValue,them,appColors, child) {
        return Scaffold(
          appBar: buildAppBar(context: context,title: localeText(context, "tasbeeh")),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 35.h, left: 20.w, right: 20.w),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: List.generate(
                        tasbeehValue.tasbeehList.length, (index) => Expanded(
                      child: InkWell(
                        onTap: () {
                          tasbeehValue.setCurrentTabeeh(index);
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: language.locale.languageCode == "ur" || language.locale.languageCode == "ar" ? index == 0 ? 0:6.w : index == 2 ? 0 :6.w),
                          padding: EdgeInsets.only(top: 7.h, bottom: 10.h),
                          decoration: BoxDecoration(color: tasbeehValue.currentTabeeh == index ? appColors.mainBrandingColor : them.isDark ? AppColors.darkColor : Colors.white,
                              borderRadius: BorderRadius.circular(8.r),
                              boxShadow: const [
                                BoxShadow(
                                    offset: Offset(0, 4),
                                    blurRadius: 12,
                                    color: Color.fromRGBO(0, 0, 0, 0.08))
                              ]),
                          child: Column(
                            children: [
                              Text(
                                tasbeehValue.tasbeehList[index].arabicName,
                              // tasbeehValue.currentTabeeh == index ? Colors.white :
                              style: TextStyle(
                                    color: them.isDark ? Colors.white : tasbeehValue.currentTabeeh == index ? Colors.white : Colors.black,
                                    fontFamily: 'Al Majeed Quranic Font',
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(localeText(context, tasbeehValue.tasbeehList[index].englishName),
                                  style: TextStyle(
                                      color: tasbeehValue.currentTabeeh== index ? Colors.white : them.isDark ? Colors.white : Colors.black,
                                      fontFamily: 'satoshi',
                                      fontSize: 8.sp))
                            ],
                          ),
                        ),
                      ),
                    )),
                  ),
                ),
                InkWell(
                  onTap: () async{
                    tasbeehValue.setIsCustomTasbeeh();
                  },
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 8.h,bottom: 27.h,left: 20.w,right: 20.w),
                    padding: EdgeInsets.only(top: 12.h,bottom: 12.h),
                    decoration: BoxDecoration(
                        color: them.isDark ? tasbeehValue.isCustomTasbeeh ? appColors.mainBrandingColor : AppColors.darkColor : tasbeehValue.isCustomTasbeeh ? appColors.mainBrandingColor : Colors.white,
                        borderRadius: BorderRadius.circular(8.r),
                        boxShadow: const [
                          BoxShadow(
                              offset: Offset(0, 4),
                              blurRadius: 12,
                              color: Color.fromRGBO(0, 0, 0, 0.08))
                        ]),
                    child: Text(localeText(context, "other_tasbeeh_of_your_choice"),textAlign: TextAlign.center,style: TextStyle(color: tasbeehValue.isCustomTasbeeh ? Colors.white : them.isDark ? Colors.white : Colors.black),),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: language.locale.languageCode == "ur" || language.locale.languageCode =="ar" ? 5.w : 10.w ,right: language.locale.languageCode == "ur" || language.locale.languageCode =="ar" ? 20.w : 5.w),
                        padding: EdgeInsets.only(right: 5.w),
                        decoration: BoxDecoration(
                            color: them.isDark ? AppColors.darkColor : Colors.white,
                            borderRadius: BorderRadius.circular(21.5.r),
                            boxShadow: const [
                              BoxShadow(
                                  offset: Offset(0, 4),
                                  blurRadius: 12,
                                  color: Color.fromRGBO(0, 0, 0, 0.08))
                            ]
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                              tasbeehValue.counterList.length, (index) {
                            return InkWell(
                              onTap: (){
                                tasbeehValue.setSelectedCounter(index);
                              },
                              child: Container(
                                margin: EdgeInsets.only(top: 2.h,bottom: 2.h),
                                child: CircleAvatar(
                                  radius: 21.5.r,
                                  backgroundColor: tasbeehValue.selectedCounter == index ? appColors.mainBrandingColor : Colors.transparent,
                                  child: Text(tasbeehValue.counterList[index].toString(),style: TextStyle(fontWeight: FontWeight.w400,fontFamily: "satoshi",color: tasbeehValue.selectedCounter == index ? Colors.white : them.isDark ? Colors.white : Colors.black),),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                      InkWell(
                        onTap: ()async{
                          await showCounterDialog(context, tasbeehValue, appColors);
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: language.locale.languageCode == "ur" || language.locale.languageCode =="ar" ? 0: 20.w,left: language.locale.languageCode == "ur" || language.locale.languageCode =="ar" ? 20.w : 0),
                          padding: EdgeInsets.all(13.h),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: them.isDark ? AppColors.darkColor : Colors.white,
                              borderRadius: BorderRadius.circular(21.5.r),
                              boxShadow: const [
                                BoxShadow(
                                    offset: Offset(0, 4),
                                    blurRadius: 12,
                                    color: Color.fromRGBO(0, 0, 0, 0.08))
                              ]
                          ),
                          child: Text('|${localeText(context, "custom_count")}',style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontFamily: 'satoshi',
                            fontSize: 14.sp,
                          ),textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20.w,right: 20.w,top: 28.h),
                  decoration: BoxDecoration(
                      color: them.isDark ? AppColors.darkColor : Colors.white,
                      borderRadius: BorderRadius.circular(10.r),
                      boxShadow: const [BoxShadow(offset: Offset(0,5),blurRadius: 15,color: Color.fromRGBO(0, 0, 0, 0.08))]
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              margin: EdgeInsets.only(top: 10.h,left: 10.w,right: 10.w),
                              child: Image.asset(language.locale.languageCode == "ur" || language.locale.languageCode == "ar" ?
                              'assets/images/app_icons/frame_left_t.png' : 'assets/images/app_icons/frame_right_t.png',height: 43.h,width: 43.w,color: appColors.mainBrandingColor,)),
                          Container(
                              margin: EdgeInsets.only(top: 10.h,right: 10.w,left: 10.w),
                              child: Image.asset(language.locale.languageCode == "ur" || language.locale.languageCode == "ar" ? 'assets/images/app_icons/frame_right_t.png' : 'assets/images/app_icons/frame_left_t.png',height: 43.h,width: 43.w,color: appColors.mainBrandingColor,)),
                        ],
                      ),
                      Text('${tasbeehValue.counter}/${tasbeehValue.currentCounter}',
                          // '${tasbeehValue.customCounter == 0 ? tasbeehValue.currentTabeeh == 2 ? tasbeehValue.counterList[tasbeehValue.selectedCounter] +1 : tasbeehValue.counterList[tasbeehValue.selectedCounter] : tasbeehValue.customCounter}',
                        style: TextStyle(
                          color: appColors.mainBrandingColor,
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'satoshi'
                      ),),
                      InkWell(
                        onTap: (){
                          tasbeehValue.increaseCounter();
                        },
                        child: Container(
                            margin: EdgeInsets.only(top: 30.h,bottom: 30.h),
                            child: Image.asset('assets/images/app_icons/fingerprint.png',height: 138.h,width: 138.w,color: them.isDark ? Colors.white : AppColors.grey1,)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              margin: EdgeInsets.only(bottom: 10.h,left: 10.w,right: 10.w),
                              child: Image.asset(language.locale.languageCode == "ur" || language.locale.languageCode == "ar" ? 'assets/images/app_icons/frame_left_b.png' : 'assets/images/app_icons/frame_right_b.png',height: 43.h,width: 43.w,color: appColors.mainBrandingColor,)),
                          Container(
                              margin: EdgeInsets.only(bottom: 10.h,right: 10.w,left: 10.w),
                              child: Image.asset(language.locale.languageCode == "ur" || language.locale.languageCode == "ar" ? 'assets/images/app_icons/frame_right_b.png' : 'assets/images/app_icons/frame_left_b.png',height: 43.h,width: 43.w,color: appColors.mainBrandingColor,)),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20.h,bottom: 20.h),
                  width: 90.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(19.r),
                      color: appColors.mainBrandingColor,
                  ),
                  child: Container(
                    margin: EdgeInsets.only(top: 11.2.h,bottom: 11.2.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.volume_up,color: Colors.white,size: 16.h,),
                        SizedBox(width: 22.45.w,),
                        Icon(Icons.restore_rounded,color: Colors.white,size: 16.h,)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> showCounterDialog(BuildContext context, TasbeehProvider tasbeehValue, AppColorsProvider appColors) async {
    await showDialog(context: context, builder: (context) {
      var text = TextEditingController();
      return Consumer<TasbeehProvider>(
        builder: (context, value, child) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            title: Text(localeText(context, "enter_tasbeeh_count"),textAlign: TextAlign.center,style: TextStyle(
                fontFamily: 'satoshi',
                fontSize: 16.sp)),
            content: Container(
              margin:EdgeInsets.only(left: 20.w,right: 20.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 5.h,top: 25.h),
                    child: Text(localeText(context, "enter_the_count"),style: TextStyle(
                        fontSize: 10.sp
                    ),),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 46.h,
                        padding: EdgeInsets.only(left: 10.w),
                        margin:EdgeInsets.only(bottom: 5.h),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6.r),
                            border: Border.all(color: AppColors.grey5)
                        ),
                        child: TextField(
                          controller: text,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(right: 10.w,left: 10.w),
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none
                          ),
                        ),
                      ),
                      value.error ? Container(
                        margin: EdgeInsets.only(bottom: 10.w),
                        width: double.maxFinite,
                          child: Text("error",textAlign: TextAlign.left,style: TextStyle(
                            color: Colors.red,
                            fontSize: 10.sp,
                            fontFamily: "satoshi"
                          ),)) : Container(margin: EdgeInsets.only(bottom: 5.h),)
                    ],
                  ),
                  BrandButton(text: localeText(context, "confirm"), onTap: (){
                    if(text.text.contains(".") || text.text == "0" || text.text.isEmpty){
                      tasbeehValue.setError(true);
                    }else{
                      tasbeehValue.setCustomCounter(int.parse(text.text),context,appColors);
                      Navigator.of(context).pop();
                      tasbeehValue.setError(false);
                    }
                  }),
                  SizedBox(height: 20.h,),
                ],
              ),
            ),
          );
        },
      );
    },);
  }
}




import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nour_al_quran/pages/onboarding/on_boarding_provider.dart';
import 'package:nour_al_quran/pages/onboarding/widgets/on_boarding_text_widgets.dart';
import 'package:nour_al_quran/pages/onboarding/widgets/skip_button.dart';
import 'package:nour_al_quran/pages/settings/pages/app_colors/app_colors_provider.dart';
import 'package:nour_al_quran/shared/localization/localization_constants.dart';
import 'package:nour_al_quran/shared/routes/routes_helper.dart';
import 'package:nour_al_quran/shared/utills/app_colors.dart';
import 'package:nour_al_quran/shared/widgets/brand_button.dart';
import 'package:provider/provider.dart';

class QuranReminder extends StatefulWidget {
  const QuranReminder({Key? key}) : super(key: key);

  @override
  State<QuranReminder> createState() => _QuranReminderState();
}

class _QuranReminderState extends State<QuranReminder> {
  TimeOfDay _timeOfDay = TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);

  @override
  Widget build(BuildContext context) {
    var appColors = context.read<AppColorsProvider>().mainBrandingColor;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(left: 20.w,right: 20.w,),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OnBoardingTitleText(title: localeText(context, "set_up_a_daily_reminder_for_quran_recitation")),
                OnBoardingSubTitleText(title: localeText(context, "enabling_reminder_increases_the_likelihood_of_daily_quran_reading_by_3x._are_you_interested_in_establishing_a_successful_habit_of_reading_the_quran?")),
                InkWell(
                    onTap: () async{
                      TimeOfDay? selectedTime = await showTimePicker(
                          context: context,
                          initialEntryMode: TimePickerEntryMode.inputOnly,
                          initialTime: _timeOfDay,
                      );
                      if(selectedTime != null){
                        setState(() {
                          _timeOfDay = selectedTime;
                        });
                      }
                    },
                    child: Container(
                      width: double.maxFinite,
                       padding: const EdgeInsets.all(20),
                        margin: EdgeInsets.only(top: 10.h,bottom: 10.h),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6.r),
                          border: Border.all(color: AppColors.grey4)
                        ),
                        child: Text(
                            _timeOfDay.format(context),
                          style: TextStyle(fontWeight: FontWeight.w900,fontSize: 44.sp,fontFamily: 'satoshi',color: AppColors.mainBrandingColor),
                        )
                    )),
                // showPicker(
                //     isInlinePicker: true,
                //     width: double.maxFinite,
                //     elevation: 5,
                //     borderRadius: 8.r,
                //     isOnChangeValueMode: true,
                //     value: Time(hour: DateTime.now().hour, minute: DateTime.now().minute),
                //     dialogInsetPadding: EdgeInsets.only(bottom: 20.h),
                //     themeData: ThemeData(
                //         sliderTheme: SliderThemeData(
                //             thumbColor: Colors.amber,
                //             activeTrackColor: appColors,
                //             inactiveTrackColor: AppColors.darkBrandingColor
                //         )
                //     ),
                //     onChange: (Time) {
                //       print(Time);
                //     }
                // ),
                BrandButton(text: localeText(context, "set_reminder"), onTap: (){
                  DateTime currentTime = DateTime.now();
                  DateTime myDateTime = DateTime(currentTime.year, currentTime.month, currentTime.day, _timeOfDay.hour, _timeOfDay.minute);
                  context.read<OnBoardingProvider>().setRecitationReminderTime(myDateTime);
                  Navigator.of(context).pushNamed(RouteHelper.setDailyQuranReadingTime);
                }),
                SizedBox(height: 16.h,),
                SkipButton(onTap: (){
                  Navigator.of(context).pushNamed(RouteHelper.setDailyQuranReadingTime);
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}

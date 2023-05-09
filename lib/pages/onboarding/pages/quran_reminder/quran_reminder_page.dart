import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../on_boarding_provider.dart';
import '../../widgets/on_boarding_text_widgets.dart';
import '../../widgets/skip_button.dart';

import '../../../../shared/localization/localization_constants.dart';
import '../../../../shared/routes/routes_helper.dart';
import '../../../../shared/utills/app_colors.dart';
import '../../../../shared/widgets/brand_button.dart';
import 'package:provider/provider.dart';

class QuranReminder extends StatefulWidget {
  const QuranReminder({Key? key}) : super(key: key);

  @override
  State<QuranReminder> createState() => _QuranReminderState();
}

class _QuranReminderState extends State<QuranReminder> {
  late TimeOfDay _timeOfDay;
  // TimeOfDay _timeOfDay =
  //     TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final selectedTime2 = ModalRoute.of(context)!.settings.arguments as String;
    switch (selectedTime2) {
      case 'morning':
        _timeOfDay = const TimeOfDay(hour: 6, minute: 0); // set morning time
        break;
      case 'afternoon':
        _timeOfDay = const TimeOfDay(hour: 13, minute: 0); // set afternoon time
        break;
      case 'evening':
        _timeOfDay = const TimeOfDay(hour: 18, minute: 0); // set evening time
        break;
      case 'night':
        _timeOfDay = const TimeOfDay(hour: 21, minute: 0); // set night time
        break;
      default:
        _timeOfDay = TimeOfDay.now(); // set current time as default
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(
              left: 20.w,
              right: 20.w,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OnBoardingTitleText(
                    title: localeText(context,
                        "set_up_a_daily_reminder_for_quran_recitation")),
                OnBoardingSubTitleText(
                    title: localeText(context,
                        "enabling_reminder_increases_the_likelihood_of_daily_quran_reading_by_3x._are_you_interested_in_establishing_a_successful_habit_of_reading_the_quran?")),
                InkWell(
                    onTap: () async {
                      TimeOfDay? selectedTime = await showTimePicker(
                        context: context,
                        initialEntryMode: TimePickerEntryMode.inputOnly,
                        initialTime: _timeOfDay,
                      );
                      if (selectedTime != null) {
                        setState(() {
                          _timeOfDay = selectedTime;
                        });
                      }
                    },
                    child: Container(
                        width: double.maxFinite,
                        padding: const EdgeInsets.all(20),
                        margin: EdgeInsets.only(top: 10.h, bottom: 10.h),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6.r),
                            border: Border.all(color: AppColors.grey4)),
                        child: Text(
                          _timeOfDay.format(context),
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 44.sp,
                              fontFamily: 'satoshi',
                              color: AppColors.mainBrandingColor),
                        ))),
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

                BrandButton(
                    text: localeText(context, "set_reminder"),
                    onTap: () {
                      DateTime currentTime = DateTime.now();
                      DateTime myDateTime = DateTime(
                          currentTime.year,
                          currentTime.month,
                          currentTime.day,
                          _timeOfDay.hour,
                          _timeOfDay.minute);
                      context
                          .read<OnBoardingProvider>()
                          .setRecitationReminderTime(myDateTime);
                      Navigator.of(context)
                          .pushNamed(RouteHelper.setDailyQuranReadingTime);
                    }),
                SizedBox(
                  height: 16.h,
                ),
                SkipButton(onTap: () {
                  Navigator.of(context)
                      .pushNamed(RouteHelper.setDailyQuranReadingTime);
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}

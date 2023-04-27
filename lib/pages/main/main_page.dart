import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:nour_al_quran/pages/home/home_page.dart';
import 'package:nour_al_quran/pages/home/home_provider.dart';
import 'package:nour_al_quran/pages/main/main_page_provider.dart';
import 'package:nour_al_quran/pages/more/more_page.dart';
import 'package:nour_al_quran/pages/onboarding/on_boarding_provider.dart';
import 'package:nour_al_quran/pages/quran/pages/recitation/reciter/player/mini_player.dart';
import 'package:nour_al_quran/pages/quran/quran_page.dart';
import 'package:nour_al_quran/pages/settings/pages/app_colors/app_colors_provider.dart';
import 'package:nour_al_quran/pages/settings/pages/notifications/notification_services.dart';
import 'package:nour_al_quran/pages/sign_in/sign_in_provider.dart';
import 'package:nour_al_quran/shared/entities/quran_text.dart';
import 'package:nour_al_quran/shared/localization/localization_constants.dart';
import 'package:nour_al_quran/pages/settings/pages/app_them/them_provider.dart';
import 'package:nour_al_quran/shared/routes/routes_helper.dart';
import 'package:nour_al_quran/shared/utills/app_colors.dart';
import 'package:nour_al_quran/shared/utills/app_constants.dart';
import 'package:nour_al_quran/shared/widgets/circle_button.dart';
import 'package:provider/provider.dart';

import '../home/sections/quran stories/quran_stories_page.dart';


class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  @override
  void initState() {
    super.initState();
    context.read<HomeProvider>().getVerse(context);
    setUpNotifications();
  }


  @override
  Widget build(BuildContext context) {
    var page = [
      const HomePage(),
      const QuranPage(),
      // const QaidaPage(),
      const QuranStoriesPage(),
      const MorePage()
    ];
    return Scaffold(
      body: Consumer2<MainPageProvider,AppColorsProvider>(
        builder: (context, value,appColors, child) {
          initEasyLoading(appColors);
          return page[value.currentPage];
        },
      ),
      bottomNavigationBar: Consumer3<MainPageProvider,AppColorsProvider,ThemProvider>(
        builder: (context, viewProvider,appColors,them, child) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const MiniPlayer(),
              BottomNavigationBar(
                items: [
                  BottomNavigationBarItem(
                      label: localeText(context,'home'),
                      icon: Container(
                          margin: EdgeInsets.only(bottom: 5.h),
                          child: const ImageIcon(AssetImage('assets/images/app_icons/home.png',),))),
                  BottomNavigationBarItem(
                      label: localeText(context,'quran'),
                      icon: Container(
                          margin: EdgeInsets.only(bottom: 5.h),
                          child: const ImageIcon(AssetImage('assets/images/app_icons/quran_icon.png'),))),
                  // BottomNavigationBarItem(
                  //     label: "Qaida",
                  //     icon: Container(
                  //         margin: EdgeInsets.only(bottom: 5.h),
                  //         child: const ImageIcon(AssetImage('assets/images/app_icons/qaida_icon.png'),))),
                  BottomNavigationBarItem(
                      label: localeText(context,'quran_stories'),
                      icon: Container(
                          margin: EdgeInsets.only(bottom: 5.h),
                          child: const ImageIcon(AssetImage('assets/images/app_icons/quran_stories.png'),))),
                  BottomNavigationBarItem(
                      label: localeText(context,'more'),
                      icon: Container(
                          margin: EdgeInsets.only(bottom: 5.h),
                          child: const ImageIcon(AssetImage('assets/images/app_icons/more.png'),))),
                ],
                // backgroundColor: Colors.white,
                currentIndex: viewProvider.currentPage,
                iconSize: 16.h,
                type: BottomNavigationBarType.fixed,
                showUnselectedLabels: true,
                selectedIconTheme: IconThemeData(size: 18.h),
                selectedItemColor: appColors.mainBrandingColor,
                unselectedItemColor: AppColors.grey3,
                selectedLabelStyle: TextStyle(fontFamily: 'satoshi',fontSize: 10.sp),
                unselectedLabelStyle: TextStyle(fontFamily: 'satoshi',fontSize: 10.sp),
                onTap: (page) async{
                  viewProvider.setCurrentPage(page);
                },
              )
            ],
          );
        },
      ),
    );
  }

  void initEasyLoading(AppColorsProvider appColors) {
    // EasyLoading.instance
    //   ..displayDuration = const Duration(milliseconds: 2000)
    //   ..indicatorType = EasyLoadingIndicatorType.ring
    //   ..loadingStyle = EasyLoadingStyle.custom
    //   ..textColor = Colors.amber
    //   ..lineWidth = 1.0
    //   ..indicatorSize = 20
    //   ..backgroundColor = appColors.mainBrandingColor
    //   ..radius = 15.r
    //   ..fontSize = 5
    //   ..backgroundColor = appColors.mainBrandingColor
    //   ..indicatorColor = Colors.white
    //   ..contentPadding = const EdgeInsets.all(5)
    //   ..dismissOnTap = false;
  }

  void setUpNotifications(){
    DateTime reminderTime = Hive.box(appBoxKey).get(onBoardingInformationKey).recitationReminder;
    OnBoardingProvider onBoardingProvider = OnBoardingProvider();
    var notificationList = onBoardingProvider.notification;
    if(notificationList[0].isSelected!){
      // schedule notification for quran recitations
      NotificationServices().dailyNotifications(
          id: dailyQuranRecitationId,
          title: "Recitation Reminder",
          body: "It is time to reciter Holy Quran",
          payload: "recite", dailyNotifyTime: Time(reminderTime.hour,reminderTime.minute));
      // NotificationServices().dailyNotifications(
      //     id: dailyQuranRecitationId,
      //     title: "Recitation Reminder",
      //     body: "It is time to reciter Holy Quran", payload: "recite");
    }
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:nour_al_quran/pages/quran/providers/quran_provider.dart';
import 'package:nour_al_quran/pages/quran/widgets/quran_text_view.dart';
import 'package:nour_al_quran/pages/settings/pages/app_them/them_provider.dart';
import 'package:nour_al_quran/shared/entities/last_seen.dart';
import 'package:nour_al_quran/shared/routes/routes_helper.dart';
import 'package:nour_al_quran/shared/utills/app_colors.dart';
import 'package:provider/provider.dart';
import '../bottom_tabs/provider/bottom_tabs_page_provider.dart';
import '../settings/pages/notifications/notification_services.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _isListening = false;
  
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1),(){
      if(!_isListening){
        // Fluttertoast.showToast(msg: "goingToRoute");
        Navigator.of(RouteHelper.currentContext).pushNamedAndRemoveUntil(RouteHelper.achieveWithQuran, (route) => false);
      }
    });
    listenToNotification();
  }


  void gotoQuranTextView(){
    LastSeen? lastSeen = Hive.box('myBox').get("lastSeen");
    if(lastSeen != null){
      if(lastSeen.isJuz!){
        RouteHelper.currentContext.read<QuranProvider>().setJuzText(juzId: lastSeen.juzId!,title: lastSeen.juzArabic!,fromWhere: 0,isJuz: true,);
        Navigator.of(RouteHelper.currentContext).pushNamedAndRemoveUntil(RouteHelper.application, (route) => false);
        Navigator.of(RouteHelper.currentContext).push(MaterialPageRoute(builder: (context) {
          return const QuranTextView();
        },));
      }else{
        // coming from surah so isJuz already false
        // coming from surah so JuzId already -1
        RouteHelper.currentContext.read<QuranProvider>().setSurahText(surahId: lastSeen.surahId!,title: 'سورة ${lastSeen.surahNameArabic}',fromWhere: 0);
        Navigator.of(RouteHelper.currentContext).pushNamedAndRemoveUntil(RouteHelper.application, (route) => false);
        Navigator.of(RouteHelper.currentContext).push(MaterialPageRoute(builder: (context) {
          return const QuranTextView();
        },));
      }
    }else{
      RouteHelper.currentContext.read<QuranProvider>().setSurahText(surahId: 1,title: 'سورةالفاتحة',fromWhere: 1);
      Navigator.of(RouteHelper.currentContext).pushNamedAndRemoveUntil(RouteHelper.application, (route) => false);
      Navigator.of(RouteHelper.currentContext).push(MaterialPageRoute(builder: (context) {
        return const QuranTextView();
      },));
    }
  }
  void listenToNotification(){
    NotificationServices.onNotification.stream.listen((event) {
      if(event != null){
        _isListening = true;
        // Fluttertoast.showToast(msg: "listening");
        notificationOnClick(event);
      }else{
        // Fluttertoast.showToast(msg: "Not listening");
        _isListening = false;
      }
    });
  }

  notificationOnClick(String payload){
    if(payload == "recite"){
      gotoQuranTextView();
    }else if(payload == "dua"){
      RouteHelper.currentContext.read<BottomTabsPageProvider>().setCurrentPage(0);
      Navigator.of(RouteHelper.currentContext).pushNamedAndRemoveUntil(RouteHelper.application, (route) => false);
    }else{
      Navigator.of(RouteHelper.currentContext).pushNamedAndRemoveUntil(RouteHelper.application, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    var isDark = context.read<ThemProvider>().isDark;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkColor : Colors.white,
          image: DecorationImage(
            image: Image.asset('assets/images/splash/bg.webp',fit: BoxFit.cover,).image
          )
        ),
      ),
    );
  }
}

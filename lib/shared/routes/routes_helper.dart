import 'package:flutter/material.dart';
import 'package:nour_al_quran/pages/more/pages/names_of_allah/name_of_allah_page.dart';
import 'package:nour_al_quran/pages/more/pages/qibla_direction/qibla_direction.dart';
import 'package:nour_al_quran/pages/more/pages/salah_timer/salah_timer_page.dart';
import 'package:nour_al_quran/pages/more/pages/shahada/pages/shahada_page.dart';
import 'package:nour_al_quran/pages/more/pages/step_by_step_salah/steps_by_step_salah_page.dart';
import 'package:nour_al_quran/pages/more/pages/tasbeeh/pages/tasbeeh_page.dart';
import 'package:nour_al_quran/pages/onboarding/pages/index.dart';
import 'package:nour_al_quran/pages/quran/pages/duas/dua_page.dart';
import 'package:nour_al_quran/pages/quran/pages/recitation/reciter/player/audio_player_page.dart';
import 'package:nour_al_quran/pages/quran/pages/recitation/reciter/reciter_page.dart';
import 'package:nour_al_quran/pages/quran/pages/recitation/view_all/view_all.dart';
import 'package:nour_al_quran/pages/settings/pages/about_the_app/about_the_app_page.dart';
import 'package:nour_al_quran/pages/settings/pages/download_manager/reciter_download_surahs_page.dart';
import 'package:nour_al_quran/pages/settings/pages/fonts/fonts_page.dart';
import 'package:nour_al_quran/pages/settings/pages/my_state/my_state_page.dart';
import 'package:nour_al_quran/pages/settings/pages/notifications/notification_setting_page.dart';
import 'package:nour_al_quran/pages/settings/pages/privacy_policy/privacy_policy_page.dart';
import 'package:nour_al_quran/pages/settings/pages/profile/edit_profile_page.dart';
import 'package:nour_al_quran/pages/settings/pages/profile/manage_profile_page.dart';
import 'package:nour_al_quran/pages/settings/pages/report_an_issue/report_issue_page.dart';
import 'package:nour_al_quran/pages/settings/pages/subscriptions/manage_subscription_page.dart';
import 'package:nour_al_quran/pages/settings/pages/subscriptions/upgrade_to_premium_page.dart';
import 'package:nour_al_quran/pages/settings/pages/terms_of_service/terms_of_services_page.dart';
import 'package:nour_al_quran/pages/sign_in/pages/sigin_page.dart';
import 'package:nour_al_quran/pages/sign_in/pages/sign_up_page.dart';
import 'package:nour_al_quran/pages/splash/splash.dart';
import '../../pages/basics_of_quran/pages/basics_content_page.dart';
import '../../pages/basics_of_quran/pages/basics_of_quran_page.dart';
import '../../pages/bottom_tabs/pages/bottom_tab_page.dart';
import '../../pages/quran stories/pages/story_content_page.dart';
import '../widgets/story_n_basics_player.dart';
import '../../pages/miracles_of_quran/pages/miracle_content_page.dart';
import '../../pages/miracles_of_quran/pages/miracles_of_quran_page.dart';

class RouteHelper{
  static const String initRoute = "/";
  static const String achieveWithQuran = "/achieve";
  static const String reviewOne = "/reviewOne";
  static const String setFavReciter = "/setFavReciter";
  static const String whenToRecite = "/whenToRecite";
  static const String quranReminder = "/quranReminder";
  static const String setDailyQuranReadingTime = "/dailyQuran";
  static const String preferredLanguage = "setLanguage";
  static const String signIn = "/signIn";
  static const String signUp = "/signUp";
  static const String yourName = "/yourName";
  static const String notificationSetup = "/notificationSetup";
  static const String application = "/bottom_tabs";
  static const String reciter = "/reciter";
  static const String dua = "/duas";
  static const String surah = "/surah";
  static const String shahada = "/shahada";
  static const String qiblaDirection = "/qibla";
  static const String namesOfALLAH = "/namesOfALLAH";
  static const String stepsOFPrayer = "/steps";
  static const String tasbeeh = "/tasbeeh";
  static const String salahTimer = "/salahTimer";
  static const String upgradeApp =  "/upgradeApp";
  static const String managePremium = "/managePremium";
  static const String editProfile = "/editProfile";
  static const String manageProfile = "/manageProfile";
  static const String appFont = "/appFont";
  static const String allReciters = "allReciters";
  static const String audioPlayer = "/audioPlayer";
  static const String miraclesOfQuran = "/miracles";
  static const String miraclesDetails = "/miraclesDetail";
  // static const String chapterList = "/chapterList";
  static const String storyPlayer = "/storyPlayer";
  static const String storyDetails = "/storyDetail";
  static const String downloadedSurahManager = "/downloadSurahManager";
  static const String basicsOfQuran = "/quranBasics";
  static const String basicsOfIslamDetails = "/basicsOfIslamTopicDetails";
  static const String completeProfile = "/completeProfile";
  static const String reportIssue = "/reportIssue";
  static const String privacyPolicy = "/privacyPolicy";
  static const String termsOfServices = "/termsOfServices";
  static const String aboutApp = "/aboutApp";
  static const String notificationSetting = "notificationSetting";
  static const String myState = "myState";


  static late BuildContext currentContext;

  static Map<String, Widget Function(BuildContext)> routes(BuildContext context){
    return {
      initRoute: (context) {
        currentContext = context;
        return const SplashPage();
      },
      achieveWithQuran: (context) {
        currentContext = context;
        return const AchieveWithQuranPage();
      },
      reviewOne: (context) {
        currentContext = context;
        return const ReviewOne();
      },
      setFavReciter: (context) {
        currentContext = context;
        return const SetFavReciter();
      },
      whenToRecite: (context) {
        currentContext = context;
        return const WhenToRecite();
      },
      quranReminder: (context) {
        currentContext = context;
        return const QuranReminder();
      },
      setDailyQuranReadingTime: (context) {
        currentContext = context;
        return const SetDailyQuranReadingTime();
      },
      preferredLanguage: (context) {
        currentContext = context;
        return const SetPreferredLanguage();
      },
      signIn: (context) {
        currentContext = context;
        return const SignInPage();
      },
      signUp: (context){
        currentContext = context;
        return const SignUpPage();
      },
      yourName: (context) {
        return const YourNamePage();
      },
      notificationSetup: (context) {
        currentContext = context;
        return const NotificationSetup();
      },
      application: (context) {
        currentContext = context;
        return const BottomTabsPage();
      },
      reciter: (context){
        currentContext = context;
        return const ReciterPage();
      },
      dua: (context) {
        currentContext = context;
        return const DuaPage();
      },
      shahada: (context) {
        currentContext = context;
        return const ShahadahPage();
      },
      qiblaDirection: (context) {
        currentContext = context;
        return const QiblaDirectionPage();
      },
      namesOfALLAH: (context) {
        currentContext = context;
        return const NamesOfALLAHPage();
      },
      stepsOFPrayer: (context) {
        currentContext = context;
        return const StepByStepSalahPage();
      },
      tasbeeh: (context) {
        currentContext = context;
        return const TasbeehPage();
      },
      salahTimer: (context) {
        currentContext = context;
        return const SalahTimerPage();
      },
      upgradeApp: (context) {
        currentContext = context;
        return const UpgradeToPremiumPage();
      },
      managePremium: (context) {
        currentContext = context;
        return const ManageSubscriptionPage();
      },
      editProfile: (context) {
        currentContext = context;
        return EditProfilepage();
      },
      manageProfile: (context){
        currentContext = context;
        return const ManageProfile();
      },
      appFont: (context) {
        currentContext = context;
        return const FontPage();
      },
      allReciters: (context) {
        currentContext = context;
        return const AllReciters();
      },
      audioPlayer: (context) {
        currentContext = context;
        return const AudioPlayerPage();
      },
      miraclesOfQuran: (context) {
        currentContext = context;
        return const MiraclesOfQuranPage();
      },
      miraclesDetails: (context) {
        currentContext = context;
        return const MiraclesDetailsPage();
      },
      // chapterList: (context) {
      //   currentContext = context;
      //   return const ChaptersPage();
      // },
      storyDetails : (context) {
        currentContext = context;
        return const StoryDetailsPage();
      },
      storyPlayer : (context){
        currentContext = context;
        return const StoryAndBasicsAudioPlayer();
      },
      downloadedSurahManager: (context) {
        currentContext = context;
        return const ReciterDownloadSurahPage();
      },
      basicsOfQuran: (context) {
        currentContext = context;
        return const BasicsOfQuranPage();
      },
      basicsOfIslamDetails: (context) {
        currentContext = context;
        return const IslamBasicDetailsPage();
      },
      completeProfile: (context) {
        currentContext = context;
        return const CompleteProfile();
      },
      reportIssue: (context){
        currentContext = context;
        return const ReportIssuePage();
      },
      privacyPolicy:(context){
        currentContext = context;
        return const PrivacyPolicyPage();
      },
      termsOfServices: (context){
        currentContext = context;
        return const TermsOfServicesPage();
      },
      aboutApp:(context){
        currentContext = context;
        return const AboutTheAppPage();
      },
      notificationSetting:(context){
        currentContext = context;
        return const NotificationSettingPage();
      },
      myState:(context){
        currentContext = context;
        return const MyStatePage();
      }
    };
}
}
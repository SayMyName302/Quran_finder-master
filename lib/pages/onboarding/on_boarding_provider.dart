import 'package:flutter/material.dart';
import 'pages/fav_reciter/fav_reciter.dart';
import '../settings/pages/notifications/notification_services.dart';
import '../../shared/utills/app_constants.dart';

import 'common.dart';

class OnBoardingProvider extends ChangeNotifier {
  // achieve functionality
  // final List<Common> _achieveWithQuranList = [
  //   Common(title: "Stream/Download Reciters", isSelected: false),
  //   Common(title: "Read Offline Quran", isSelected: false),
  //   Common(title: "Set Quran Goals", isSelected: false),
  //   Common(title: "Explore the Quran", isSelected: false),
  //   Common(title: "Translations & Reflection", isSelected: false),
  //   Common(title: "Learn the Qaida", isSelected: false),
  // ];
  // List<Common> get achieveWithQuranList => _achieveWithQuranList;
  // final List<Common> _selectAchieveWithQuranList = [];
  // List<Common> get selectAchieveWithQuranList => _selectAchieveWithQuranList;
  //
  // void addAchieveItem(Common achieve,int index,bool value){
  //   _achieveWithQuranList[index].setIsSelected = !achieveWithQuranList[index].isSelected!;
  //   if(achieveWithQuranList[index].isSelected!){
  //     _selectAchieveWithQuranList.add(achieve);
  //   }else{
  //     _selectAchieveWithQuranList.removeWhere((element) => element == achieve);
  //   }
  //   notifyListeners();
  // }

  final List<String> _achieveWithQuranList = [
    "stream/download_reciters",
    "read_offline_quran",
    "set_quran_goals",
    "explore_the_quran",
    "translations_&_reflection",
    "learn_the_qaida",
  ];
  List<String> get achieveWithQuranList => _achieveWithQuranList;
  final List<String> _selectAchieveWithQuranList = [];
  List<String> get selectAchieveWithQuranList => _selectAchieveWithQuranList;

  void addAchieveItem(String item, int index) {
    if (!_selectAchieveWithQuranList.contains(item)) {
      _selectAchieveWithQuranList.add(item);
    } else {
      _selectAchieveWithQuranList.removeWhere((element) => element == item);
    }
    notifyListeners();
  }

  // set fav reciter functionality
  final List<FavReciter> _reciterList = [
    FavReciter(
        title: "Sheikh Mishary Al Afasy", isPlaying: false, audioUrl: ""),
    FavReciter(title: "Sheikh Maher Muaqily", isPlaying: false, audioUrl: ""),
    FavReciter(title: "Abdur-Rahman as-Sudais", isPlaying: false, audioUrl: ""),
    FavReciter(title: "Ibtraaheem Ash-Shuraym", isPlaying: false, audioUrl: ""),
    FavReciter(title: "Hani ar-Rifai", isPlaying: false, audioUrl: ""),
    FavReciter(title: "Mahmoud Al-Hussary", isPlaying: false, audioUrl: ""),
  ];
  List<FavReciter> get reciterList => _reciterList;

  String favReciter = "Sheikh Mishary Al Afasy";

  void setFavReciter(int index) {
    favReciter = _reciterList[index].title!;
    notifyListeners();
  }

  void setIsPlaying(int index) {
    _reciterList[index].setIsPlaying = !_reciterList[index].isPlaying!;
    notifyListeners();
  }

  // set like to recite
  final List<String> _likeToRecite = [
    "morning",
    "afternoon",
    "evening",
    "night"
  ];
  List<String> get likeToRecite => _likeToRecite;

  String selectTimeLikeToRecite = "Morning";

  void selectTimeToRecite(int index) {
    selectTimeLikeToRecite = _likeToRecite[index];
    notifyListeners();
  }

  // set dailyQuran time
  final List<String> _dailyTime = [
    "5_minutes",
    "10_minutes",
    "15_minutes",
    "20_minutes",
    "30_minutes"
  ];

  List<String> get dailyTime => _dailyTime;

  String selectedDailyTime = "5 minutes";

  void selectDailyTime(int index) {
    selectedDailyTime = _dailyTime[index];
    notifyListeners();
  }

  // recitation Reminder
  DateTime _recitationReminderTime = DateTime.now();
  DateTime get recitationReminderTime =>
      _recitationReminderTime; // set notification
  void setRecitationReminderTime(DateTime dateTime) {
    _recitationReminderTime = dateTime;
    notifyListeners();
  }

  // set notifications
  final List<Common> _notification = [
    Common(title: "daily_quran_recitation_reminder", isSelected: true),
    Common(title: "daily_quran_verse", isSelected: true),
    // Common(title: "Dua Reminder", isSelected: true),
    Common(title: "daily_salah_reminder", isSelected: true),
    Common(title: "friday_prayer_reminder", isSelected: true),
  ];

  List<Common> get notification => _notification;
  void setNotification(int index, bool value) {
    _notification[index].setIsSelected = value;
    notifyListeners();
    // if(index == 2 || index == 3){
    //   ScaffoldMessenger.of(RouteHelper.currentContext).showSnackBar(const SnackBar(content: Text("U Can Turn On This setting from Salah Timer Page")));
    // }else{
    //
    // }
    if (index == 0 && value == false) {
      NotificationServices().cancelNotifications(dailyQuranRecitationId);
    }
    if (index == 1 && value == false) {
      NotificationServices().cancelNotifications(dailyVerseNotificationId);
    }
  }
}

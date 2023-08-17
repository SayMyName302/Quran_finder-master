import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:nour_al_quran/pages/onboarding/models/fav_reciter.dart';
import 'package:nour_al_quran/pages/settings/pages/notifications/notification_services.dart';
import 'package:nour_al_quran/shared/utills/app_constants.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../settings/pages/profile/profile_provider.dart';
import '../models/common.dart';

class OnBoardingProvider extends ChangeNotifier {
  // achieve functionality

  final List<String> _achieveWithQuranList = [
    "stream_download_reciters",
    "read_offline_quran",
    "set_quran_goals",
    "explore_the_quran",
    "translations_&_reflection",
    "learn_the_qaida",
  ];
  List<String> get achieveWithQuranList => _achieveWithQuranList;
  final List<String> _selectAchieveWithQuranList = [];
  List<String> get selectAchieveWithQuranList => _selectAchieveWithQuranList;

  void addAchieveItem(String item, int index, BuildContext context) {
    if (!_selectAchieveWithQuranList.contains(item)) {
      if (selectAchieveWithQuranList.length < 3) {
        _selectAchieveWithQuranList.add(item);
        Provider.of<ProfileProvider>(context, listen: false)
            .userProfile!
            .setPurposeOfQuran = selectAchieveWithQuranList;
        print("items $item");
      } else {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(const SnackBar(
            content: Text("U Can Select Only Three Goals"),
            duration: Duration(milliseconds: 500),
          ));
      }
    } else {
      _selectAchieveWithQuranList.removeWhere((element) => element == item);
      Provider.of<ProfileProvider>(context, listen: false)
          .userProfile!
          .setPurposeOfQuran = selectAchieveWithQuranList;
    }
    notifyListeners();
  }

  // set fav reciter functionality
  final List<FavReciter> _reciterList = [
    FavReciter(
      title: "Mishary Rashid Alafasy",
      isPlaying: false,
      audioUrl: "assets/audios/fav_reciters/Mishary Al Afsay.mp3",
      reciterId: 10,
      imageUrl: "assets/images/reciters/mishray_rashid_al_afasy.webp",
    ),
    FavReciter(
      title: "Abdul Basit Abdul Samad",
      isPlaying: false,
      audioUrl: "assets/audios/fav_reciters/abdul_basit_abdul_samad.mp3",
      reciterId: 2,
      imageUrl: "assets/images/reciters/abdul_basit_abdus_samad.webp",
    ),
    FavReciter(
      title: "Maher Al-Muaiqly",
      isPlaying: false,
      audioUrl: "assets/audios/fav_reciters/maher_al_muaiqly.mp3",
      reciterId: 4,
      imageUrl: "assets/images/reciters/sheikh_maher_al_muaiqly.png",
    ),
    FavReciter(
      title: "Abdul Rahman Al-Sudais",
      isPlaying: false,
      audioUrl: "assets/audios/fav_reciters/abdul_rahman_al_sudais.mp3",
      reciterId: 11,
      imageUrl: "assets/images/reciters/abdul_rahman_al_sudais.webp",
    ),
    FavReciter(
      title: "Ahmed Al-Ajmi",
      isPlaying: false,
      audioUrl: "assets/ audios/fav_reciters/ahmed_al_ajmi.mp3",
      reciterId: 13,
      imageUrl: "assets/images/reciters/sheikh_ahmed_al_ajmi.webp",
    ),
    FavReciter(
      title: "Saad Al-Ghamdi",
      isPlaying: false,
      audioUrl: "assets/audios/fav_reciters/saad_al_ghamdi.mp3",
      reciterId: 1,
      imageUrl: "assets/images/reciters/saad_el_ghamidi.webp",
    ),
    FavReciter(
      title: "Muhammad Siddeeq",
      isPlaying: false,
      audioUrl: "assets/audios/fav_reciters/muhammad_siddeeq.mp3",
      reciterId: 15,
      imageUrl:
          "assets/images/reciters/sheikh_muhammad_siddiq_al_minshawi.webp",
    ),
    FavReciter(
      title: "Yasser Al-Dosari",
      isPlaying: false,
      audioUrl: "assets/audios/fav_reciters/yasser_al_dosari.mp3",
      reciterId: 17,
      imageUrl: "assets/images/reciters/sheikh_yasser_al_dosari.webp",
    ),
    FavReciter(
      title: "Raad Mohammad al Kurdi",
      isPlaying: false,
      audioUrl: "assets/audios/fav_reciters/raad_muhammad_al_kurdi.mp3",
      reciterId: 40,
      imageUrl: "assets/images/reciters/raad_muhammad_al-kurdi.png",
    ),
    FavReciter(
      title: "Abdul Rahman Al Ossi",
      isPlaying: false,
      audioUrl: "assets/audios/fav_reciters/abdul_rahman_al_ossi.mp3",
      reciterId: 44,
      imageUrl: "assets/images/reciters/abdul_rahman_al_ossi.png",
    ),
  ];
  List<FavReciter> get reciterList => _reciterList;

  String favReciter = "Abdur- Rahman As- Sudais";

  final AudioPlayer _audioPlayer = AudioPlayer();

  initAudioPlayer(String audio) async {
    _audioPlayer.setAsset(audio);
    await _audioPlayer.play();
  }

  void setFavReciter(int index) {
    favReciter = _reciterList[index].title!;
    notifyListeners();
  }

  Future<void> setIsPlaying(int index) async {
    if (!_reciterList[index].isPlaying!) {
      _reciterList[index].setIsPlaying = true;
      _audioPlayer.setAsset(_reciterList[index].audioUrl!);
      await _audioPlayer.play();
      _audioPlayer.playerStateStream.listen((event) {
        if (event.processingState == ProcessingState.completed) {
          _reciterList[index].setIsPlaying = false;
          notifyListeners();
        }
      });
    }
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

  String selectTimeLikeToRecite = "morning";

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

  String selectedDailyTime = "5_minutes";

  void selectDailyTime(int index) {
    selectedDailyTime = _dailyTime[index];
    notifyListeners();
  }

  // recitation Reminder
  final TimeOfDay _recitationReminderTime = TimeOfDay.now();
  TimeOfDay get recitationReminderTime =>
      _recitationReminderTime; // set notification

  // set notifications
  final List<Common> _notification = [
    Common(title: "daily_quran_recitation_reminder", isSelected: true),
    Common(title: "daily_quran_verse", isSelected: true),
    // Common(title: "Dua Reminder", isSelected: true),
    Common(title: "daily_salah_reminder", isSelected: true),
    Common(title: "friday_prayer_reminder", isSelected: true),
  ];

  List<Common> get notification => _notification;
  void setNotification(int index, bool value) async{
    _notification[index].setIsSelected = value;
    notifyListeners();
    NotificationServices().checkPermissionAndSetNotification(() {
      setOrCancelNotification(index, value);
    });
  }

  setOrCancelNotification(int index, bool value){
    if (index == 0 && value == false) {
      NotificationServices().cancelNotifications(dailyQuranRecitationId);
    } else if (index == 1 && value == false) {
      NotificationServices().cancelNotifications(dailyVerseNotificationId);
    }
  }
}

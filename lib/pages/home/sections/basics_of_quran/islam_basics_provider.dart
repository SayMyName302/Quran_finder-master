import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../home_page.dart';
import '../../../../shared/database/home_db.dart';
import '../../../../shared/routes/routes_helper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../player/story_player_provider.dart';
import 'islam_basics.dart';

class IslamBasicsProvider extends ChangeNotifier {
  List<IslamBasics> _islamBasics = [];
  List<IslamBasics> get islamBasics => _islamBasics;
  IslamBasics? _selectedIslamBasics;
  IslamBasics? get selectedIslamBasics => _selectedIslamBasics;
  int _currentIslamBasics = 0;
  int get currentIslamBasics => _currentIslamBasics;
  double _downloaded = 0;
  double get downloaded => _downloaded;
  bool _isDownloading = false;
  bool get isDownloading => _isDownloading;

  Future<void> getIslamBasics() async {
    _islamBasics = await HomeDb().getIslamBasics();
    notifyListeners();
  }

  void goToIslamTopicPage(int index, BuildContext context) {
    _selectedIslamBasics = _islamBasics[index];
    notifyListeners();
    Navigator.of(context).pushNamed(RouteHelper.basicsOfIslamDetails);
  }

  void gotoPlayerPage(BuildContext context, String audioFile) {
    Provider.of<StoryPlayerProvider>(context, listen: false)
        .initAudioPlayer(audioFile, _selectedIslamBasics!.image!);
    Navigator.of(context)
        .pushNamed(RouteHelper.storyPlayer, arguments: 'fromBasic');
  }

  Future<void> checkAudioExist(
      String islamBasicTitle, BuildContext context) async {
    _currentIslamBasics =
        _islamBasics.indexWhere((element) => element.title == islamBasicTitle);
    _selectedIslamBasics = _islamBasics[_currentIslamBasics];
    var directory = await getApplicationDocumentsDirectory();
    var storiesAudioFolder = "${directory.path}/islamBasicsAudios";
    if (!Directory(storiesAudioFolder).existsSync()) {
      Directory(storiesAudioFolder).createSync();
    }
    var audioPath = File("$storiesAudioFolder/$islamBasicTitle.mp3");
    print(audioPath.path);
    if (audioPath.existsSync()) {
      Future.delayed(
          Duration.zero, () => gotoPlayerPage(context, audioPath.path));
    } else {
      Future.delayed(Duration.zero, () => downloadStoryAudio(context));
    }
  }

  Future<void> downloadStoryAudio(BuildContext context) async {
    try {
      showProgressLoading(_downloaded, context, false);
      _isDownloading = true;
      notifyListeners();
      Dio dio = Dio();
      var response = await dio.get(
        _selectedIslamBasics!.audioUrl!,
        onReceiveProgress: (receive, total) {
          _downloaded = (receive / total) * 100;
          notifyListeners();
        },
        options: Options(responseType: ResponseType.bytes),
      );
      if (response.statusCode == 200) {
        _downloaded = 0;
        var file = <int>[];
        file.addAll(response.data);
        var directory = await getApplicationDocumentsDirectory();
        var storiesAudioFolder = "${directory.path}/islamBasicsAudios";
        if (!Directory(storiesAudioFolder).existsSync()) {
          Directory(storiesAudioFolder).createSync();
        }
        String filePath =
            "$storiesAudioFolder/${_selectedIslamBasics!.title!}.mp3";
        File(filePath).writeAsBytes(file).then((value) {
          Navigator.of(context).pop();
          _isDownloading = false;
          notifyListeners();
          Future.delayed(
              Duration.zero, () => gotoPlayerPage(context, value.path));
        });
      }
    } on DioError {
      Navigator.of(context).pop();
      _isDownloading = false;
      notifyListeners();
    } catch (e) {
      Navigator.of(context).pop();
      _isDownloading = false;
      notifyListeners();
    }
  }
}

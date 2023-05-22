import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nour_al_quran/shared/database/home_db.dart';
import 'package:nour_al_quran/shared/routes/routes_helper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../../../../shared/providers/story_n_basics_audio_player_provider.dart';
import '../models/islam_basics.dart';

class IslamBasicsProvider extends ChangeNotifier{
  List<IslamBasics> _islamBasics = [];
  List<IslamBasics> get islamBasics => _islamBasics;
  IslamBasics? _selectedIslamBasics;
  IslamBasics? get selectedIslamBasics => _selectedIslamBasics;
  int _currentIslamBasics = 0;
  int get currentIslamBasics => _currentIslamBasics;

  Future<void> getIslamBasics() async {
    _islamBasics = await HomeDb().getIslamBasics();
    notifyListeners();
  }

  void goToBasicsContentPage(int index,BuildContext context){
    _selectedIslamBasics = _islamBasics[index];
    notifyListeners();
    Navigator.of(context).pushNamed(RouteHelper.basicsOfIslamDetails);
  }

  gotoBasicsPlayerPage(String islamBasicTitle,BuildContext context){
    _currentIslamBasics = _islamBasics.indexWhere((element) => element.title == islamBasicTitle);
    _selectedIslamBasics = _islamBasics[_currentIslamBasics];
    Provider.of<StoryAndBasicPlayerProvider>(context,listen: false).initAudioPlayer(_selectedIslamBasics!.audioUrl!, _selectedIslamBasics!.image!,context);
    Navigator.of(context).pushNamed(RouteHelper.storyPlayer,arguments: 'fromBasic');
  }
}

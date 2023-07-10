// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:nour_al_quran/shared/database/home_db.dart';
import 'package:nour_al_quran/shared/routes/routes_helper.dart';

import '../../../../../shared/providers/story_n_basics_audio_player_provider.dart';
import '../models/islam_basics.dart';

class IslamBasicsProvider extends ChangeNotifier {
  List<IslamBasics> _islamBasics = [];
  SharedPreferences? _preferences;
  List<IslamBasics> get islamBasics => _islamBasics;
  IslamBasics? _selectedIslamBasics;
  IslamBasics? get selectedIslamBasics => _selectedIslamBasics;
  int _currentIslamBasics = 0;
  int? _tappedItemIndex; // Store the index of the tapped item

  int get currentIslamBasics => _currentIslamBasics;

  Future<void> getIslamBasics() async {
    _islamBasics = await HomeDb().getIslamBasics();
    _loadBasicsOrder();
    notifyListeners();
  }

  IslamBasicsProvider() {
    _initSharedPreferences();
  }

  Future<void> _initSharedPreferences() async {
    _preferences = await SharedPreferences.getInstance();
  }

  void goToBasicsContentPage(int index, BuildContext context) {
    _selectedIslamBasics = _islamBasics[index];
    _tappedItemIndex = index; // Store the tapped item index
    notifyListeners();
    Navigator.of(context)
        .pushNamed(RouteHelper.basicsOfIslamDetails)
        .then((_) => _resetTappedItemIndex());
  }

  gotoBasicsPlayerPage(
      String islamBasicTitle, BuildContext context, int index) {
    _currentIslamBasics =
        _islamBasics.indexWhere((element) => element.title == islamBasicTitle);
    _selectedIslamBasics = _islamBasics[_currentIslamBasics];
    Provider.of<StoryAndBasicPlayerProvider>(context, listen: false)
        .initAudioPlayer(_selectedIslamBasics!.audioUrl!,
            _selectedIslamBasics!.image!, context);
    Navigator.of(context)
        .pushNamed(RouteHelper.storyPlayer, arguments: 'fromBasic');
  }

  void _moveBasicsToEnd() {
    if (_tappedItemIndex != null) {
      final selectedBasics = _islamBasics[_tappedItemIndex!];
      _islamBasics.removeAt(_tappedItemIndex!);
      _islamBasics.add(selectedBasics);
      _tappedItemIndex = null; // Reset the tapped item index
      _saveBasicsOrder();
    }
  }

  void _resetTappedItemIndex() {
    _tappedItemIndex = null;
  }

  void _saveBasicsOrder() {
    final List<String> order =
        _islamBasics.map((basics) => basics.title!).toList();
    _preferences?.setStringList('basics_order', order);
  }

  void _loadBasicsOrder() {
    final List<String>? order = _preferences?.getStringList('basics_order');
    if (order != null && order.isNotEmpty) {
      final List<IslamBasics> sortedBasics = [];
      for (final title in order) {
        final basics = _islamBasics.firstWhere((m) => m.title == title,
            orElse: () => throw Exception('Basics not found'));
        if (basics != null) {
          sortedBasics.add(basics);
        }
      }
      if (sortedBasics.length != _islamBasics.length) {
        _islamBasics = sortedBasics;
        _saveBasicsOrder();
      } else {
        for (int i = 0; i < sortedBasics.length; i++) {
          _islamBasics[i] = sortedBasics[i];
        }
      }
      notifyListeners();
    }
  }
}

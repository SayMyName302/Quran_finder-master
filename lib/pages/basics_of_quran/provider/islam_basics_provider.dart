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
    _currentIslamBasics = index;
    _selectedIslamBasics = _islamBasics[index];
    notifyListeners();

    _moveBasicToEnd(index);

    Navigator.of(context).pushNamed(RouteHelper.basicsOfIslamDetails);
  }

  gotoBasicsPlayerPage(
      String islamBasicTitle, BuildContext context, int index) {
    _currentIslamBasics =
        _islamBasics.indexWhere((element) => element.title == islamBasicTitle);
    _selectedIslamBasics = _islamBasics[_currentIslamBasics];
    Provider.of<StoryAndBasicPlayerProvider>(context, listen: false)
        .initAudioPlayer(_selectedIslamBasics!.audioUrl!,
            _selectedIslamBasics!.image!, context);
    _moveBasicToEnd(index);
    Navigator.of(context)
        .pushNamed(RouteHelper.storyPlayer, arguments: 'fromBasic');
  }

  void _moveBasicToEnd(int index) {
    _selectedIslamBasics =
        _islamBasics[index]; // Set the selected story to the one being moved
    notifyListeners();

    Future.delayed(const Duration(milliseconds: 300), () {
      _islamBasics.removeAt(index);
      _islamBasics.add(_selectedIslamBasics!);
      notifyListeners();
      _saveBasicsOrder();

      // Find the new index of the selected story after it has been moved
      _currentIslamBasics = _islamBasics.indexOf(_selectedIslamBasics!);
      notifyListeners();
    });
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

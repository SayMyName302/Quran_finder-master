import 'package:flutter/material.dart';

class OnBoardingInformation{
  List<String>? _purposeOfQuran;
  String? _favReciter;
  String? _whenToReciterQuran;
  TimeOfDay? _recitationReminder;
  String? _dailyQuranReadTime;
  Locale? _preferredLanguage;
  List<String>? get purposeOfQuran => _purposeOfQuran;
  String? get favReciter => _favReciter;
  String? get whenToReciterQuran => _whenToReciterQuran;
  TimeOfDay? get recitationReminder => _recitationReminder;
  String? get dailyQuranReadTime => _dailyQuranReadTime;
  Locale? get preferredLanguage => _preferredLanguage;

  OnBoardingInformation({
    required purposeOfQuran,
    required favReciter,
    required whenToReciterQuran,
    required recitationReminder,
    required dailyQuranReadTime,
    required preferredLanguage,
    }){
    _purposeOfQuran = purposeOfQuran;
    _favReciter = favReciter;
    _whenToReciterQuran = whenToReciterQuran;
    _recitationReminder = recitationReminder;
    _dailyQuranReadTime = dailyQuranReadTime;
    _preferredLanguage = preferredLanguage;
  }

  OnBoardingInformation.fromJson(Map<String,dynamic> json){
    _purposeOfQuran = json['purposeOfQuran'];
    _favReciter = json['favReciter'];
    _whenToReciterQuran = json['whenToReciterQuran'];
    _recitationReminder = json['recitationReminder'];
    _dailyQuranReadTime = json['dailyQuranReadTime'];
    _preferredLanguage = json['preferredLanguage'];
  }

  Map toJson(){
    return {
      'purposeOfQuran': _purposeOfQuran,
      'favReciter' : _favReciter,
      'whenToReciterQuran' : _whenToReciterQuran,
      'recitationReminder' : _recitationReminder,
      'dailyQuranReadTime' : _dailyQuranReadTime,
      'preferredLanguage' : _preferredLanguage,
    };
  }
}
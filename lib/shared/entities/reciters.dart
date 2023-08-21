import 'dart:convert';

import 'package:flutter/material.dart';

class Reciters {
  int? _reciterId;
  String? _reciterName;
  List? _recitationCount;
  List<int>? _downloadSurahList;
  String? _imageUrl;
  String? _audioUrl;
  int? _isFav;
  String? _categorize;
  String? _similarReciters;
  String? _reciterShortname; // Add the reciter_shortname property

  int? get reciterId => _reciterId;
  String? get reciterName => _reciterName;
  List? get recitationCount => _recitationCount;
  List<int>? get downloadSurahList => _downloadSurahList;
  String? get imageUrl => _imageUrl;
  String? get audioUrl => _audioUrl;
  int? get isFav => _isFav;
  String? get categorize => _categorize;
  String? get similarReciters => _similarReciters;
  String? get reciterShortname =>
      _reciterShortname; // Getter for reciter_shortname property

  set setDownloadSurahList(List<int> value) {
    _downloadSurahList = value;
  }

  set setIsFav(int value) => _isFav = value;
  set setCategorize(String? value) => _categorize = value;
  set setSimilarReciters(String? value) => _similarReciters = value;
  set setReciterShortname(String? value) =>
      _reciterShortname = value; // Setter for reciter_shortname property

  Reciters({
    required int reciterId,
    required String reciterName,
    required List recitationCount,
    required List<int> downloadSurahList,
    required String imageUrl,
    required String audioUrl,
    required int isFav,
    required String categorize,
    required String? similarReciters,
    required String?
        reciterShortname, // Include the reciter_shortname property in the constructor
  }) {
    _reciterId = reciterId;
    _reciterName = reciterName;
    _recitationCount = recitationCount;
    _downloadSurahList = downloadSurahList;
    _imageUrl = imageUrl;
    _audioUrl = audioUrl;
    _isFav = isFav;
    _categorize = categorize;
    _similarReciters = similarReciters;
    _reciterShortname =
        reciterShortname; // Assign the reciter_shortname value to the private property
  }

  Reciters.fromJson(Map<String, dynamic> json) {
    _reciterId = json['reciter_id'];
    _reciterName = json['reciter_name'];
    _recitationCount = jsonDecode(json['recitation_count']);
    _downloadSurahList = jsonDecode(json['download_surah_list']).cast<int>();
    _imageUrl = json['image_url'];
    _audioUrl = json['audio_url'];
    _isFav = json['is_fav'];
    _categorize = json['categorize'];
    _similarReciters = json['similar_reciters'];
    _reciterShortname = json[
        'reciter_shortname']; // Fetch the reciter_shortname value from JSON
  }

  Map<String, dynamic> toJson() {
    return {
      "reciter_id": _reciterId,
      "reciter_name": _reciterName,
      "recitation_count": _recitationCount.toString(),
      "download_surah_list": _downloadSurahList.toString(),
      "image_url": _imageUrl,
      "audio_url": _audioUrl,
      "is_fav": _isFav,
      "categorize": _categorize,
      "similar_reciters": _similarReciters,
      "reciter_shortname":
          _reciterShortname, // Include the reciter_shortname property in the JSON
    };
  }

  factory Reciters.fromMap(Map<String, dynamic> map) {
    return Reciters(
      reciterId: map['reciter_id'],
      reciterName: map['reciter_name'],
      recitationCount: jsonDecode(map['recitation_count']),
      downloadSurahList: jsonDecode(map['download_surah_list']).cast<int>(),
      imageUrl: map['image_url'],
      audioUrl: map['audio_url'],
      isFav: map['is_fav'],
      categorize: map['categorize'],
      similarReciters: map['similar_reciters'],
      reciterShortname: map['reciter_shortname'],
    );
  }

  // @override
  // String toString() {
  //   return 'rec_id $reciterId rec_name $reciterName rec_count $recitationCount img $imageUrl title $Title';
  // }
}

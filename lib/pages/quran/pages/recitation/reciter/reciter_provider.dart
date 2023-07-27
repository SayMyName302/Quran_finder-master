import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nour_al_quran/pages/quran/pages/recitation/reciter/player/player_provider.dart';
import 'package:nour_al_quran/shared/entities/reciters.dart';
import 'package:nour_al_quran/shared/entities/surah.dart';
import 'package:nour_al_quran/shared/localization/localization_constants.dart';
import 'package:nour_al_quran/shared/providers/download_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../../../../shared/utills/app_constants.dart';

class ReciterProvider extends ChangeNotifier {
  List<int> _downloadSurahList = [];
  List<int> get downloadSurahList => _downloadSurahList;
  bool isDownload = false;

  setIsDownloading(bool value) {
    isDownload = value;
    notifyListeners();
  }

  void setReciterList(List<int> downloadSurah) {
    _downloadSurahList = downloadSurah;
    // print("After Setting a Surah List For Reciter While Going to Reciter Page -------> $_downloadSurahList");
    notifyListeners();
  }

  void updateDownloadSurahList(int item, BuildContext context) {
    // print('Updating Playlist if player is played Mode ====> update $item');
    context.read<RecitationPlayerProvider>().updatePlayList(item);
  }

  // void resetDownloadSurahList(){
  //   _downloadSurahList = [];
  //   notifyListeners();
  // }

  void downloadSurah(
      Surah surah, BuildContext context, Reciters reciters) async {
    String surahId = "";
    if (!reciters.audioUrl!.contains("cdn.islamic.network")) {
      surahId = surah.surahId.toString().length == 1
          ? "00${surah.surahId}"
          : surah.surahId.toString().length == 2
              ? "0${surah.surahId}"
              : surah.surahId.toString();
    } else {
      surahId = surah.surahId.toString();
    }
    try {
      context.read<DownloadProvider>().setDownloading(true);
      Dio dio = Dio();
      final response = await dio.get(
        "${reciters.audioUrl}/$surahId.mp3",
        onReceiveProgress: (received, total) {
          if (total != -1) {
            final totalSizeInBytes = total;
            final totalSizeInKB = totalSizeInBytes ~/ 1024;
            final totalSizeInMB = totalSizeInKB / 1024;

            String sizeUnit = "";
            double downloadedSize = 0;
            int totalSize = 0;

            if (totalSizeInMB < 1) {
              sizeUnit = "kb";
              downloadedSize = received / 1024;
              totalSize = totalSizeInKB.toInt();
            } else {
              sizeUnit = "mb";
              downloadedSize = received / (1024 * 1024);
              totalSize = totalSizeInMB.toInt();
            }

            final progress = received / total;
            final downloaded = downloadedSize.toStringAsFixed(2);
            final text =
                "$downloaded ${localeText(context, sizeUnit)} ${localeText(context, "of")} $totalSize ${localeText(context, sizeUnit)} ${localeText(context, "downloaded")}";
            context.read<DownloadProvider>().setDownloadProgress(progress);
            context.read<DownloadProvider>().setDownLoadText(text);
          }
        },
        options: Options(responseType: ResponseType.bytes),
      );
      if (response.statusCode == 200) {
        var file = <int>[];
        file.addAll(response.data);
        var directory = await getApplicationDocumentsDirectory();
        var audioDirectory = "${directory.path}/recitation/${reciters.reciterName}/fullRecitations";
        if (!await Directory(audioDirectory).exists()) {
          await Directory(audioDirectory).create(recursive: true);
        }
        String filePath = "$audioDirectory/${surah.surahId}.mp3";
        File(filePath).writeAsBytes(file).then((value) {
          context.read<DownloadProvider>().setDownloading(false);
          context.read<DownloadProvider>().setDownloadProgress(0);
          Navigator.of(context).pop();
          if (context.read<RecitationPlayerProvider>().reciter != null) {
            Reciters playerReciter =
                context.read<RecitationPlayerProvider>().reciter!;
            if (reciters.reciterId == playerReciter.reciterId) {
              updateDownloadSurahList(
                surah.surahId!,
                context,
              );
            }
          }
          if (!_downloadSurahList.contains(surah.surahId!)) {
            _downloadSurahList.add(surah.surahId!);
            notifyListeners();
          }
          // print("After Downloading Surah new Surah Index added =====> $_downloadSurahList");
          reciters.setDownloadSurahList = downloadSurahList;

          // QuranDatabase().updateReciterDownloadList(reciters.reciterId!, reciters);
        });
      }
    } catch (e) {
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('No Internet')));
      });
    }
  }

  /// this method will check reciter folder with his name
  /// if folder available so go inside and return all the
  /// download recitation as list like this [1,2,4]
  Future<List<int>> getAvailableDownloadAudiosAsListOfInt(
      String reciterName) async {
    var directory = await getApplicationDocumentsDirectory();
    final audioFilesPath =
        '${directory.path}/recitation/$reciterName/fullRecitations';
    if (await Directory(audioFilesPath).exists()) {
      final audioDir = Directory(audioFilesPath);
      final audioFiles = audioDir
          .listSync()
          .where((entity) => entity is File && entity.path.endsWith('.mp3'))
          .map((e) => e.path)
          .toList();
      var reciterDownloadList = audioFiles
          .map((str) => int.tryParse(str.split('/').last.split('.').first) ?? 0)
          .toList();
      reciterDownloadList.sort();
      setReciterList(reciterDownloadList);
      return reciterDownloadList;
    } else {
      setReciterList([]);
      return [];
    }
  }


  /// ------ recommended Reciters Logic ------ ///
  List<RecommendedReciter> recommendedReciterList = Hive.box(appBoxKey).get(recommendedReciterListKey) != null
      ? (jsonDecode(Hive.box(appBoxKey).get(recommendedReciterListKey)) as List<dynamic>).map((e) => RecommendedReciter.fromJson(e)).toList() : [];
  int secondElapsed = 0;
  Timer? _timer;

  addRecommendedReciterToList(Reciters reciters,Surah surah){
    RecommendedReciter recommededReciter = RecommendedReciter(reciterId: reciters.reciterId, reciterName: reciters.reciterName, surahName: surah.surahName,surahId: surah.surahId, secondSpend: 0);
    if(!recommendedReciterList.any((element) => element.surahName == surah.surahName)){
      recommendedReciterList.add(recommededReciter);
      saveRecommendedReciters();
    }
    print(recommendedReciterList.toString());
  }

  startTimer(){
    secondElapsed = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      secondElapsed++;
      print("(--------$secondElapsed--------)");
    });
  }

  resetTimer(){
    if(_timer != null){
      secondElapsed = 0;
      _timer!.cancel();
      print("(--------$secondElapsed--------)");
    }
  }


  updateTimeElapsed(Reciters reciters,Surah surah){
    int reciterIndex = recommendedReciterList.indexWhere((element) => element.surahName == surah.surahName);
    if(reciterIndex != -1){
      RecommendedReciter reciter = recommendedReciterList[reciterIndex];
      reciter.setSecondSpend = reciter.secondSpend! + secondElapsed;
      saveRecommendedReciters();
    }else{
      RecommendedReciter recommededReciter = RecommendedReciter(reciterId: reciters.reciterId, reciterName: reciters.reciterName, surahName: surah.surahName,surahId: surah.surahId, secondSpend: secondElapsed);
      recommendedReciterList.add(recommededReciter);
      saveRecommendedReciters();
      print('after Adding New Surah ${recommendedReciterList.toString()}');
    }
  }

  saveRecommendedReciters(){
    Hive.box(appBoxKey).put(recommendedReciterListKey, jsonEncode(recommendedReciterList));
  }
}



class RecommendedReciter{
  int? _reciterId;
  String? _reciterName;
  String? _surahName;
  int? _surahId;
  int? _secondSpend;


  int? get reciterId => _reciterId;
  String? get reciterName => _reciterName;
  String? get surahName => _surahName;
  int? get surahId => _surahId;
  int? get secondSpend => _secondSpend;

  set setSecondSpend(int value) {
    _secondSpend = value;
  }

  RecommendedReciter({required reciterId, required reciterName, required surahName,required surahId, required secondSpend}){
    _reciterId = reciterId;
    _reciterName = reciterName;
    _surahName = surahName;
    _surahId = surahId;
    _secondSpend = secondSpend;
  }

  RecommendedReciter.fromJson(Map<String,dynamic> json){
    _reciterId = json['reciterId'];
    _reciterName = json['reciterName'];
    _surahName = json['surahName'];
    _surahId = json['surahId'];
    _secondSpend = json['secondSpend'];
  }

  Map toJson(){
    return {
      'reciterId':_reciterId,
      'reciterName': _reciterName,
      'surahName':_surahName,
      'surahId':_surahId,
      'secondSpend':_secondSpend
    };
  }

  @override
  String toString() {
    return "(rId: $reciterId, rName: $reciterName, sName: $surahName, sId: $surahId, seconds: $secondSpend)";
  }
}


// void removeDownloadedSurah(int surahId, Reciters reciters) {
// QuranDatabase().updateReciterDownloadList(reciters.reciterId!, reciters);
// }

// get one ayah from local and add to playlist
// Future<String> getAudioFromLocal(Reciters reciters, Surah surah) async {
//   String surahId = surah.surahId.toString().length == 1
//       ? "00${surah.surahId}"
//       : surah.surahId.toString().length == 2
//           ? "0${surah.surahId}"
//           : surah.surahId.toString();
//   var directory = await getApplicationDocumentsDirectory();
//   return "${directory.path}/recitation/${reciters.reciterName}/fullRecitations/$surahId.mp3";
// }
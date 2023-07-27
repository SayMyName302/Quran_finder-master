import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:nour_al_quran/pages/quran/pages/recitation/reciter/reciter_provider.dart';
import 'package:nour_al_quran/shared/database/quran_db.dart';
import 'package:nour_al_quran/shared/entities/reciters.dart';
import 'package:nour_al_quran/shared/entities/surah.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../../../../../settings/pages/my_state/my_state_provider_updated.dart';

class RecitationPlayerProvider with ChangeNotifier {
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  double? _dragValue;
  bool _isPlaying = false;
  AudioPlayer? _audioPlayer;
  bool _isOpen = false;
  bool get isOpen => _isOpen;
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;
  Reciters? _reciter;
  Surah? _surah;
  List<Surah> _surahNamesList = [];
  List<Surah> get surahNamesList => _surahNamesList;
  ConcatenatingAudioSource? _playList;
  ConcatenatingAudioSource? get playList => _playList;
  bool _isLoopMode = false;
  bool get isLoopMode => _isLoopMode;

  Reciters? get reciter => _reciter;
  Surah? get surah => _surah;

  Duration get position => _position;
  double? get dragValue => _dragValue;
  bool get isPlaying => _isPlaying;
  Duration get duration => _duration;
  AudioPlayer get audioPlayer => _audioPlayer!;

  void initAudioPlayer(Reciters reciters, int current,List reciterDownloadList,BuildContext context) async {
    setReciter(reciters);
    List<String> audios = await getAudioFilesFromLocal(reciters.reciterName!);
    _playList = ConcatenatingAudioSource(
      useLazyPreparation: false,
      shuffleOrder: DefaultShuffleOrder(),
      children: List.generate(
          audios.length, (index) => AudioSource.file(audios[index].toString())),
    );
    // setDownloadSurahListToPlayer(reciters.downloadSurahList!);
    setDownloadSurahListToPlayer(reciterDownloadList);
    setCurrentIndex(current,context);
    if (_audioPlayer == null) {
      _init(playList!,context);
    } else {
      _audioPlayer!.stop();
      _audioPlayer = null;
      _init(playList!,context);
    }
  }

  void _init(ConcatenatingAudioSource file,BuildContext context) async {
    _audioPlayer = AudioPlayer();
    // await _audioPlayer!.setFilePath(file);
    await _audioPlayer!.setAudioSource(file, initialIndex: _currentIndex);
    _audioPlayer!.playerStateStream.listen((event) {
      setIsPlaying(event.playing);
      if (event.processingState == ProcessingState.completed && _currentIndex == _surahNamesList.length - 1) {
        _audioPlayer!.seek(Duration.zero);
        _audioPlayer!.pause();
        Provider.of<ReciterProvider>(context,listen: false).updateTimeElapsed(reciter!,surah!);
        Provider.of<ReciterProvider>(context,listen: false).resetTimer();
      }
    });
    _audioPlayer!.currentIndexStream.listen((currentAudio) {
      setCurrentIndex(currentAudio!,context);
    });

    _audioPlayer!.durationStream.listen((duration) {
      if (duration != null) {
        setDuration(duration);
      }
    });
    _audioPlayer!.positionStream.listen((position) {
      setPosition(position);
    });
  }

  Future<void> play(BuildContext context) async {
    var provider = Provider.of<MyStateProvider>(context, listen: false);
    Provider.of<ReciterProvider>(context,listen: false).startTimer();
    provider.startQuranRecitationTimer("other");
    setIsPlaying(true);
    _isOpen = true;
    await _audioPlayer!.play();
  }

  void seekToNext() {
    _audioPlayer!.seekToNext();
  }

  void seekToPrevious() {
    _audioPlayer!.seekToPrevious();
  }

  void setLoopMode(bool value) {
    _isLoopMode = value;
    notifyListeners();
  }

  Future<void> pause(BuildContext context) async {
    if (_audioPlayer != null) {
      Provider.of<ReciterProvider>(context,listen: false).updateTimeElapsed(reciter!,surah!);
      Provider.of<ReciterProvider>(context,listen: false).resetTimer();
      Provider.of<MyStateProvider>(context, listen: false).stopRecitationTimer("other");
      setIsPlaying(false);
      await _audioPlayer!.pause();
    }
  }

  void setIsPlaying(bool isPlay) async {
    _isPlaying = isPlay;
    notifyListeners();
  }

  void setDuration(Duration duration) {
    _duration = duration;
    notifyListeners();
  }

  void setPosition(Duration position) {
    _position = position;
    notifyListeners();
  }

  void setCurrentIndex(int index,BuildContext context) {
    _currentIndex = index;
    if (_surahNamesList.isNotEmpty) {
      if(_isPlaying){
        print("---------------------------------------------------------");
        Provider.of<ReciterProvider>(context,listen: false).updateTimeElapsed(reciter!,surah!);
        Provider.of<ReciterProvider>(context,listen: false).resetTimer();
        Provider.of<ReciterProvider>(context,listen: false).startTimer();
        print("---------------------------------------------------------");
      }
      _surah = _surahNamesList[index];
    }
    notifyListeners();
  }

  void seek(Duration position) {
    _dragValue = position.inSeconds.toDouble();
    notifyListeners();
  }

  void closePlayer() {
    if (_isOpen) {
      _isOpen = false;
      _reciter = null;
      notifyListeners();
      _audioPlayer!.stop();
      _audioPlayer!.dispose();
    }
  }

  void setReciter(Reciters reciter) {
    _reciter = reciter;
    notifyListeners();
  }

  Future<void> setDownloadSurahListToPlayer(List downloadList) async {
    downloadList.sort();
    _surahNamesList = [];
    for (int i = 0; i < downloadList.length; i++) {
      var surah = await QuranDatabase().getSpecificSurahName(downloadList[i]);
      if (!_surahNamesList.contains(surah)) {
        _surahNamesList.add(surah!);
        notifyListeners();
      }
    }
    // print("$downloadList here is surah list");
  }

  /// this will get each surah audio from local storage
  Future<List<String>> getAudioFilesFromLocal(String reciterName) async {
    var directory = await getApplicationDocumentsDirectory();
    final audioFilesPath = '${directory.path}/recitation/$reciterName/fullRecitations';
    final audioDir = Directory(audioFilesPath);
    final audioFiles = audioDir
        .listSync()
        .where((entity) => entity is File && entity.path.endsWith('.mp3'))
        .map((e) => e.path)
        .toList();
    audioFiles.sort((a, b) {
      /// Extract the numeric part of the file names (e.g., '1.mp3' => 1, '114.mp3' => 114)
      int aNumber = int.parse(a.split('/').last.replaceAll(RegExp(r'[^0-9]'), ''));
      int bNumber = int.parse(b.split('/').last.replaceAll(RegExp(r'[^0-9]'), ''));
      return aNumber.compareTo(bNumber);
    });
    // debugPrint("$audioFiles here is audios files");
    return audioFiles;
  }

  Future<void> updatePlayList(int item) async {
    var surah = await QuranDatabase().getSpecificSurahName(item);
    _surahNamesList.add(surah!);
    // String surahId = surah.surahId.toString().length == 1
    //     ? "00${surah.surahId}"
    //     : surah.surahId.toString().length == 2
    //         ? "0${surah.surahId}"
    //         : surah.surahId.toString();
    var directory = await getApplicationDocumentsDirectory();
    final audioFilesPath = '${directory.path}/recitation/${_reciter!.reciterName!}/fullRecitations/${surah.surahId}.mp3';
    _playList!.add(AudioSource.file(audioFilesPath));
    notifyListeners();
  }
}

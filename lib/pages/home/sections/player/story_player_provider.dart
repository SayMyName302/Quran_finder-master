import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class StoryPlayerProvider extends ChangeNotifier{
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  double? _dragValue;
  bool _isPlaying = false;
  AudioPlayer? _audioPlayer;

  Duration get position => _position;
  double? get dragValue => _dragValue;
  bool get isPlaying => _isPlaying;
  Duration get duration => _duration;
  AudioPlayer get audioPlayer => _audioPlayer!;
  String _image = "";
  String get image => _image;
  double _speed = 1.0;
  double get speed => _speed;

  setImage(String image){
    _image = image;
    notifyListeners();
  }
  void initAudioPlayer(String url,String image) async {
    setImage(image);
    if(_audioPlayer == null){
      _init(url);
    }else{
      _audioPlayer!.stop();
      _audioPlayer = null;
      _init(url);
    }
  }

  void _init(String file) async{
    _audioPlayer = AudioPlayer();
    await _audioPlayer!.setFilePath(file);

    _audioPlayer!.playerStateStream.listen((event) {
      setIsPlaying(event.playing);
      if (event.processingState == ProcessingState.completed) {
        _audioPlayer!.seek(Duration.zero);
        _audioPlayer!.pause();
      }
    });

    _audioPlayer!.durationStream.listen((duration) {
      if(duration != null){
        setDuration(duration);
      }
    });
    _audioPlayer!.positionStream.listen((position) {
      setPosition(position);
    });
  }

  setSpeed(){
    _speed = _speed + 0.5;
    _audioPlayer!.setSpeed(_speed);
    if(_speed > 2.0){
      _speed = 0.5;
      _audioPlayer!.setSpeed(1.0);
    }
    notifyListeners();
  }

  Future<void> play() async {
    setIsPlaying(true);
    await _audioPlayer!.play();
  }

  Future<void> pause() async {
    setIsPlaying(false);
    await _audioPlayer!.pause();
  }

  void setIsPlaying(bool isPlay) async {
    _isPlaying = isPlay;
    notifyListeners();
  }

  void setDuration(Duration duration){
    _duration = duration;
    notifyListeners();
  }

  void setPosition(Duration position){
    _position = position;
    notifyListeners();
  }

  void seek(Duration position) {
    _dragValue = position.inSeconds.toDouble();
    notifyListeners();
  }

  void closePlayer(){
    if(_isPlaying){
      _isPlaying = false;
      notifyListeners();
      _audioPlayer!.stop();
      _audioPlayer!.dispose();
    }
  }
}
import 'package:flutter/cupertino.dart';

class DownloadProvider with ChangeNotifier {
  bool _isDownloading = false;
  double _downloadProgress = 0;
  String _downloadText = "";

  String get downloadText => _downloadText;
  bool get isDownloading => _isDownloading;
  double get downloadProgress => _downloadProgress;
  bool _audioDownloaded = false;

  bool get audioDownloaded => _audioDownloaded;

  void setAudioDownloaded(bool value) {
    _audioDownloaded = value;
    notifyListeners();
  }

  setDownloading(bool value) {
    _isDownloading = value;
    notifyListeners();
  }

  setDownloadProgress(double value) {
    _downloadProgress = value;
    notifyListeners();
  }

  setDownLoadText(String text) {
    _downloadText = text;
    notifyListeners();
  }
}

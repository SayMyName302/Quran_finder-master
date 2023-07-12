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
    print('download progress in download provider$_downloadProgress');
    notifyListeners();
  }

  setDownLoadText(String text) {
    _downloadText = text;
    print('download text in download provider$_downloadText');
    notifyListeners();
  }
}

class FavReciter {
  String? _title;
  bool? _isPlaying;
  String? _audioUrl;
  int? _reciterId;
  String? get title => _title;

  bool? get isPlaying => _isPlaying;
  set setIsPlaying(bool value) => _isPlaying = value;
  String? get audioUrl => _audioUrl;
  int? get reciterId => _reciterId;
  FavReciter(
      {required title,
      required isPlaying,
      required audioUrl,
      required reciterId}) {
    _title = title;
    _isPlaying = isPlaying;
    _audioUrl = audioUrl;
    _reciterId = reciterId;
  }
}

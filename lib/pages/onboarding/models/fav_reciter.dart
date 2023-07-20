class FavReciter {
  int? _reciterId;
  String? _title;
  bool? _isPlaying;
  String? _audioUrl;
  String? _imageUrl;

  String? get title => _title;
  bool? get isPlaying => _isPlaying;
  String? get audioUrl => _audioUrl;
  String? get imageUrl => _imageUrl;
  int? get reciterId => _reciterId;

  set setIsPlaying(bool value) => _isPlaying = value;

  FavReciter({
    required String title,
    required bool isPlaying,
    required String audioUrl,
    required int reciterId,
    String? imageUrl,
  }) {
    _title = title;
    _isPlaying = isPlaying;
    _audioUrl = audioUrl;
    _reciterId = reciterId;
    _imageUrl = imageUrl;
  }
}

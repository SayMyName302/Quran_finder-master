import 'dart:convert';

class Reciters {
  int? _reciterId;
  String? _reciterName;
  List? _recitationCount;
  List<int>? _downloadSurahList;
  String? _imageUrl;
  String? _audioUrl;
  int? _isFav;
  String? _categorize;
  String? _similarReciters; // Add the similarReciters property

  int? get reciterId => _reciterId;
  String? get reciterName => _reciterName;
  List? get recitationCount => _recitationCount;
  List<int>? get downloadSurahList => _downloadSurahList;
  String? get imageUrl => _imageUrl;
  String? get audioUrl => _audioUrl;
  int? get isFav => _isFav;
  String? get categorize => _categorize;
  String? get similarReciters =>
      _similarReciters; // Getter for similarReciters property

  set setDownloadSurahList(List<int> value) {
    _downloadSurahList = value;
  }

  set setIsFav(int value) => _isFav = value;
  set setCategorize(String? value) => _categorize = value;
  set setSimilarReciters(String? value) =>
      _similarReciters = value; // Setter for similarReciters property

  Reciters({
    required int reciterId,
    required String reciterName,
    required List recitationCount,
    required List<int> downloadSurahList,
    required String imageUrl,
    required String audioUrl,
    required int isFav,
    required String categorize,
    required String?
        similarReciters, // Include the similarReciters property in the constructor
  }) {
    _reciterId = reciterId;
    _reciterName = reciterName;
    _recitationCount = recitationCount;
    _downloadSurahList = downloadSurahList;
    _imageUrl = imageUrl;
    _audioUrl = audioUrl;
    _isFav = isFav;
    _categorize = categorize;
    _similarReciters =
        similarReciters; // Assign the similarReciters value to the private property
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
    _similarReciters =
        json['similar_reciters']; // Fetch the similarReciters value from JSON
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
      "similar_reciters":
          _similarReciters, // Include the similarReciters property in the JSON
    };
  }
}

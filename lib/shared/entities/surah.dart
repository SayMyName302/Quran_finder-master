class Surah {
  int? _surahId;
  String? _surahName;
  String? _englishName;
  String? _arabicName;

  int? get surahId => _surahId;
  String? get surahName => _surahName;
  String? get englishName => _englishName;
  String? get arabicName => _arabicName;

  Surah(
      {required surahId,
      required surahName,
      required englishName,
      required arabicName}) {
    _surahId = surahId;
    _surahName = surahName;
    _englishName = englishName;
    _arabicName = arabicName;
  }

  Surah.fromJson(Map<String, dynamic> map) {
    _surahId = map['surah_id'];
    _surahName = map['surah_name'];
    _englishName = map['english_name'];
    _arabicName = map['arabic_name'];
  }

  Map<String, dynamic> toJson() {
    return {
      'surah_id': _surahId,
      'surah_name': _surahName,
      'english_name': _englishName,
      'arabic_name': _arabicName
    };
  }
}

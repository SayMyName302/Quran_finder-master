class BookmarksDua {
  int? _duaId; // index of dua in a table
  int? _categoryId; //dua category in a table
  String? _duaTitle; //Title of dua i.e. Dua1/Dua2/Dua3
  String? _duaRef; //Reference of dua
  int? _ayahCount; //Total ayat count
  String? _duaText; // Arabic Text for Dua
  String? _duaTranslation; // Translation for Dua
  int? _bookmarkPosition; // saving dua either 0,1
  String? _contentUrl;

  int? get duaId => _duaId;
  int? get categoryId => _categoryId;
  String? get duaTitle => _duaTitle;
  String? get duaRef => _duaRef;
  int? get ayahCount => _ayahCount;
  String? get duaText => _duaText;
  String? get duaTranslation => _duaTranslation;
  int? get bookmarkPosition => _bookmarkPosition;
  String? get duaUrl => _contentUrl;

  BookmarksDua({
    required duaId,
    required categoryId,
    required duaTitle,
    required duaRef,
    required ayahCount,
    required duaText,
    required duaTranslation,
    required bookmarkPosition,
    required duaUrl,
  }) {
    _duaId = duaId;
    _categoryId = categoryId;
    _duaTitle = duaTitle;
    _duaRef = duaRef;
    _ayahCount = ayahCount;
    _duaText = duaText;
    _duaTranslation = duaTranslation;
    _bookmarkPosition = bookmarkPosition;
    _contentUrl = duaUrl;
  }

  BookmarksDua.fromJson(Map<String, dynamic> json) {
    _duaId = json['duaId'];
    _categoryId = json['categoryId'];
    _duaTitle = json['duaTitle'];
    _duaRef = json['duaRef'];
    _ayahCount = json['ayahCount'];
    _duaText = json['duaText'];
    _duaTranslation = json['duaTranslation'];
    _bookmarkPosition = json['bookmarkPosition'];
    _contentUrl = json['contenturl'];
  }

  Map toJson() {
    return {
      "duaId": _duaId,
      "categoryId": _categoryId,
      "duaTitle": _duaTitle,
      "duaRef": _duaRef,
      "ayahCount": _ayahCount,
      "duaText": _duaText,
      "duaTranslation": _duaTranslation,
      "bookmarkPosition": _bookmarkPosition,
      "contenturl": _contentUrl,
    };
  }
}

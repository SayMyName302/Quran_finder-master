class RecitationAllCategoryModel {
  int? _surahId;
  int? _categoryId;
  int? _surahNo;
  int? _ayahCount;
  String? _title;
  String? _reference;
  String? _contentType;
  String? _contentUrl;
  String? _status;

  int? _isFav;
  int? _playlistId;
  int? _playlistItemId;
  String? _surahName;

  int? get surahId => _surahId;
  int? get categoryId => _categoryId;
  int? get surahNo => _surahNo;
  int? get ayahCount => _ayahCount;
  String? get title => _title;
  String? get reference => _reference;
  String? get contentType => _contentType;
  String? get contentUrl => _contentUrl;
  String? get status => _status;

  int? get isFav => _isFav;
  int? get playlistId => _playlistId;
  int? get playlistItemId => _playlistItemId;
  String? get surahName => _surahName;

  set setIsBookmark(int value) => _isFav = value;

  RecitationAllCategoryModel({
    required int surahId,
    required int categoryId,
    required int surahNo,
    required int ayahCount,
    required String title,
    required String reference,
    required String contentType,
    required String contentUrl,
    required String status,
    required int isFav,
    required int playlistId,
    required int playlistItemId,
    required String surahName,
  }) {
    _surahId = surahId;
    _categoryId = categoryId;
    _surahNo = surahNo;
    _ayahCount = ayahCount;
    _title = title;
    _reference = reference;
    _contentType = contentType;
    _contentUrl = contentUrl;
    _status = status;

    _isFav = isFav;
    _playlistId = playlistId;
    _playlistItemId = playlistItemId;
    _surahName = surahName;
  }

  RecitationAllCategoryModel.fromJson(Map<String, dynamic> json) {
    _surahId = json['surah_id'];
    _categoryId = json['category_id'];
    _surahNo = json['surah_no'];
    _ayahCount = json['ayah_count'];
    _title = json['title'];
    _reference = json['reference'];
    _contentType = json['content_type'];
    _contentUrl = json['content_url'];
    _status = json['status'];

    _isFav = json['is_favorite'];
    _playlistId = json['playlist_id'];
    _playlistItemId = json['playlist_item_id'];
    _surahName = json['surah_name'];
  }

  Map<String, dynamic> toJson() {
    return {
      'surah_id': _surahId,
      'category_id': _categoryId,
      'surah_no': _surahNo,
      'ayah_count': _ayahCount,
      'title': _title,
      'reference': _reference,
      'content_type': _contentType,
      'content_url': _contentUrl,
      'status': _status,
      'is_favorite': _isFav,
      'playlist_id': _playlistId,
      'playlist_item_id': _playlistItemId,
      'surah_name': _surahName,
    };
  }
}

class TranquilTalesModel {
  int? _surahId;
  int? _categoryId;
  int? _surahNo;
  int? _ayahCount;
  String? _title;
  String? _reference;
  String? _contentType;
  String? _contentUrl;
  String? _status;
  int? _orderBy;
  int? _isFav;

  int? get surahId => _surahId;
  int? get categoryId => _categoryId;
  int? get surahNo => _surahNo;
  int? get ayahCount => _ayahCount;
  String? get title => _title;
  String? get reference => _reference;
  String? get contentType => _contentType;
  String? get contentUrl => _contentUrl;
  String? get status => _status;
  int? get orderBy => _orderBy;
  int? get isFav => _isFav;
  set setIsBookmark(int value) => _isFav = value;

  // Getter for content_type

  TranquilTalesModel({
    required surahId,
    required categoryId,
    required surahNo,
    required ayahCount,
    required title,
    required reference,
    required contentType,
    required contentUrl,
    required status,
    required orderBy,
    required isFav,
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
    _orderBy = orderBy;
    _isFav = isFav;
  }

  TranquilTalesModel.fromJson(Map<String, dynamic> json) {
    _surahId = json['surah_id'];
    _categoryId = json['category_id'];
    _surahNo = json['surah_no'];
    _ayahCount = json['ayah_count'];
    _title = json['title'];
    _reference = json['reference'];
    _contentType = json['content_type'];
    _contentUrl = json['content_url'];
    _status = json['status'];
    _orderBy = json['order_by'];
    _isFav = json['is_favorite'];
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
      'order_by': _orderBy,
      'is_favorite': _isFav,
    };
  }

  // @override
  // String toString() {
  //   return 'surahid $surahId category $categoryId isfavorite $isFav ,';
  // }
}

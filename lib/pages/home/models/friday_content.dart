class Friday {
  int? _recitationId;
  int? _viewOrderBy;
  String? _title; //In Db its in this format surah_al-kausar
  String? _reciterName;
  int? _reciterId;
  String? _appImageUrl;
  String? _contentType;
  String? _contentUrl;
  String? _miracleTitle; //In Db its in this format Surah Al-Kausar
  String? _text;

  int? get recitationId => _recitationId;
  int? get viewOrderBy => _viewOrderBy;
  String? get title => _title;
  String? get reciterName => _reciterName;
  int? get reciterId => _reciterId;
  String? get appImageUrl => _appImageUrl;
  String? get contentType => _contentType;
  String? get contentUrl => _contentUrl;
  String? get miracleTitle => _miracleTitle;
  String? get text => _text;

  Friday(
      {required recitationId,
      required viewOrderBy,
      required title,
      required reciterName,
      required reciterId,
      required appImageUrl,
      required contentType,
      required contentUrl,
      required miracleTitle,
      required text}) {
    _recitationId = recitationId;
    _viewOrderBy = viewOrderBy;
    _title = title;
    _reciterName = reciterName;
    _reciterId = reciterId;
    _appImageUrl = appImageUrl;
    _contentType = contentType;
    _contentUrl = contentUrl;
    _miracleTitle = miracleTitle;
    _text = text;
  }

  Friday.fromJson(Map<String, dynamic> json) {
    _recitationId = json['recitation_id'];
    _viewOrderBy = json['view_order_by'];
    _title = json['title'];
    _reciterName = json['reciter_name'];
    _reciterId = json['reciter_id'];
    _appImageUrl = json['app_image_url'];
    _contentType = json['content_type'];
    _contentUrl = json['content_url'];
    _miracleTitle = json['miracle_title'];
    _text = json['text'];
  }

  @override
  String toString() {
    return 'title $title url $contentUrl text $text recId $recitationId';
  }
}

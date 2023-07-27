class CustomTitle {
  String? _rowName;
  String? _screenName;
  String? _titleText;
  String? _language;
  String? _region;
  String? _countryName;

  String? get rowName => _rowName;
  String? get screenName => _screenName;
  String? get titleText => _titleText;
  String? get language => _language;
  String? get region => _region;
  String? get countryName => _countryName;

  CustomTitle({
    required rowname,
    required screenname,
    required titleText,
    required language,
    required region,
    required countryName,
  }) {
    _rowName = rowname;
    _screenName = screenname;
    _titleText = titleText;
    _language = language;
    _region = region;
    _countryName = countryName;
  }

  CustomTitle.fromJson(Map<String, dynamic> json) {
    _rowName = json['row_name'];
    _screenName = json['screen_name'];
    _titleText = json['title_text'];
    _language = json['language'];
    _region = json['region'];
    _countryName = json['country_name'];
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'dua_id': _rowname,
  //     'category_id': _duaCategory,
  //     'dua_text': _duaText,
  //     'dua_title': _duatitle,
  //     'dua_ref': _duaRef,
  //     'translations': _translations,
  //     'content_url': _contentUrl,
  //     'ayah_count': _ayahCount,
  //     'is_fav': _isFav,
  //     'status': _status,
  //     'dua_no': _duaNo,
  //   };
  // }

  // @override
  // String toString() {
  //   return 'Dua: duaId=$id,duaTitle=$duaTitle, duaText=$duaText, translations=$translations, duaRef=$duaRef, totalAyaat=$ayahCount, isFAV ? $isFav, status > $status';
  // }
}

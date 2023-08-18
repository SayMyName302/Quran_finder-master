class RecitationCustomTitles {
  String? _rowName;
  String? _screenName;
  String? _recitationTitleText;
  String? _language;
  String? _region;
  String? _recitationCountryName;
  String? _startHour;
  String? _endHour;
  String? _weather;
  String? _period;

  String? get rowName => _rowName;
  String? get screenName => _screenName;
  String? get titleText => _recitationTitleText;
  String? get language => _language;
  String? get region => _region;
  String? get countryName => _recitationCountryName;
  String? get startHour => _startHour;
  String? get endHour => _endHour;
  String? get weather => _weather;
  String? get period => _period;

  RecitationCustomTitles(
      {required rowname,
      required screenname,
      required titleText,
      required language,
      required region,
      required countryName,
      required startHour,
      required endHour,
      required weather,
      required period}) {
    _rowName = rowname;
    _screenName = screenname;
    _recitationTitleText = titleText;
    _language = language;
    _region = region;
    _recitationCountryName = countryName;
    _startHour = startHour;
    _endHour = endHour;
    _weather = weather;
    _period = period;
  }

  RecitationCustomTitles.fromJson(Map<String, dynamic> json) {
    _rowName = json['row_name'];
    _screenName = json['screen_name'];
    _recitationTitleText = json['title_text'];
    _language = json['language'];
    _region = json['region'];
    _recitationCountryName = json['country_name'];
    _startHour = json['start_hours'];
    _endHour = json['end_hours'];
    _weather = json['weather'];
    _period = json['[period]'];
  }
  @override
  String toString() {
    return 'titles $RecitationCustomTitles countryName $countryName';
  }
}

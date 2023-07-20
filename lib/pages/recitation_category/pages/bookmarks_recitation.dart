class BookmarksRecitation {
  String? _recitationName;
  String? _recitationRef;
  int? _recitationIndex;
  String? _contentUrl;

  String? get recitationName => _recitationName;
  String? get recitationRef => _recitationRef;
  int? get recitationIndex => _recitationIndex;
  String? get contentUrl => _contentUrl;

  BookmarksRecitation({
    required recitationName,
    required recitationTitle,
    required recitationIndex,
    required contentUrl,
  }) {
    _recitationName = recitationName;
    _recitationRef = recitationTitle;
    _recitationIndex = recitationIndex;
    _contentUrl = contentUrl;
  }

  BookmarksRecitation.fromJson(Map<String, dynamic> json) {
    _recitationName = json['recitationName'];
    _recitationRef = json['recitationRef'];
    _recitationIndex = json['recitationIndex'];
    _contentUrl = json['contenturl'];
  }

  Map toJson() {
    return {
      "recitationName": _recitationName,
      "recitationRef": _recitationRef,
      "recitationIndex": _recitationIndex,
      "contenturl": _contentUrl,
    };
  }
}

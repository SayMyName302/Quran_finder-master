class BookmarksRecitation {
  String? _recitationName;
  String? _recitationRef;
  int? _recitationIndex;
  String? _contentUrl;
  int? _catID;
  String? _imageUrl;

  String? get recitationName => _recitationName;
  String? get recitationRef => _recitationRef;
  int? get recitationIndex => _recitationIndex;
  String? get contentUrl => _contentUrl;
  int? get catID => _catID;
  String? get imageUrl => _imageUrl;

  BookmarksRecitation(
      {required recitationName,
      required recitationRef,
      required recitationIndex,
      required contentUrl,
      required catID,
      required imageUrl}) {
    _recitationName = recitationName;
    _recitationRef = recitationRef;
    _recitationIndex = recitationIndex;
    _contentUrl = contentUrl;
    _catID = catID;
    _imageUrl = imageUrl;
  }

  BookmarksRecitation.fromJson(Map<String, dynamic> json) {
    _recitationName = json['recitationName'];
    _recitationRef = json['recitationRef'];
    _recitationIndex = json['recitationIndex'];
    _contentUrl = json['contenturl'];
    _catID = json['categoryId'];
    _imageUrl = json['imageUrl'];
  }

  Map toJson() {
    return {
      "recitationName": _recitationName,
      "recitationRef": _recitationRef,
      "recitationIndex": _recitationIndex,
      "contenturl": _contentUrl,
      "categoryId": _catID,
      "imageUrl": _imageUrl,
    };
  }

  @override
  String toString() {
    return 'BookmarkRecitation $_imageUrl,';
  }
}

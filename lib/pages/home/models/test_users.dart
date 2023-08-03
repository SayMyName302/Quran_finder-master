class TestUsers {
  String? _name;
  String? _userName;
  String? _status;

  String? get name => _name;
  String? get userName => _userName;
  String? get status => _status;

  TestUsers({
    required name,
    required userName,
    required status,
  }) {
    _name = name;
    _userName = userName;
    _status = status;
  }

  TestUsers.fromJson(Map<String, dynamic> json) {
    _name = json['name'];
    _userName = json['username'];
    _status = json['status'];
  }

  // @override
  // String toString() {
  //   return 'Dua: duaId=$id,duaTitle=$duaTitle, duaText=$duaText, translations=$translations, duaRef=$duaRef, totalAyaat=$ayahCount, isFAV ? $isFav, status > $status';
  // }
}

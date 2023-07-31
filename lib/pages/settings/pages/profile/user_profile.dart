import 'package:nour_al_quran/pages/recitation_category/models/recitation_all_category_model.dart';
import '../../../../shared/entities/bookmarks.dart';
import '../../../../shared/entities/reciters.dart';
import '../../../duas/models/dua.dart';
import '../../../quran/pages/ruqyah/models/ruqyah.dart';
import '../../../recitation_category/pages/bookmarks_recitation.dart';

class UserProfile {
  String? _fullName;
  String? _email;
  String? _password;
  String? _image;
  String? _uid;
  List<String>? _purposeOfQuran;
  String? _preferredLanguage;
  List<Devices> _loginDevices = [];
  String? _loginType;
  List<Reciters> _favRecitersList = [];
  List<AyahBookmarks> _quranBookmarksList = [];
  List<Dua> _duaBookmarksList = [];
  List<Ruqyah> _ruqyahBookmarksList = [];
  List<BookmarksRecitation> _recitationBookmarkList = [];

  String? get fullName => _fullName;
  String? get email => _email;
  String? get password => _password;
  String? get image => _image;
  String? get uid => _uid;
  List<String>? get purposeOfQuran => _purposeOfQuran;
  String? get preferredLanguage => _preferredLanguage;
  String? get loginType => _loginType;

  /// for saving user information in firebase
  List<Devices> get loginDevices => _loginDevices;
  List<Reciters> get favRecitersList => _favRecitersList;
  List<AyahBookmarks> get quranBookmarksList => _quranBookmarksList;
  List<Dua> get duaBookmarksList => _duaBookmarksList;
  List<Ruqyah> get ruqyahBookmarksList => _ruqyahBookmarksList;
  List<BookmarksRecitation> get recitationBookmarkList =>
      _recitationBookmarkList;

  set setPreferredLanguage(String value) => _preferredLanguage = value;
  set setFullName(String value) => _fullName = value;
  set setEmail(String value) => _email = value;
  set setPassword(String value) => _password = value;

  set setImage(String value) => _image = value;

  set setUid(String? value) => _uid = value;

  set setPurposeOfQuran(List<String> value) => _purposeOfQuran = value;

  set setLoginDevices(List<Devices> value) => _loginDevices = value;

  set setLoginType(String value) => _loginType = value;

  set setFavRecitersList(List<Reciters> value) => _favRecitersList = value;

  set setQuranBookmarksList(List<AyahBookmarks> value) =>
      _quranBookmarksList = value;

  set setDuaBookmarksList(List<Dua> value) => _duaBookmarksList = value;

  set setRuqyahBookmarksList(List<Ruqyah> value) =>
      _ruqyahBookmarksList = value;

  set setRecitationBookmarkList(List<BookmarksRecitation> value) =>
      _recitationBookmarkList = value;

  UserProfile(
      {required email,
      required password,
      required fullName,
      required image,
      required uid,
      required purposeOfQuran,
      required preferredLanguage,
      required loginDevices,
      required loginType,
      required favRecitersList,
      required quranBookmarksList,
      required duaBookmarksList,
      required ruqyahBookmarksList,
      required recitationBookmarkList}) {
    _email = email;
    _password = password;
    _fullName = fullName;
    _image = image;
    _uid = uid;
    _purposeOfQuran = purposeOfQuran;
    _preferredLanguage = preferredLanguage;
    _loginDevices = loginDevices;
    _loginType = loginType;
    _favRecitersList = favRecitersList;
    _quranBookmarksList = quranBookmarksList;
    _duaBookmarksList = duaBookmarksList;
    _ruqyahBookmarksList = ruqyahBookmarksList;
    _recitationBookmarkList = recitationBookmarkList;
  }

  UserProfile.fromJson(Map<String, dynamic> json) {
    _email = json['email'];
    _password = json['password'];
    _fullName = json['fullName'];
    _image = json['image'];
    _uid = json['uid'];
    _purposeOfQuran = List<String>.from(json['purposeOfQuran']);
    _preferredLanguage = json['preferredLanguage'];
    if (json['loginDevices'] != null) {
      _loginDevices = [];
      for (var map in json['loginDevices']) {
        _loginDevices.add(Devices.fromJson(map));
      }
    }
    _loginType = json['loginType'];

    /// for fav reciters
    if (json['favRecitersList'] != null) {
      if (_favRecitersList.isEmpty) {
        _favRecitersList = [];
        for (var reciter in json['favRecitersList']) {
          _favRecitersList.add(Reciters.fromJson(reciter));
        }
      } else {
        for (var reciter in json['favRecitersList']) {
          if (!_favRecitersList.any((element) =>
              element.reciterName == Reciters.fromJson(reciter).reciterName)) {
            _favRecitersList.add(Reciters.fromJson(reciter));
          }
        }
      }
    }

    /// for quran bookmarks
    if (json['quranBookmarksList'] != null) {
      if (_quranBookmarksList.isEmpty) {
        _quranBookmarksList = [];
        for (var bookmark in json['quranBookmarksList']) {
          _quranBookmarksList.add(AyahBookmarks.fromJson(bookmark));
        }
      } else {
        for (var bookmarks in json['quranBookmarksList']) {
          AyahBookmarks bookmark = AyahBookmarks.fromJson(bookmarks);
          if (!_quranBookmarksList.any((element) =>
              element.surahId == bookmark.surahId &&
              element.verseId == bookmark.verseId)) {
            _quranBookmarksList.add(bookmark);
          }
        }
      }
    }

    /// for dua list
    if (json['duaBookmarksList'] != null) {
      if (_duaBookmarksList.isEmpty) {
        _duaBookmarksList = [];
        for (var dua in json['duaBookmarksList']) {
          _duaBookmarksList.add(Dua.fromJson(dua));
        }
      } else {
        for (var dua in json['duaBookmarksList']) {
          Dua duaBookmark = Dua.fromJson(dua);
          if (!_duaBookmarksList
              .any((element) => element.duaText == duaBookmark.duaText)) {
            _duaBookmarksList.add(duaBookmark);
          }
        }
      }
    }

    /// for ruku list
    if (json['ruqyahBookmarksList'] != null) {
      if (_ruqyahBookmarksList.isEmpty) {
        _ruqyahBookmarksList = [];
        for (var ruqyah in json['ruqyahBookmarksList']) {
          _ruqyahBookmarksList.add(Ruqyah.fromJson(ruqyah));
        }
      } else {
        for (var ruqyah in json['ruqyahBookmarksList']) {
          Ruqyah ruqyahBookmark = Ruqyah.fromJson(ruqyah);
          if (!_ruqyahBookmarksList
              .any((element) => element.duaText == ruqyahBookmark.duaText)) {
            _ruqyahBookmarksList.add(ruqyahBookmark);
          }
        }
      }
    }

    /// for recitation category
    if (json['recitationBookmarkList'] != null) {
      if (_recitationBookmarkList.isEmpty) {
        _recitationBookmarkList = [];
        for (var recitation in json['recitationBookmarkList']) {
          _recitationBookmarkList.add(BookmarksRecitation.fromJson(recitation));
        }
      } else {
        for (var recitation in json['recitationBookmarkList']) {
          BookmarksRecitation recitationBookmark =
              BookmarksRecitation.fromJson(recitation);
          if (!_recitationBookmarkList.any((element) =>
              element.contentUrl == recitationBookmark.contentUrl)) {
            _recitationBookmarkList.add(recitationBookmark);
          }
        }
      }
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'email': _email,
      'password': _password,
      'fullName': _fullName,
      'image': _image,
      'uid': _uid,
      'purposeOfQuran': _purposeOfQuran!.map((e) => e.toString()).toList(),
      'preferredLanguage': _preferredLanguage,
      'loginDevices': _loginDevices.map((e) => e.toJson()).toList(),
      "loginType": _loginType,
      "favRecitersList": _favRecitersList.map((e) => e.toJson()).toList(),
      "quranBookmarksList": _quranBookmarksList.map((e) => e.toJson()).toList(),
      "duaBookmarksList": _duaBookmarksList.map((e) => e.toJson()).toList(),
      "ruqyahBookmarksList":
          _ruqyahBookmarksList.map((e) => e.toJson()).toList(),
      "recitationBookmarkList":
          _recitationBookmarkList.map((e) => e.toJson()).toList()
    };
  }
}

class Devices {
  String? _name;
  String? _datetime;

  String? get name => _name;
  String? get datetime => _datetime;

  Devices({name, datetime}) {
    _name = name;
    _datetime = datetime;
  }

  Devices.fromJson(Map<String, dynamic> json) {
    _name = json['name'];
    _datetime = json['datetime'].toString();
  }

  Map<String, dynamic> toJson() {
    return {"name": _name, "datetime": _datetime};
  }
}

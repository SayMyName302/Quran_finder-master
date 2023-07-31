import 'package:hive/hive.dart';
import 'package:nour_al_quran/shared/utills/app_constants.dart';

class Ruqyah {
  int? _duaId;
  int? _duaCategoryId;
  int? _duaNo;
  int? _ayahCount;
  String? _duaTitle;
  String? _duaText;
  String? _duaRef;
  String? _translations;
  String? _contentUrl;
  int? _isFav;


  int? get duaId => _duaId;
  int? get duaCategoryId => _duaCategoryId;
  int? get duaNo => _duaNo;
  int? get ayahCount => _ayahCount;
  String? get duaTitle => _duaTitle;
  String? get duaText => _duaText;
  String? get translations => _translations;
  String? get duaRef => _duaRef;
  String? get duaUrl => _contentUrl;
  int? get isFav => _isFav;

  set setIsBookmark(int value) => _isFav = value;

  Ruqyah({
    required id,
    required duaCategory,
    required duaText,
    required duaRef,
    required translations,
    required duaTitle,
    required duaUrl,
    required ayahCount,
    required isFav,
    required duaNo,
  }) {
    _duaId = id;
    _duaCategoryId = duaCategory;
    _duaText = duaText;
    _duaRef = duaRef;
    _translations = translations;
    _duaTitle = duaTitle;
    _contentUrl = duaUrl;
    _ayahCount = ayahCount;
    _isFav = isFav;
    _duaNo = duaNo;
  }

  Ruqyah.fromJson(Map<String, dynamic> json) {
    _duaId = json['ruqyah_id'];
    _duaCategoryId = json['category_id'];
    _duaNo = json['dua_no'];
    _ayahCount = json['ayah_count'];
    _duaTitle = json['ruqyah_title'];
    _duaText = json['ruqyah_text'];
    _duaRef = json['ref'];
    _translations = json[
        Hive.box(appBoxKey).get(duaTranslationKey) ?? 'translation_english'];
    _contentUrl = json['content_url'];
    _isFav = json['is_fav'];

  }

  Map<String, dynamic> toJson() {
    return {
      'ruqyah_id': _duaId,
      'category_id': _duaCategoryId,
      'dua_no': _duaNo,
      'ruqyah_text': _duaText,
      'ruqyah_title': _duaTitle,
      'ref': _duaRef,
      'translation_english': _translations,
      'content_url': _contentUrl,
      'ayah_count': _ayahCount,
      'is_fav': _isFav,

    };
  }

  @override
  String toString() {
    return 'Dua: duaId=$duaId,duaTitle=$duaTitle, duaText=$duaText, translations=$translations, duaRef=$duaRef';
  }
}

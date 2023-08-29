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
  String? _translationArabic;
  String? _translationIndo;
  String? _translationUrdu;
  String? _translationHindi;
  String? _translationBengali;
  String? _translationFrench;
  String? _translationChinese;
  String? _translationSomalia;
  String? _translationGerman;
  String? _translationSpanish;
  String? _contentUrl;
  int? _isFav;

  int? get duaId => _duaId;
  int? get duaCategoryId => _duaCategoryId;
  int? get duaNo => _duaNo;
  int? get ayahCount => _ayahCount;
  String? get duaTitle => _duaTitle;
  String? get duaText => _duaText;
  String? get translations => _translations; //English
  String? get translationArabic => _translationArabic;
  String? get translationIndo => _translationIndo;
  String? get translationUrdu => _translationUrdu;
  String? get translationHindi => _translationHindi;
  String? get translationBengali => _translationBengali;
  String? get translationFrench => _translationFrench;
  String? get translationChinese => _translationChinese;
  String? get translationSomalia => _translationSomalia;
  String? get translationGerman => _translationGerman;
  String? get translationSpanish => _translationSpanish;
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
    required translationArabic,
    required translationIndo,
    required translationUrdu,
    required translationHindi,
    required translationBengali,
    required translationFrench,
    required translationChinese,
    required translationSomalia,
    required translationGerman,
    required translationSpanish,
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
    _translationArabic = translationArabic;
    _translationIndo = translationIndo;
    _translationUrdu = translationUrdu;
    _translationHindi = translationHindi;
    _translationBengali = translationBengali;
    _translationFrench = translationFrench;
    _translationChinese = translationChinese;
    _translationSomalia = translationSomalia;
    _translationGerman = translationGerman;
    _translationSpanish = translationSpanish;
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
    _translationArabic = json[
        Hive.box(appBoxKey).get(duaTranslationKey) ?? 'translation_arabic'];
    _translationIndo = json[
        Hive.box(appBoxKey).get(duaTranslationKey) ?? 'translation_indonesian'];
    _translationUrdu =
        json[Hive.box(appBoxKey).get(duaTranslationKey) ?? 'translation_urdu'];
    _translationHindi =
        json[Hive.box(appBoxKey).get(duaTranslationKey) ?? 'translation_hindi'];
    _translationBengali = json[
        Hive.box(appBoxKey).get(duaTranslationKey) ?? 'translation_bengali'];
    _translationFrench = json[
        Hive.box(appBoxKey).get(duaTranslationKey) ?? 'translation_french'];
    _translationChinese = json[
        Hive.box(appBoxKey).get(duaTranslationKey) ?? 'translation_chinese'];
    _translationSomalia = json[
        Hive.box(appBoxKey).get(duaTranslationKey) ?? 'translation_somalia'];
    _translationGerman = json[
        Hive.box(appBoxKey).get(duaTranslationKey) ?? 'translation_german'];
    _translationSpanish = json[
        Hive.box(appBoxKey).get(duaTranslationKey) ?? 'translation_spanish'];
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
      'translationarabic': _translationArabic,
      'translationindo': _translationIndo,
      'translationurdu': _translationUrdu,
      'translationhindi': _translationHindi,
      'translationbengali': _translationBengali,
      'translationfrench': _translationFrench,
      'translationchinese': _translationChinese,
      'translationsomalia': _translationSomalia,
      'translationgerman': _translationGerman,
      'translationspanish': _translationSpanish,
      'content_url': _contentUrl,
      'ayah_count': _ayahCount,
      'is_fav': _isFav,
    };
  }

  // @override
  // String toString() {
  //   return 'Dua: duaId=$duaId,duaTitle=$duaTitle, duaText=$duaText, translations=$translations, duaRef=$duaRef';
  // }
}

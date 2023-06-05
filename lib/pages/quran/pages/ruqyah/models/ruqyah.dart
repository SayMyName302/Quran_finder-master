import 'package:hive/hive.dart';
import 'package:nour_al_quran/shared/utills/app_constants.dart';

class Ruqyah {
  int? _id;
  String? _duaText;
  String? _duatitle;
  String? _duaRef;
  String? _translations;
  String? _contentUrl;
  int? _ayahCount;

  int? get id => _id;
  String? get translations => _translations;
  String? get duaRef => _duaRef;
  String? get duaText => _duaText;
  String? get duaTitle => _duatitle;
  String? get duaUrl => _contentUrl;
  int? get ayahCount => _ayahCount;

  Ruqyah({
    required id,
    required duaText,
    required duaRef,
    required translations,
    required duaTitle,
    required duaUrl,
    required ayahCount,
  }) {
    _id = id;
    _duaText = duaText;
    _duaRef = duaRef;
    _translations = translations;
    _duatitle = duaTitle;
    _contentUrl = duaUrl;
    _ayahCount = ayahCount;
  }

  Ruqyah.fromJson(Map<String, dynamic> json) {
    _id = json['ruqyah_id'];
    _duaText = json['ruqyah_text'];
    _duatitle = json['ruqyah_title'];
    _duaRef = json['ref'];
    _translations = json[
        Hive.box(appBoxKey).get(duaTranslationKey) ?? 'translation_english'];
    _contentUrl = json['content_url'];
    _ayahCount = json['ayah_count'];
  }

  @override
  String toString() {
    return 'Dua: duaId=$id,duaTitle=$duaTitle, duaText=$duaText, translations=$translations, duaRef=$duaRef';
  }
}

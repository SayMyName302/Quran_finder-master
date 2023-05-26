import 'package:hive/hive.dart';
import 'package:nour_al_quran/shared/utills/app_constants.dart';

class Dua {
  int? _id;
  String? _duaText;
  String? _duatitle;
  String? _duaRef;
  String? _translations;

  int? get id => _id;
  String? get translations => _translations;
  String? get duaRef => _duaRef;
  String? get duaText => _duaText;
  String? get duaTitle => _duatitle;

  Dua({
    required id,
    required duaText,
    required duaRef,
    required translations,
    required duaTitle,
  }) {
    _id = id;
    _duaText = duaText;
    _duaRef = duaRef;
    _translations = translations;
    _duatitle = duaTitle;
  }

  Dua.fromJson(Map<String, dynamic> json) {
    _id = json['dua_id'];
    _duaText = json['dua_text'];
    _duatitle = json['dua_title'];
    _duaRef = json['dua_ref'];
    _translations = json[
        Hive.box(appBoxKey).get(duaTranslationKey) ?? 'translation_english'];
  }
}

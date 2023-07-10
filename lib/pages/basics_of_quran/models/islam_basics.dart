import 'package:hive/hive.dart';

import '../../../shared/utills/app_constants.dart';

class IslamBasics {
  String? _title;
  String? _image;
  String? _text;
  String? _audioUrl;
  String? _status;

  String? get title => _title;
  String? get image => _image;
  String? get text => _text;
  String? get audioUrl => _audioUrl;
  String? get status => _status;

  IslamBasics({
    required title,
    required image,
    required text,
    required audioUrl,
    required status,
  }) {
    _title = title;
    _image = image;
    _text = text;
    _audioUrl = audioUrl;
    _status = status;
  }

  IslamBasics.fromJson(Map<String, dynamic> json) {
    _title = json['basics_title'];
    _image = json['app_image_url'];
    _text = json[Hive.box(appBoxKey).get(basicsTranslationKey) ?? 'text'];
    _audioUrl = json['content_url'];
    _status = json['status'];
  }
}

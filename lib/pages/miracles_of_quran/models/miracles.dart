import 'package:hive/hive.dart';

import '../../../shared/utills/app_constants.dart';

class Miracles {
  String? _title;
  String? _image;
  String? _text;
  String? _videoUrl;
  String? _status;

  String? get title => _title;
  String? get image => _image;
  String? get text => _text;
  String? get videoUrl => _videoUrl;
  String? get status => _status;

  Miracles({
    required title,
    required image,
    required text,
    required video,
    required status,
  }) {
    _title = title;
    _image = image;
    _text = text;
    _videoUrl = video;
    _status = status;
  }

  Miracles.fromJson(Map<String, dynamic> json) {
    _title = json['miracle_title'];
    _image = json['app_image_url'];
    _text = json[Hive.box(appBoxKey).get(miraclesTranslationKey) ?? 'text'];
    _videoUrl = json['content_url'];
    _status = json['status'];
  }
}

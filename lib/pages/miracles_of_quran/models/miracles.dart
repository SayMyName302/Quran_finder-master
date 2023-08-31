import 'package:hive/hive.dart';

import '../../../shared/utills/app_constants.dart';

class Miracles {
  String? _title;
  String? _image;
  String? _text;
  String? _videoUrl;
  String? _status;
  int? _miracleId;

  String? get title => _title;
  String? get image => _image;
  String? get text => _text;
  String? get videoUrl => _videoUrl;
  String? get status => _status;
  int? get miracleId => _miracleId;

  Miracles(
      {required title,
      required image,
      required text,
      required video,
      required status,
      required progress,
      required miracleId}) {
    _title = title;
    _image = image;
    _text = text;
    _videoUrl = video;
    _status = status;
    _miracleId = miracleId;
  }

  Miracles.fromJson(Map<String, dynamic> json) {
    _title = json['miracle_title'];
    _image = json['app_image_url'];
    _text = json[Hive.box(appBoxKey).get(miraclesTranslationKey) ?? 'text'];
    _videoUrl = json['content_url'];
    _status = json['status'];
    _miracleId = json['miracle_id'];
  }

  // @override
  // String toString() {
  //   return 'title $title text $text';
  // }
}

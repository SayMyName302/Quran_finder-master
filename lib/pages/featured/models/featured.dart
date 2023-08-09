import 'package:hive_flutter/adapters.dart';
import 'package:nour_al_quran/shared/utills/app_constants.dart';

class FeaturedModel {
  int? _storyId;
  String? _storyTitle;
  String? _image;
  String? _audioUrl;
  String? _text;
  String? _videoUrl;
  String? _contentType;
  String? _status;
  int? _viewOrderBy;
  String? _day;
  String? _islamicDate;
  String? _monthDisplay;
  int? _hijriYear;
  String? _georgeDate;
  String? _georgeMonth;
  int? _georgeYear;

  int? get storyId => _storyId;
  String? get storyTitle => _storyTitle;
  String? get image => _image;
  String? get videoUrl => _videoUrl;
  String? get audioUrl => _audioUrl;
  String? get text => _text;
  String? get contentType => _contentType;
  String? get status => _status;
  int? get viewOrderBy => _viewOrderBy;
  String? get day => _day;
  String? _title;
  String? get title => _title;

  String? get islamicDate => _islamicDate;
  String? get monthDisplay => _monthDisplay;
  int? get hijriYear => _hijriYear;
  String? get georgeDate => _georgeDate;
  String? get georgeMonth => _georgeMonth;
  int? get georgeYear => _georgeYear;

  FeaturedModel(
      {required title,
      required storyId,
      required storyTitle,
      required image,
      required audio,
      required text,
      required video,
      required contentType,
      required status,
      required viewOrderBy,
      required day,
      required monthDisplay,
      required hijriYear,
      required islamicDate,
      required georgeDate,
      required georgeMonth,
      required georgeYear}) {
    _title = title;
    _storyId = storyId;
    _storyTitle = storyTitle;
    _image = image;
    _audioUrl = audio;
    _text = text;
    _videoUrl = video;
    _contentType = contentType;
    _status = status;
    _viewOrderBy = viewOrderBy;
    _day = day;
    _monthDisplay = monthDisplay;
    _hijriYear = hijriYear;
    _islamicDate = islamicDate;
    _georgeDate = georgeDate;
    _georgeMonth = georgeMonth;
    _georgeYear = georgeYear;
  }

  FeaturedModel.fromJson(Map<String, dynamic> json) {
    _title = json['miracle_title'];
    _storyId = json['story_id'];
    _storyTitle = json['story_title'];
    _image = json['app_image_url'];
    _audioUrl = json['content_url'];
    _text = json[Hive.box(appBoxKey).get(miraclesTranslationKey) ?? 'text'];
    _text = json['text'];
    _videoUrl = json['content_url'];
    _contentType = json['content_type'];
    _status = json['status'];
    _viewOrderBy = json['view_order_by'];
    _day = json['day'];
    _islamicDate = json['islamic_date'];
    _monthDisplay = json['month_display'];
    _hijriYear = json['hijri_year'];
    _georgeDate = json['georgian_date'];
    _georgeMonth = json['georgian_month'];
    _georgeYear = json['georgian_year'];
  }

  @override
  String toString() {
    return "$_title";
  }
}

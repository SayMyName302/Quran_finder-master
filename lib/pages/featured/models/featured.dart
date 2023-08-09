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
  String? _status; // New field: status
  int? _viewOrderBy;
  String? _day; // New field: status
  String? _monthDisplay;
  int? _hijriYear;
  String? _islamicDate;

  int? get storyId => _storyId;
  String? get storyTitle => _storyTitle;
  String? get image => _image;
  String? get videoUrl => _videoUrl;
  String? get audioUrl => _audioUrl;
  String? get text => _text;
  String? get contentType => _contentType;
  String? get status => _status; // New getter for status
  int? get viewOrderBy => _viewOrderBy;
  String? get day => _day;
  String? _title;
  String? get title => _title;

  String? get monthDisplay => _monthDisplay;
  int? get hijriYear => _hijriYear;
  String? get islamicDate => _islamicDate;

  FeaturedModel({
    required title,
    required storyId,
    required storyTitle,
    required image,
    required audio,
    required text,
    required video,
    required contentType,
    required status, // New parameter: status
    required viewOrderBy,
    required day,
    required monthDisplay,
    required hijriYear,
    required islamicDate,
  }) {
    _title = title;
    _storyId = storyId;
    _storyTitle = storyTitle;
    _image = image;
    _audioUrl = audio;
    _text = text;
    _videoUrl = video;
    _contentType = contentType;
    _status = status; // Assign the value to the status field
    _viewOrderBy = viewOrderBy;
    _day = day;
    _monthDisplay = monthDisplay;
    _hijriYear = hijriYear;
    _islamicDate = islamicDate;
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
    _monthDisplay = json['month_display'];
    _hijriYear = json['hijri_year'];
    _islamicDate = json['islamic_date'];
  }

  @override
  String toString() {
    return "$_title";
  }
}

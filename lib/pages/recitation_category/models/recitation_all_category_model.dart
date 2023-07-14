import 'package:hive_flutter/adapters.dart';
import 'package:nour_al_quran/shared/utills/app_constants.dart';

class RecitationAllCategoryModel {
  int? _surahId;
  int ? _categoryId;
  int? _surahNo;
  int? _ayahCount;
  String? _title;
  String? _reference;
  String? _contentType;
  String? _contentUrl;
  String? _status;
  int? _orderBy;



  int? get surahId => _surahId;
  int ? get categoryId => _categoryId;
  int? get surahNo => _surahNo;
  int? get ayahCount => _ayahCount;
  String? get title => _title;
  String? get reference => _reference;
  String? get contentType => _contentType;
  String? get contentUrl => _contentUrl;
  String? get status => _status;
  int? get orderBy => _orderBy;


  // Getter for content_type

  RecitationAllCategoryModel({
    required surahId,
    required categoryId,
    required surahNo,
    required ayahCount,
    required title,
    required reference,
    required contentType,
    required contentUrl,
    required status,
    required orderBy


  }) {
    _surahId = surahId;
    _categoryId = categoryId;
    _surahNo = surahNo;
    _ayahCount = ayahCount;
    _title = title;
    _reference = reference;
    _contentType = contentType;
    _contentUrl = contentUrl;
    _status = status;
    _orderBy = orderBy;
  }

  RecitationAllCategoryModel.fromJson(Map<String, dynamic> json) {
    _surahId = json['surah_id'];

    _categoryId = json['category_id'];

    _surahNo = json['surah_no'];

    _ayahCount = json['ayah_count'];

    _title = json['title'];

    _reference = json['reference'];

    _contentType = json['content_type'];

    _contentUrl = json['content_url'];

    _status = json['status'];

    _orderBy = json['order_by'];


    // Assign the value to the content_type field
  }
}

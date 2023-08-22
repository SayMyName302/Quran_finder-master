import 'dart:convert';

class PopularRecitationModel {
  String? surahId;
  int? surahNo;
  String? title;
  int? reciterId;
  String? text; // description
  String? contentType;
  String? contentUrl;
  String? image;
  String? audioImageUrl; // Added field: audio_image_url
  String? status;
  int? orderBy;
  String? premiumFeatures;
  String? region;
  String? day;
  String? timePeriod;
  int? isFavorite;
  String? mood;

  PopularRecitationModel(
      {this.surahId,
      this.surahNo,
      this.title,
      this.reciterId,
      this.text,
      this.contentType,
      this.contentUrl,
      this.image,
      this.audioImageUrl,
      this.status,
      this.orderBy,
      this.premiumFeatures,
      this.region,
      this.day,
      this.timePeriod,
      this.isFavorite,
      this.mood});

  PopularRecitationModel.fromJson(Map<String, dynamic> json) {
    surahId = json['surah_id'];
    surahNo = json['surah_no'];
    title = json['title'];
    reciterId = json['reciter_id'];
    text = json['description'];
    contentType = json['content_type'];
    contentUrl = json['content_url'];
    image = json['image_url'];
    audioImageUrl = json['audio_image_url']; // Added field: audio_image_url
    status = json['status'];
    orderBy = json['order_by'];
    premiumFeatures = json['premium_features'];
    region = json['region'];
    day = json['day'];
    timePeriod = json['time_period'];
    isFavorite = json['is_favorite'];
    mood = json['mood'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['surah_id'] = surahId;
    data['surah_no'] = surahNo;
    data['title'] = title;
    data['reciter_id'] = reciterId;
    data['description'] = text;
    data['content_type'] = contentType;
    data['content_url'] = contentUrl;
    data['image_url'] = image;
    data['audio_image_url'] = audioImageUrl; // Added field: audio_image_url
    data['status'] = status;
    data['order_by'] = orderBy;
    data['premium_features'] = premiumFeatures;
    data['region'] = region;
    data['day'] = day;
    data['time_period'] = timePeriod;
    data['is_favorite'] = isFavorite;
    data['mood'] = mood;
    return data;
  }

  @override
  String toString() {
    return 'title $title, surahID $surahId';
  }
}

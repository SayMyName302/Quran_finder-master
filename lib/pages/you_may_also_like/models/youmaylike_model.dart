class YouMayAlsoLikeModel {
  int? surahId;

  String? title;
  int? reciterId;
  String? reciterName;
  String? text;
  String? contentType;
  String? contentUrl;
  String? image;
  String? audioImageUrl;
  String? status;
  int? orderBy;
  String? premiumFeatures;
  String? region;
  String? day;
  String? timePeriod;
  int? isFavorite;
  String? mood;
  int? recitationId; // Added field: recitation_id

  YouMayAlsoLikeModel({
    this.surahId,
    this.title,
    this.reciterId,
    this.reciterName,
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
    this.mood,
    this.recitationId,
  });

  YouMayAlsoLikeModel.fromJson(Map<String, dynamic> json) {
    surahId = json['surah_id'];

    title = json['title'];
    reciterId = json['reciter_id'];
    reciterName = json['reciter_name'];
    text = json['text'];
    contentType = json['content_type'];
    contentUrl = json['content_url'];
    image = json['image_url'];
    audioImageUrl = json['audio_image_url'];
    status = json['status'];
    orderBy = json['view_order_by'];
    premiumFeatures = json['premium_features'];
    region = json['region'];
    day = json['day'];
    timePeriod = json['time_period'];
    isFavorite = json['is_favorite'];
    mood = json['mood'];
    recitationId = json['recitation_id']; // Extract recitation_id from JSON
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['surah_id'] = surahId;

    data['title'] = title;
    data['reciter_id'] = reciterId;
    data['reciter_name'] = reciterName;
    data['text'] = text;
    data['content_type'] = contentType;
    data['content_url'] = contentUrl;
    data['image_url'] = image;
    data['audio_image_url'] = audioImageUrl;
    data['status'] = status;
    data['view_order_by'] = orderBy;
    data['premium_features'] = premiumFeatures;
    data['region'] = region;
    data['day'] = day;
    data['time_period'] = timePeriod;
    data['is_favorite'] = isFavorite;
    data['mood'] = mood;
    data['recitation_id'] = recitationId; // Include recitation_id in JSON
    return data;
  }

  @override
  String toString() {
    return 'title $title, surahID $surahId';
  }
}

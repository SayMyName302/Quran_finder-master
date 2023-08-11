class PopularRecitationModel {
  String? surahId;
  int? surahNo;
  String? title;
  int? reciterId;
  String? text; // description
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
    audioImageUrl = json['audio_image_url'];
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
    data['audio_image_url'] = audioImageUrl;
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
  String toString(){
    return 'title $title, surahID $surahId';
  }
}

// class PopularModelClass {
//   String? _surahId;
//   int? _surahNo;
//   String? _title;
//   String? _image;
//   String? _audioUrl;
//   String? _text;
//   String? _videoUrl;
//   String? _contentType;
//   String? _status; // New field: status
//   String? _reference; // New field: reference
//
//   String? get surahId => _surahId;
//   int? get surahNo => _surahNo;
//   String? get title => _title;
//   String? get image => _image;
//   String? get videoUrl => _videoUrl;
//   String? get audioUrl => _audioUrl;
//   String? get text => _text;
//   String? get contentType => _contentType;
//   String? get status => _status; // New getter for status
//   String? get reference => _reference; // New getter for reference
//   // New getter for reference
//
//   PopularModelClass({
//     required title,
//     required surahId,
//     required storyTitle,
//     required image,
//     required audio,
//     required surahNo,
//     required text,
//     required video,
//     required contentType,
//     required status, // New parameter: status
//     required reference, // New parameter: reference
//   }) {
//     _title = title;
//     _surahId = surahId;
//     _image = image;
//     _audioUrl = audio;
//     _surahNo = surahNo;
//     _text = text;
//     _videoUrl = video;
//     _contentType = contentType;
//     _status = status; // Assign the value to the status field
//     _reference = reference; // Assign the value to the reference field
//   }
//
//   PopularModelClass.fromJson(Map<String, dynamic> json) {
//     _title = json['title'];
//     _surahNo = json['surah_no'];
//     _surahId = json['surah_id'];
//     _image = json['image_url'];
//     _audioUrl = json['content_url'];
//     _text = json[Hive.box(appBoxKey).get(miraclesTranslationKey) ?? 'text'];
//     _text = json['text'];
//     _videoUrl = json['content_url'];
//     _contentType = json['content_type'];
//     _status = json['status']; // Assign the value to the status field
//     _reference = json['reference']; // Assign the value to the reference field
//   }
//
//   @override
//   String toString(){
//     return 'title $title, surahID $surahId';
//   }
//
// }

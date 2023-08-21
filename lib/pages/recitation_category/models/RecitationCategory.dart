class RecitationCategoryModel {
  int? _playlistId;
  String? _playlistName;
  String? _playPeriod;
  String? _playlistContentType;
  int? _viewOrderBy;
  String? _numberOfSurahs;
  String? _imageURl;
  String? _audioImageUrl;
  // int? _categoryId;
  // String? _categoryName;
  // String? _numberOfPrayers;

  int? get playlistId => _playlistId;
  String? get playlistName => _playlistName;
  String? get playPeriod => _playPeriod;
  String? get playlistContentType => _playlistContentType;
  int? get viewOrderBy => _viewOrderBy;
  String? get numberOfSurahs => _numberOfSurahs;
  String? get imageURl => _imageURl;
  String? get audioImageUrl => _audioImageUrl;

  // int? get categoryId => _categoryId;
  // String? get categoryName => _categoryName;

  // String? get numberOfPrayers => _numberOfPrayers;

  RecitationCategoryModel(
      {required int playlistId,
      required String playlistName,
      required String playPeriod,
      required String playlistContentType,
      required int viewOrderBy,
      required String numberOfSurahs,
      required String imageURl,
      required String audioImageUrl
      // required int categoryId,
      // required String categoryName,
      // required String numberOfPrayers,

      }) {
    _playlistId = playlistId;
    _playlistName = playlistName;
    _playPeriod = playPeriod;
    _playlistContentType = playlistContentType;
    _viewOrderBy = viewOrderBy;
    _imageURl = imageURl;
    _numberOfSurahs = numberOfSurahs;
    _audioImageUrl = audioImageUrl;

    // _categoryId = categoryId;
    // _categoryName = categoryName;
    // _numberOfPrayers = numberOfPrayers;
  }

  RecitationCategoryModel.fromJson(Map<String, dynamic> json) {
    _playlistId = json['playlist_id'];
    _playlistName = json['playlist_name'];
    _playPeriod = json['play_period'];
    _playlistContentType = json['playlist_content_type'];
    _numberOfSurahs = json['number_of_surahs'];
    _audioImageUrl = json['audio_image_url'];
    _imageURl = json['image_url'];
    _viewOrderBy = json['view_order_by'];
    // _categoryId = json['category_id'];
    // _categoryName = json['category_name'];
    // _numberOfPrayers = json['number_of_prayers'];
  }

  Map toJson() {
    return {
      // 'category_id': _categoryId,
      // 'category_name': _categoryName,
      'image_url': _imageURl,
      // 'number_of_prayers': _numberOfPrayers,
      'view_order_by': _viewOrderBy,
      'playlist_id': _playlistId,
      'playlist_name': _playlistName,
      'play_period': _playPeriod,
      'playlist_content_type': _playlistContentType,
      'number_of_sruahs': _numberOfSurahs,
      'audio_image_url': _audioImageUrl,
    };
  }

  factory RecitationCategoryModel.fromMap(Map<String, dynamic> map) {
    return RecitationCategoryModel(
      playlistId: map['playlist_id'],
      playlistName: map['playlist_name'],
      playPeriod: map['play_period'],
      playlistContentType: map['playlist_content_type'],
      numberOfSurahs: map['number_of_surahs'],
      audioImageUrl: map['audio_image_url'],
      imageURl: map['image_url'],
      viewOrderBy: map['view_order_by'],
    );
  }

  @override
  String toString() {
    return "$playlistName";
  }
}

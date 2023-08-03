class RecitationCategoryModel {
  int? _categoryId;
  String? _categoryName;
  String? _imageURl;
  String? _numberOfPrayers;
  int? _viewOrderBy;
  int? _playlistId;
  String? _playlistName;
  String? _playPeriod;
  String? _playlistContentType;
  String? _numberOfSruahs;
  String? _audioImageUrl;

  int? get categoryId => _categoryId;
  String? get categoryName => _categoryName;
  String? get imageURl => _imageURl;
  String? get numberOfPrayers => _numberOfPrayers;
  int? get viewOrderBy => _viewOrderBy;
  int? get playlistId => _playlistId;
  String? get playlistName => _playlistName;
  String? get playPeriod => _playPeriod;
  String? get playlistContentType => _playlistContentType;
  String? get numberOfSruahs => _numberOfSruahs;
  String? get audioImageUrl => _audioImageUrl;

  RecitationCategoryModel({
    required int categoryId,
    required String categoryName,
    required String imageURl,
    required String numberOfPrayers,
    required int viewOrderBy,
    required int playlistId,
    required String playlistName,
    required String playPeriod,
    required String playlistContentType,
    required String numberOfSruahs,
    required String audioImageUrl,
  }) {
    _categoryId = categoryId;
    _categoryName = categoryName;
    _imageURl = imageURl;
    _numberOfPrayers = numberOfPrayers;
    _viewOrderBy = viewOrderBy;
    _playlistId = playlistId;
    _playlistName = playlistName;
    _playPeriod = playPeriod;
    _playlistContentType = playlistContentType;
    _numberOfSruahs = numberOfSruahs;
    _audioImageUrl = audioImageUrl;
  }

  RecitationCategoryModel.fromJson(Map<String, dynamic> json) {
    _categoryId = json['category_id'];
    _categoryName = json['category_name'];
    _imageURl = json['image_url'];
    _numberOfPrayers = json['number_of_prayers'];
    _viewOrderBy = json['view_order_by'];
    _playlistId = int.parse(json['playlist_id']);
    _playlistName = json['playlist_name'];
    _playPeriod = json['play_period'];
    _playlistContentType = json['playlist_content_type'];
    _numberOfSruahs = json['number_of_surahs'];
    _audioImageUrl = json['audio_image_url'];
  }

  Map toJson() {
    return {
      'category_id': _categoryId,
      'category_name': _categoryName,
      'image_url': _imageURl,
      'number_of_prayers': _numberOfPrayers,
      'view_order_by': _viewOrderBy,
      'playlist_id': _playlistId,
      'playlist_name': _playlistName,
      'play_period': _playPeriod,
      'playlist_content_type': _playlistContentType,
      'number_of_sruahs': _numberOfSruahs,
      'audio_image_url': _audioImageUrl,
    };
  }
}

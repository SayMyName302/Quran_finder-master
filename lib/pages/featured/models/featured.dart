class FeaturedModel {
  int? _storyId;
  String? _storyTitle;
  String? _image;
  String? _audioUrl;
  String? _text;
  String? _videoUrl;
  int? get storyId => _storyId;
  String? get storyTitle => _storyTitle;
  String? get image => _image;
  String? get videoUrl => _videoUrl;
  String? get audioUrl => _audioUrl;
  String? get text => _text;

  FeaturedModel(
      {required storyId,
      required storyTitle,
      required image,
      required audio,
      required text,
      required video}) {
    _storyId = storyId;
    _storyTitle = storyTitle;
    _image = image;
    _audioUrl = audio;
    _text = text;
    _videoUrl = video;
  }

  FeaturedModel.fromJson(Map<String, dynamic> json) {
    _storyId = json['story_id'];
    _storyTitle = json['story_title'];
    _image = json['app_image_url'];
    _audioUrl = json['content_url'];
    _text = json['text'];
    _videoUrl = json['content_url'];
  }
}

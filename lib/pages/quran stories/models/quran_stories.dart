class QuranStories {
  int? _storyId;
  String? _storyTitle;
  String? _image;
  String? _audioUrl;
  String? _text;
  String? _status; // New property

  int? get storyId => _storyId;
  String? get storyTitle => _storyTitle;
  String? get image => _image;
  String? get audioUrl => _audioUrl;
  String? get text => _text;
  String? get status => _status; // Getter for status

  QuranStories({
    required storyId,
    required storyTitle,
    required image,
    required audio,
    required text,
    required status, // Added parameter
  }) {
    _storyId = storyId;
    _storyTitle = storyTitle;
    _image = image;
    _audioUrl = audio;
    _text = text;
    _status = status; // Assign value to the status property
  }

  QuranStories.fromJson(Map<String, dynamic> json) {
    _storyId = json['story_id'];
    _storyTitle = json['story_title'];
    _image = json['app_image_url'];
    _audioUrl = json['content_url'];
    _text = json['text'];
    _status = json['status']; // Parse and assign value to the status property
  }
}

class IslamBasics{
  String? _title;
  String? _image;
  String? _text;
  String? _audioUrl;

  String? get title => _title;

  String? get image => _image;

  String? get text => _text;


  String? get audioUrl => _audioUrl;

  IslamBasics({required title, required image, required text,required audioUrl}){
    _title = title;
    _image = image;
    _text = text;
    _audioUrl = audioUrl;
  }

  IslamBasics.fromJson(Map<String,dynamic> json){
    _title = json['basics_title'];
    _image = json['app_image_url'];
    _text = json['text'];
    _audioUrl = json['content_url'];
  }
}
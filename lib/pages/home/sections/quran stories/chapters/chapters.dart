class Chapters{
  int? _chapterId;
  String? _chaptersName;
  String? _text;

  int? get chapterId => _chapterId;
  String? get chaptersName => _chaptersName;
  String? get text => _text;

  Chapters({required chapterId, required chaptersName, required text}){
    _chapterId = chapterId;
    _chaptersName = chaptersName;
    _text = text;
  }

  Chapters.fromJson(Map<String,dynamic> json){
    _chapterId = json['Chapter_id'];
    _chaptersName = json['Chapter_name'];
    _text = json['text'];
  }
}
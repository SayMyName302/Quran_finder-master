class Names {
  int? id;
  String? arabictext;
  String? audioUrl;
  String? english;
  String? urduMeaning;
  String? englishMeaning;
  String? arabicMeaning;
  String? indonesianmeaning;
  String? hindiMeaning;
  String? bengalimeaning;
  String? frenchmeaning;
  String? chinesemeaning;
  String? somalimeaning;
  String? germanmeaning;
  String? spanishmeaning;

  Names(
      {this.id,
        this.arabictext,
        this.audioUrl,
        this.english,
        this.urduMeaning,
        this.englishMeaning,
        this.arabicMeaning,
        this.indonesianmeaning,
        this.hindiMeaning,
        this.bengalimeaning,
        this.frenchmeaning,
        this.chinesemeaning,
        this.somalimeaning,
        this.germanmeaning,
        this.spanishmeaning});

  Names.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    arabictext = json['arabictext'];
    audioUrl = json['audio_url'];
    english = json['english'];
    urduMeaning = json['urduMeaning'];
    englishMeaning = json['englishMeaning'];
    arabicMeaning = json['arabicMeaning'];
    indonesianmeaning = json['Indonesianmeaning'];
    hindiMeaning = json['hindiMeaning'];
    bengalimeaning = json['bengalimeaning'];
    frenchmeaning = json['frenchmeaning'];
    chinesemeaning = json['chinesemeaning'];
    somalimeaning = json['somalimeaning'];
    germanmeaning = json['germanmeaning'];
    spanishmeaning = json['spanishmeaning'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['arabictext'] = arabictext;
    data['audio_url'] = audioUrl;
    data['english'] = english;
    data['urduMeaning'] = urduMeaning;
    data['englishMeaning'] = englishMeaning;
    data['arabicMeaning'] = arabicMeaning;
    data['Indonesianmeaning'] = indonesianmeaning;
    data['hindiMeaning'] = hindiMeaning;
    data['bengalimeaning'] = bengalimeaning;
    data['frenchmeaning'] = frenchmeaning;
    data['chinesemeaning'] = chinesemeaning;
    data['somalimeaning'] = somalimeaning;
    data['germanmeaning'] = germanmeaning;
    data['spanishmeaning'] = spanishmeaning;
    return data;
  }
}

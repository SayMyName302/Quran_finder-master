class Languages {
  int id;
  String name;
  String flag;
  String languageCode;
  Languages(this.id, this.name, this.flag, this.languageCode);

  static List<Languages> languages = [
    Languages(1, "english", "en", "en"),
    Languages(2, "arabic", "ar", "ar"),
    Languages(3, "urdu", "pk", "ur"),
    Languages(4, "hindi", "in", "hi"),
    Languages(5, "bengali", "bn", "bn"),
    Languages(7, "chinese", "cz", "zh"),
    Languages(8, "french", "fr", "fr"),
    Languages(9, "indonesian", "id", "id"),
    Languages(10, "spanish", "es", "es"),
    Languages(11, "german", "gr", "de"),
  ];
}

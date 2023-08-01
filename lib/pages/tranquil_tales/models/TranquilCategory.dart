class TranquilTalesCategoryModel {
  int? _categoryId;
  String? _categoryName;
  String? _imageURl;
  String? _numberOfPrayers;
  int? _viewOrderBy;
  int? _surahId;
  String? _contentType;

  int? get categoryId => _categoryId;
  String? get categoryName => _categoryName;
  String? get imageURl => _imageURl;
  String? get numberOfPrayers => _numberOfPrayers;
  int? get viewOrderBy => _viewOrderBy;
  int? get surahId => _surahId;
  String? get contentType => _contentType;

  TranquilTalesCategoryModel({
    required int categoryId,
    required String categoryName,
    required String imageURl,
    required String numberOfPrayers,
    required int viewOrderBy,
    required int surahId,
    required String contentType,
  }) {
    _categoryId = categoryId;
    _categoryName = categoryName;
    _imageURl = imageURl;
    _numberOfPrayers = numberOfPrayers;
    _viewOrderBy = viewOrderBy;
    _surahId = surahId;
    _contentType = contentType;
  }

  TranquilTalesCategoryModel.fromJson(Map<String, dynamic> json) {
    _categoryId = json['category_id'];
    _categoryName = json['category_name'];
    _imageURl = json['image_url'];
    _numberOfPrayers = json['number_of_prayers'];
    _viewOrderBy = json['view_order_by'];
    _surahId = json['surah_id'];
    _contentType = json['content_type'];
  }

  Map toJson(){
    return {
      'category_id':_categoryId,
      'category_name':_categoryName,
      'image_url':_imageURl,
      'number_of_prayers':_numberOfPrayers,
      'view_order_by':_viewOrderBy,
      'surah_id':_surahId,
      'content_type':_contentType
    };
  }
}

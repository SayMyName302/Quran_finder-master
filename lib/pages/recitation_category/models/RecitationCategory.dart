class TranquilTalesCategoryModel {
  int? _categoryId;
  String? _categoryName;
  String? _imageURl;
  String? _numberOfPrayers;
  int? _viewOrderBy;

  int? get categoryId => _categoryId;
  String? get categoryName => _categoryName;
  String? get imageURl => _imageURl;
  String? get numberOfPrayers => _numberOfPrayers;
  int? get viewOrderBy => _viewOrderBy;

  // Getter for content_type

  TranquilTalesCategoryModel({
    required categoryId,
    required categoryName,
    required imageURl,
    required numberOfPrayers,
    required viewOrderBy,
  }) {
    _categoryId = categoryId;
    _categoryName = categoryName;
    _imageURl = imageURl;
    _numberOfPrayers = numberOfPrayers;
    _viewOrderBy = viewOrderBy;
  }

  TranquilTalesCategoryModel.fromJson(Map<String, dynamic> json) {
    _categoryId = json['category_id'];
    _categoryName = json['category_name'];
    _imageURl = json['image_url'];
    _numberOfPrayers = json['number_of_prayers'];
    _viewOrderBy = json['view_order_by'];

    // Assign the value to the content_type field
  }
}

class GetAssetDetailsModel {
  GetAssetDetailsModel({
      this.error, 
      this.message, 
      this.categoryList,});

  GetAssetDetailsModel.fromJson(dynamic json) {
    error = json['error'];
    message = json['message'];
    if (json['categoryList'] != null) {
      categoryList = [];
      json['categoryList'].forEach((v) {
        categoryList?.add(CategoryList.fromJson(v));
      });
    }
  }
  bool? error;
  String? message;
  List<CategoryList>? categoryList;
GetAssetDetailsModel copyWith({  bool? error,
  String? message,
  List<CategoryList>? categoryList,
}) => GetAssetDetailsModel(  error: error ?? this.error,
  message: message ?? this.message,
  categoryList: categoryList ?? this.categoryList,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['error'] = error;
    map['message'] = message;
    if (categoryList != null) {
      map['categoryList'] = categoryList?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class CategoryList {
  CategoryList({
      this.id, 
      this.categoryType,});

  CategoryList.fromJson(dynamic json) {
    id = json['id'];
    categoryType = json['categoryType'];
  }
  num? id;
  String? categoryType;
CategoryList copyWith({  num? id,
  String? categoryType,
}) => CategoryList(  id: id ?? this.id,
  categoryType: categoryType ?? this.categoryType,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['categoryType'] = categoryType;
    return map;
  }

}
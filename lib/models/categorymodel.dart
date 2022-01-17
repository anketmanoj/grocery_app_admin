import 'dart:convert';

CategoryModel categoryFromJson(String str) =>
    CategoryModel.fromJson(json.decode(str));

List<CategoryModel> categoriesFromJson(dynamic str) =>
    List<CategoryModel>.from((str).map((x) => CategoryModel.fromJson(x)));

class CategoryModel {
  int? id;
  String? name;
  int? parent;
  String? description;
  String? image;

  CategoryModel({
    this.description,
    this.id,
    this.image,
    this.name,
    this.parent,
  });

  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'].toString().replaceAll("&amp;", "&");
    parent = json['parent'];
    description = json['description'].replaceAll("&amp;", "&");
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();

    data['id'] = id;
    data['name'] = name;
    data['parent'] = parent;
    data['description'] = description;
    data['image'] = image;

    return data;
  }
}

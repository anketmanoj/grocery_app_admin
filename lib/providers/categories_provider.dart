import 'package:flutter/material.dart';
import 'package:grocery_app_admin/models/categorymodel.dart';
import 'package:grocery_app_admin/services/api_service.dart';

class CategoriesProvider with ChangeNotifier {
  late APIService _apiService;

  late List<CategoryModel>? _categoriesList;
  List<CategoryModel> get categoriesList => _categoriesList!;

  double get totalRecords => _categoriesList!.length.toDouble();

  CategoriesProvider() {
    _apiService = APIService();
    _categoriesList = null;
  }

  resetStreams() {
    _apiService = APIService();
    _categoriesList = null;

    notifyListeners();
  }

  fetchCategories({
    String? strSearch,
    String? sortBy,
    String? sortOrder,
  }) async {
    List<CategoryModel>? categoriesList = await _apiService.getCategories(
      strSearch: strSearch,
      sortby: sortBy,
      sortOrder: sortOrder,
    );

    _categoriesList ??= List<CategoryModel>.empty(growable: true);

    if (categoriesList!.isNotEmpty) {
      _categoriesList = [];
      _categoriesList!.addAll(categoriesList);
    }

    notifyListeners();
  }

  createCategory({CategoryModel? model, Function? onCallBack}) async {
    CategoryModel? _categoryModel =
        await _apiService.createCategory(model: model!);

    if (_categoryModel != null) {
      _categoriesList!.add(_categoryModel);
      onCallBack!(true);
    } else {
      onCallBack!(false);
    }

    notifyListeners();
  }

  updateCategory({CategoryModel? model, Function? onCallBack}) async {
    CategoryModel? _categoryModel =
        await _apiService.updateCategory(model: model!);

    if (_categoryModel != null) {
      _categoriesList!.remove(model);
      _categoriesList!.add(_categoryModel);
      onCallBack!(true);
    } else {
      onCallBack!(false);
    }

    notifyListeners();
  }

  deleteCategory({required CategoryModel model, Function? onCallBack}) async {
    bool? isDeleted = await _apiService.deleteCategory(model: model);

    if (isDeleted) {
      _categoriesList!.remove(model);
    }

    onCallBack!(true);

    notifyListeners();
  }
}

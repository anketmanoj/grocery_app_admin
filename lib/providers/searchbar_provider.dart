import 'package:flutter/material.dart';

class SortModel {
  int? sortColumIndex;
  String? sortColumnName;
  bool? sortAscending;

  SortModel({this.sortAscending, this.sortColumIndex, this.sortColumnName});
}

class SearchBarProvider with ChangeNotifier {
  late SortModel _sortModel;
  SortModel get sortModel => _sortModel;

  SearchBarProvider() {
    _sortModel = SortModel();
    _sortModel.sortColumIndex = 0;
    _sortModel.sortAscending = false;
  }

  setSort({
    required int? columnIndex,
    required String? sortColumnName,
    required bool? ascending,
  }) {
    _sortModel.sortAscending = ascending;
    _sortModel.sortColumIndex = columnIndex;
    _sortModel.sortColumnName = sortColumnName;

    notifyListeners();
  }
}

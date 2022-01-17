// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_app_admin/enums/page_type.dart';
import 'package:grocery_app_admin/models/categorymodel.dart';
import 'package:grocery_app_admin/pages/base_page.dart';
import 'package:grocery_app_admin/pages/categories/category_add_edit.dart';
import 'package:grocery_app_admin/providers/categories_provider.dart';
import 'package:grocery_app_admin/providers/loader_provider.dart';
import 'package:grocery_app_admin/providers/searchbar_provider.dart';
import 'package:grocery_app_admin/utils/searchbar_utils.dart';
import 'package:provider/provider.dart';
import 'package:snippet_coder_utils/list_helper.dart';

class CategoriesList extends BasePage {
  @override
  _CategoriesListState createState() => _CategoriesListState();
}

class _CategoriesListState extends BasePageState<CategoriesList> {
  // List<CategoryModel> categories = List<CategoryModel>.empty(growable: true);

  @override
  void initState() {
    super.initState();
    pageTitle = "Categories";
    // categories = List<CategoryModel>.empty(growable: true);

    // categories.add(
    //   CategoryModel(
    //     image: "",
    //     parent: 0,
    //     description: "Baby care products",
    //     id: 1,
    //     name: "Baby Care",
    //   ),
    // );
    // categories.add(
    //   CategoryModel(
    //     image: "",
    //     parent: 0,
    //     description: "Grocery products",
    //     id: 2,
    //     name: "Grocery",
    //   ),
    // );

    var categoryProvider =
        Provider.of<CategoriesProvider>(context, listen: false);

    categoryProvider.fetchCategories();
  }

  @override
  Widget pageUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: SearchBarUtils.searchBar(
            context: context,
            keyName: "strCategory",
            placeHolder: "Search Category",
            addButtonLabel: "Add Category",
            onSearchTap: (val) {
              SortModel sortModel =
                  Provider.of<SearchBarProvider>(context, listen: false)
                      .sortModel;

              var categoryProvider =
                  Provider.of<CategoriesProvider>(context, listen: false);

              categoryProvider.resetStreams();
              categoryProvider.fetchCategories(
                sortBy: sortModel.sortColumnName,
                sortOrder: sortModel.sortAscending! ? "asc" : "desc",
                strSearch: val,
              );
            },
            onAddButtonTab: () {
              Get.to(
                () => CategoryAddEditPage(
                  pageType: PageType.Add,
                ),
              );
            },
          ),
        ),
        Divider(
          color: Theme.of(context).primaryColor,
        ),
        categoryListUI(),
      ],
    );
  }

  Widget categoryListUI() {
    return Consumer<CategoriesProvider>(
      builder: (context, model, child) {
        if (model.categoriesList.isNotEmpty) {
          return ListUtils.buildDataTable<CategoryModel>(
            context,
            [
              "Name",
              "Description",
              "",
            ],
            ["name", "description", ""],
            Provider.of<SearchBarProvider>(context, listen: true)
                .sortModel
                .sortAscending!,
            Provider.of<SearchBarProvider>(context, listen: true)
                .sortModel
                .sortColumIndex!,
            model.categoriesList,
            (onEditVal) {
              Get.to(
                () => CategoryAddEditPage(
                  pageType: PageType.Edit,
                  model: onEditVal,
                ),
              );
            },
            (CategoryModel onDeleteVal) {
              Provider.of<CategoriesProvider>(context, listen: false)
                  .deleteCategory(
                      model: onDeleteVal,
                      onCallBack: (val) {
                        print("val === $val");

                        if (val) {
                          Get.snackbar(
                            "Grocery Admin App",
                            "Category Deleted",
                            snackPosition: SnackPosition.BOTTOM,
                            duration: const Duration(seconds: 3),
                          );
                        }
                      });
            },
            onSort: (columnIndex, columnName, ascending) {
              Provider.of<SearchBarProvider>(context, listen: false).setSort(
                ascending: ascending,
                columnIndex: columnIndex,
                sortColumnName: columnName,
              );

              var categoryProvider =
                  Provider.of<CategoriesProvider>(context, listen: false);
              categoryProvider.resetStreams();
              categoryProvider.fetchCategories(
                sortBy: columnName,
                sortOrder: ascending ? "asc" : "desc",
              );
            },
            headingRowColor: Theme.of(context).primaryColor,
            columnTextBold: false,
          );
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

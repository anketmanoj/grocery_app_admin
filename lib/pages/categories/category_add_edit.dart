import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_app_admin/enums/page_type.dart';
import 'package:grocery_app_admin/models/categorymodel.dart';
import 'package:grocery_app_admin/pages/base_page.dart';
import 'package:grocery_app_admin/providers/categories_provider.dart';
import 'package:grocery_app_admin/providers/loader_provider.dart';
import 'package:provider/provider.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

class CategoryAddEditPage extends BasePage {
  final PageType pageType;
  final CategoryModel? model;

  CategoryAddEditPage({Key? key, required this.pageType, this.model});

  @override
  _CategoryAddEditPageState createState() => _CategoryAddEditPageState();
}

class _CategoryAddEditPageState extends BasePageState<CategoryAddEditPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  CategoryModel? categoryModel;

  @override
  void initState() {
    super.initState();
    pageTitle =
        widget.pageType == PageType.Add ? "Add Category" : "Edit Category";

    if (widget.pageType == PageType.Edit) {
      categoryModel = widget.model;
    } else {
      categoryModel = CategoryModel();
    }
  }

  @override
  Widget pageUI() {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FormHelper.inputFieldWidgetWithLabel(
                context,
                Icon(Icons.ac_unit),
                "name",
                "Category Name",
                "",
                (onValidateVal) {
                  if (onValidateVal.toString().isEmpty) {
                    return "Category name cannot be empty";
                  }

                  return null;
                },
                (onSavedVal) {
                  categoryModel!.name = onSavedVal;
                },
                initialValue: categoryModel!.name ?? "",
                borderColor: Theme.of(context).primaryColor,
                borderFocusColor: Theme.of(context).primaryColor,
                showPrefixIcon: false,
                borderRadius: 10,
                paddingLeft: 0,
                paddingRight: 0,
              ),
              FormHelper.inputFieldWidgetWithLabel(
                context,
                Icon(Icons.ac_unit),
                "description",
                "Category Description",
                "",
                (onValidateVal) {
                  if (onValidateVal.toString().isEmpty) {
                    return "Category description cannot be empty";
                  }

                  return null;
                },
                (onSavedVal) {
                  categoryModel!.description = onSavedVal;
                },
                borderColor: Theme.of(context).primaryColor,
                borderFocusColor: Theme.of(context).primaryColor,
                showPrefixIcon: false,
                initialValue: categoryModel!.description ?? "",
                borderRadius: 10,
                paddingLeft: 0,
                paddingRight: 0,
                isMultiline: true,
                containerHeight: 200,
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: FormHelper.submitButton(
                  "Save",
                  () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();

                      Provider.of<LoaderProvider>(context, listen: false)
                          .setLoadingStatus(true);

                      if (widget.pageType == PageType.Add) {
                        Provider.of<CategoriesProvider>(context, listen: false)
                            .createCategory(
                          model: categoryModel!,
                          onCallBack: (val) {
                            Provider.of<LoaderProvider>(context, listen: false)
                                .setLoadingStatus(false);

                            print(val);

                            if (val) {
                              Get.snackbar(
                                "Grocery Admin App",
                                "Category Created",
                                snackPosition: SnackPosition.BOTTOM,
                                duration: Duration(seconds: 3),
                              );
                            }
                          },
                        );
                      } else {
                        Provider.of<CategoriesProvider>(context, listen: false)
                            .updateCategory(
                          model: categoryModel,
                          onCallBack: (val) {
                            Provider.of<LoaderProvider>(context, listen: false)
                                .setLoadingStatus(false);

                            print(val);

                            if (val) {
                              Get.snackbar(
                                "Grocery Admin App",
                                "Category Updated",
                                snackPosition: SnackPosition.BOTTOM,
                                duration: Duration(seconds: 3),
                              );
                            }
                          },
                        );
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

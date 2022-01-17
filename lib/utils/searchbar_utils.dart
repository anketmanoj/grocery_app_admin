import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

class SearchBarUtils {
  static Widget searchBar({
    required BuildContext context,
    required String keyName,
    required String placeHolder,
    required String addButtonLabel,
    required Function onSearchTap,
    required Function onAddButtonTab,
  }) {
    String val = "";
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: FormHelper.inputFieldWidget(
            context,
            Icon(Icons.web),
            keyName,
            placeHolder,
            () {},
            () {},
            onChange: (onChangeVal) {
              val = onChangeVal;
            },
            showPrefixIcon: false,
            suffixIcon: Container(
              child: GestureDetector(
                child: Icon(
                  Icons.search,
                ),
                onTap: () {
                  return onSearchTap(val);
                },
              ),
            ),
            borderFocusColor: Theme.of(context).primaryColor,
            borderColor: Theme.of(context).primaryColor,
            borderRadius: 10,
            paddingLeft: 0,
          ),
        ),
        Expanded(
          flex: 1,
          child: FormHelper.submitButton(
            addButtonLabel,
            () {
              return onAddButtonTab();
            },
            borderRadius: 10,
            width: 100,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:grocery_app_admin/providers/loader_provider.dart';
import 'package:grocery_app_admin/services/shared_services.dart';
import 'package:provider/provider.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';

class BasePage extends StatefulWidget {
  @override
  BasePageState createState() => BasePageState();
}

class BasePageState<T extends BasePage> extends State<T> {
  String pageTitle = "";
  @override
  Widget build(BuildContext context) {
    return Consumer<LoaderProvider>(
      builder: (context, loaderModel, child) {
        return Scaffold(
          appBar: _buildAppBar(),
          body: ProgressHUD(
            key: GlobalKey(),
            child: pageUI()!,
            inAsyncCall: loaderModel.isApiCallProcess,
            opacity: 0.3,
          ),
        );
      },
    );
  }

  PreferredSizeWidget? _buildAppBar() {
    return AppBar(
      title: Text(pageTitle),
      elevation: 0,
      automaticallyImplyLeading: true,
      backgroundColor: Theme.of(context).primaryColor,
      actions: [
        IconButton(
          onPressed: () {
            SharedService.logOut();
          },
          icon: Icon(
            Icons.logout,
            color: Colors.black,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
      ],
    );
  }

  Widget? pageUI() {
    return null;
  }

  @override
  void dispose() {
    super.dispose();
  }
}

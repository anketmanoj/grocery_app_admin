import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:grocery_app_admin/models/login_model.dart';
import 'package:grocery_app_admin/pages/homepage.dart';
import 'package:grocery_app_admin/services/api_service.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final globalFormKey = GlobalKey<FormState>();
  bool isApiCallProcess = false;

  late LoginModel loginModel;

  @override
  void initState() {
    super.initState();

    loginModel = LoginModel();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ProgressHUD(
          key: globalFormKey,
          child: _loginUI(context),
          inAsyncCall: isApiCallProcess,
          opacity: 0.3,
        ),
      ),
    );
  }

  Widget _loginUI(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: globalFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 4,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor,
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(150),
                  bottomLeft: Radius.circular(150),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "FreshFare Admin",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            const Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 20, top: 20),
                child: Text(
                  "Admin Login",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: FormHelper.inputFieldWidget(
                context,
                Icon(Icons.web),
                "Host",
                "Host Url",
                (onValidateVal) {
                  if (onValidateVal.isEmpty) {
                    return "Host Url cannot be empty";
                  }
                  return null;
                },
                (onSavedVal) {
                  loginModel.host = onSavedVal;
                },
                borderFocusColor: Theme.of(context).primaryColor,
                borderColor: Theme.of(context).primaryColor,
                initialValue: "",
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: FormHelper.inputFieldWidget(
                context,
                Icon(Icons.lock),
                "Key",
                "Consumer Key",
                (onValidateVal) {
                  if (onValidateVal.isEmpty) {
                    return "Key cannot be empty";
                  }
                  return null;
                },
                (onSavedVal) {
                  loginModel.key = onSavedVal;
                },
                borderFocusColor: Theme.of(context).primaryColor,
                borderColor: Theme.of(context).primaryColor,
                initialValue: loginModel.key ?? "",
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: FormHelper.inputFieldWidget(
                context,
                Icon(Icons.security),
                "Consumer Secret",
                "Consumer Secret",
                (onValidateVal) {
                  if (onValidateVal.isEmpty) {
                    return "Consumer Secret cannot be empty";
                  }
                  return null;
                },
                (onSavedVal) {
                  loginModel.secret = onSavedVal;
                },
                borderFocusColor: Theme.of(context).primaryColor,
                borderColor: Theme.of(context).primaryColor,
                initialValue: loginModel.secret ?? "",
              ),
            ),
            const Center(
              child: Text(
                "Or",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            Center(
              child: GestureDetector(
                onTap: () async {
                  await scanQR();
                },
                child: const Icon(
                  Icons.qr_code,
                  size: 100,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: FormHelper.submitButton(
                "Login",
                () async {
                  if (validateAndSave()) {
                    setState(() {
                      isApiCallProcess = true;
                    });

                    await APIService.checkLogin(loginModel).then((response) {
                      setState(() {
                        isApiCallProcess = false;
                      });
                      if (response) {
                        Get.offAll(() => HomePage());
                      } else {
                        FormHelper.showSimpleAlertDialog(
                          context,
                          "Admin",
                          "Invalid Details",
                          "Ok",
                          () {
                            setState(() {
                              loginModel.key = "";
                              loginModel.secret = "";
                            });

                            Navigator.pop(context);
                          },
                        );
                      }
                    });
                  }
                },
                btnColor: Theme.of(context).primaryColor,
                borderColor: Theme.of(context).primaryColor,
                txtColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> scanQR() async {
    late String barCodeScanRes;

    try {
      barCodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666",
        "Cancel",
        true,
        ScanMode.QR,
      );
    } catch (e) {}

    if (!mounted) return;

    setState(() {
      if (barCodeScanRes.isNotEmpty) {
        loginModel.key = barCodeScanRes.split("|")[0];
        loginModel.secret = barCodeScanRes.split("|")[1];
      }
    });
  }

  bool validateAndSave() {
    if (globalFormKey.currentState!.validate()) {
      print("test3");
      globalFormKey.currentState!.save();
      return true;
    }
    return false;
  }
}

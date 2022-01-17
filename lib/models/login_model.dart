class LoginModel {
  String? host = "";
  String? key = "";
  String? secret = "";

  LoginModel({this.host, this.key, this.secret});

  LoginModel.fromJson(Map<String, dynamic> json) {
    host = json['Host'];
    key = json['Key'];
    secret = json['Secret'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Host'] = host;
    data['Key'] = key;
    data['Secret'] = secret;

    return data;
  }
}

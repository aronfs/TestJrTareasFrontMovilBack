class AuthModel {
  String? email;
  String? password;
  String? token;

  AuthModel({this.email, this.password, this.token});

  AuthModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    email = json['username'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['username'] = email;
    data['password'] = password;
    return data;
  }
}
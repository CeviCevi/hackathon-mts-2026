class UserModel {
  final int id;
  final String login;
  final String password;

  UserModel({required this.id, required this.login, required this.password});

  Map<String, dynamic> toJson() {
    return {'id': id, 'login': login, 'password': password};
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      login: json['login'] as String,
      password: json['password'] as String,
    );
  }
}

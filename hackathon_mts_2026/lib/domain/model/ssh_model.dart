class SshModel {
  final int id;
  final String name;
  final int port; //TODO
  final String adress;
  final String password;

  SshModel({
    required this.id,
    required this.name,
    required this.port,
    required this.adress,
    required this.password,
  });

  factory SshModel.fromJson(Map<String, dynamic> json) {
    return SshModel(
      id: json['id'] as int,
      name: json['name'] as String,
      port: json['port'] as int,
      adress: json['adress'] as String,
      password: json['password'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'port': port,
      'adress': adress,
      'password': password,
    };
  }
}

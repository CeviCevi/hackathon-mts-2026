class SshModel {
  final int id;
  final int port; //TODO

  SshModel({required this.id, required this.port});

  factory SshModel.fromJson(Map<String, dynamic> json) {
    return SshModel(id: json['id'] as int, port: json['port'] as int);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'port': port};
  }
}

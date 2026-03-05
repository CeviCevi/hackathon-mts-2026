class SshModel {
  final int id;
  final int port; //TODO
  final int userId;
  final int vmId;

  SshModel({
    required this.id,
    required this.port,
    required this.userId,
    required this.vmId,
  });

  factory SshModel.fromJson(Map<String, dynamic> json) {
    return SshModel(
      id: json['id'] as int,
      port: json['port'] as int,
      userId: json['idUser'] as int,
      vmId: json['idVm'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'port': port, 'idUser': userId, 'idVm': vmId};
  }
}

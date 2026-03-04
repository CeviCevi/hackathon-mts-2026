class HarVmModel {
  final int id;
  final int idUser;
  final int idVm;
  final String role;

  HarVmModel({
    required this.id,
    required this.idUser,
    required this.idVm,
    required this.role,
  });

  factory HarVmModel.fromJson(Map<String, dynamic> json) {
    return HarVmModel(
      id: json['id'] as int,
      idUser: json['idUser'] as int, //json['user_id']
      idVm: json['idVm'] as int, //   json['vm_id']
      role: json['role'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'idUser': idUser, 'idVm': idVm, 'role': role};
  }
}

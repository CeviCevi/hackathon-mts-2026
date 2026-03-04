class VmModel {
  final int id;
  final String name;
  final String password;
  final int idSsh;
  final int ram;
  final int rom;
  final int cors;
  final String os;
  final int status;

  VmModel({
    required this.id,
    required this.name,
    required this.idSsh,
    required this.ram,
    required this.rom,
    required this.cors,
    required this.password,
    required this.status,
    required this.os,
  });

  factory VmModel.fromJson(Map<String, dynamic> json) {
    return VmModel(
      id: json['id'] as int,
      name: json['name'] as String,
      idSsh: json['idSsh'] as int,
      ram: json['ram'] as int,
      rom: json['rom'] as int,
      cors: json['cors'] as int,
      password: json['password'] as String,
      status: json['status'] as int,
      os: json['os'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'idSsh': idSsh,
      'ram': ram,
      'rom': rom,
      'cors': cors,
      'password': password,
      'status': status,
      'os': os,
    };
  }
}

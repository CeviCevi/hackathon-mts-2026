class VmModel {
  final int id;
  final String name;
  final int sshId;
  final double ram;
  final double rom;
  final double frequency;
  final int status;
  final String os;

  VmModel({
    required this.id,
    required this.name,
    required this.sshId,
    required this.ram,
    required this.rom,
    required this.frequency,
    required this.status,
    required this.os,
  });
}

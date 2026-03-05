import 'package:hackathon_mts_2026/domain/model/user_model.dart';
import 'package:hackathon_mts_2026/domain/model/vm_model.dart';

final List<VmModel> vmList = [
  VmModel(
    id: 0,
    name: "Fish Mashine",
    idSsh: 123,
    ram: 100000,
    rom: 10,
    cors: 12,
    password: "password",
    status: 3,
    os: "Ubuntu",
  ),
];
UserModel userInSystem = UserModel(id: 1, login: "login", password: "password");
VmModel openModel = vmList.first;

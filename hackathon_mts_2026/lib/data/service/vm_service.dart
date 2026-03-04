import 'package:dio/dio.dart';
import 'package:hackathon_mts_2026/domain/fish/db.dart';
import 'package:hackathon_mts_2026/domain/model/vm_model.dart';
import 'package:hackathon_mts_2026/domain/path/path_vending.dart';

class VmService {
  static final dio = Dio(BaseOptions(baseUrl: PathVending.apiPath));

  Future<List<VmModel>> getVmListByUserId(int userId) async {
    return vmList;
  }
}

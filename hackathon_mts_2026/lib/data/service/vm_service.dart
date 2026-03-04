import 'package:dio/dio.dart';
import 'package:hackathon_mts_2026/domain/path/path_vending.dart';

class VmService {
  static final dio = Dio(BaseOptions(baseUrl: PathVending.apiPath));
}

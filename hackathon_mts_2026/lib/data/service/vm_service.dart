import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:hackathon_mts_2026/domain/fish/db.dart';
import 'package:hackathon_mts_2026/domain/model/vm_model.dart';
import 'package:hackathon_mts_2026/domain/path/path_vending.dart';

class VmService {
  static final dio = Dio(BaseOptions(baseUrl: PathVending.apiPath));

  Future<bool> startVm(int vmId, {int? userId}) async {
    try {
      final Response response = await dio.put(
        "api/vm/start/$vmId/${userId ?? userInSystem.id}",
      );
      if (response.statusCode == 200) return true;
      return false;
    } catch (e) {
      log("machine dont start");
      return false;
    }
  }

  Future<bool> stobVm(int vmId) async {
    try {
      final Response response = await dio.put("api/vm/stop/$vmId");
      if (response.statusCode == 200) return true;
      return false;
    } catch (e) {
      log("machine dont stop");
      return false;
    }
  }

  Future<List<VmModel>> getVmListByUserId(int userId) async {
    try {
      final Response response = await dio.get(
        "api/vm/allByUser/${userInSystem.id}",
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data is List) {
          return (response.data as List)
              .map((json) => VmModel.fromJson(json))
              .toList();
        } else {
          log('Response data is not a list');
          return [];
        }
      } else {
        log('Vm create failed with status: ${response.statusCode}');
        return [];
      }
    } on DioException catch (e) {
      log('Dio error: ${e.message}');
      if (e.response != null) {
        log('Response data: ${e.response?.data}');
        log('Response status: ${e.response?.statusCode}');
      }
      return [];
    } catch (e) {
      log('Unexpected error: $e');
      return [];
    }
  }

  Future<List<VmModel>> getAll() async {
    try {
      final Response response = await dio.get("api/vm/all");

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data is List) {
          return (response.data as List)
              .map((json) => VmModel.fromJson(json))
              .toList();
        } else {
          log('Response data is not a list');
          return [];
        }
      } else {
        log('Vm create failed with status: ${response.statusCode}');
        return [];
      }
    } on DioException catch (e) {
      log('Dio error: ${e.message}');
      if (e.response != null) {
        log('Response data: ${e.response?.data}');
        log('Response status: ${e.response?.statusCode}');
      }
      return [];
    } catch (e) {
      log('Unexpected error: $e');
      return [];
    }
  }

  Future<VmModel?> create(VmModel model) async {
    try {
      final Response response = await dio.post(
        "api/vm/register/${userInSystem.id}",
        data: model.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return VmModel.fromJson(response.data);
      } else {
        log('Vm create failed with status: ${response.statusCode}');
        return null;
      }
    } on DioException catch (e) {
      log('Dio error: ${e.message}');
      if (e.response != null) {
        log('Response data: ${e.response?.data}');
        log('Response status: ${e.response?.statusCode}');
      }
      return null;
    } catch (e) {
      log('Unexpected error: $e');
      return null;
    }
  }

  Future<bool> addNewUserToVm(int vmId, int userId) async {
    try {
      final Response response = await dio.post("api/vm/user/add/$vmId/$userId");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        log('Vm create failed with status: ${response.statusCode}');
        return false;
      }
    } on DioException catch (e) {
      log('Dio error: ${e.message}');
      if (e.response != null) {
        log('Response data: ${e.response?.data}');
        log('Response status: ${e.response?.statusCode}');
      }
      return false;
    } catch (e) {
      log('Unexpected error: $e');
      return false;
    }
  }

  Future<VmModel?> updateStatus(VmModel model, {int status = 200}) async {
    try {
      final Response response = await dio.post(
        "api/vm/update/status/${model.id}/$status",
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return VmModel.fromJson(response.data);
      } else {
        log('Vm create failed with status: ${response.statusCode}');
        return null;
      }
    } on DioException catch (e) {
      log('Dio error: ${e.message}');
      if (e.response != null) {
        log('Response data: ${e.response?.data}');
        log('Response status: ${e.response?.statusCode}');
      }
      return null;
    } catch (e) {
      log('Unexpected error: $e');
      return null;
    }
  }

  Future<VmModel?> buildVm(VmModel model) async {
    try {
      final Response response = await dio.post(
        "api/host/vm/create",
        data: model.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return VmModel.fromJson(response.data);
      } else {
        log('Vm create failed with status: ${response.statusCode}');
        return null;
      }
    } on DioException catch (e) {
      log('Dio error: ${e.message}');
      if (e.response != null) {
        log('Response data: ${e.response?.data}');
        log('Response status: ${e.response?.statusCode}');
      }
      return null;
    } catch (e) {
      log('Unexpected error: $e');
      return null;
    }
  }

  Future<VmModel?> getAllMachinesByUserId(VmModel model) async {
    try {
      final Response response = await dio.post(
        "api/vm/register/${userInSystem.id}",
        data: model.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return VmModel.fromJson(response.data);
      } else {
        log('Vm create failed with status: ${response.statusCode}');
        return null;
      }
    } on DioException catch (e) {
      log('Dio error: ${e.message}');
      if (e.response != null) {
        log('Response data: ${e.response?.data}');
        log('Response status: ${e.response?.statusCode}');
      }
      return null;
    } catch (e) {
      log('Unexpected error: $e');
      return null;
    }
  }
}

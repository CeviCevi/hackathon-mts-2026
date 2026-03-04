import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:hackathon_mts_2026/domain/model/user_model.dart';
import 'package:hackathon_mts_2026/domain/path/path_vending.dart';

class AuthService {
  final dio = Dio(BaseOptions(baseUrl: PathVending.apiPath));

  Future<UserModel?> registration(UserModel model) async {
    try {
      final Response response = await dio.post(
        "/api/user/register",
        data: model.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return UserModel.fromJson(response.data);
      } else {
        log('Registration failed with status: ${response.statusCode}');
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

  Future<UserModel?> login(UserModel model) async {
    try {
      final Response response = await dio.post(
        "/api/user/login",
        data: model.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return UserModel.fromJson(response.data);
      } else {
        log('Registration failed with status: ${response.statusCode}');
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

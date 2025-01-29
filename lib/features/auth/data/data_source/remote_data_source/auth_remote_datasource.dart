import 'dart:io';

import 'package:dio/dio.dart';
import 'package:softwarica_student_management_bloc/app/constants/api_endpoints.dart';
import 'package:softwarica_student_management_bloc/features/auth/data/data_source/auth_data_source.dart';
import 'package:softwarica_student_management_bloc/features/auth/domain/entity/auth_entity.dart';

class AuthRemoteDataSource implements IAuthDataSource {
  final Dio _dio;

  AuthRemoteDataSource(this._dio);
  
  @override
  Future<void> registerStudent(AuthEntity student) async {
    try {
      Response response = await _dio.post(
        ApiEndpoints.register,
        data: {
          "fname": student.fName,
          "lname": student.lName,
          "phone": student.phone,
          "image": student.image,
          "username": student.username,
          "password": student.password,
          "batch": student.batch.batchId,
          // "course": ["6489a5908dbc6d39719ec19c", "6489a5968dbc6d39719ec19e"]
          "course": student.courses.map((e) => e.courseId).toList(),
        },
      );

      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw Exception(e);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<AuthEntity> getCurrentUser() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }

  @override
  Future<String> loginStudent(String username, String password) async {
    try {
      Response response = await _dio.post(
        ApiEndpoints.login,
        data: {
          "username": username,
          "password": password,
        },
      );

      if (response.statusCode == 200) {
        final str = response.data['token'];
        return str;
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw Exception(e);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<String> uploadProfilePicture(File file) async {
    try {
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap(
        {
          'profilePicture': await MultipartFile.fromFile(
            file.path,
            filename: fileName,
          ),
        },
      );

      Response response = await _dio.post(
        ApiEndpoints.uploadImage,
        data: formData,
      );

      if (response.statusCode == 200) {
        // Extract the image name from the response
        final str = response.data['data'];

        return str;
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw Exception(e);
    } catch (e) {
      throw Exception(e);
    }
  }
}

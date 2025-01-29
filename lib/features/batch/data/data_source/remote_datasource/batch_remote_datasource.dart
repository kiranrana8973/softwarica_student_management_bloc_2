import 'package:dio/dio.dart';
import 'package:softwarica_student_management_bloc/app/constants/api_endpoints.dart';
import 'package:softwarica_student_management_bloc/features/batch/data/data_source/batch_data_source.dart';
import 'package:softwarica_student_management_bloc/features/batch/data/dto/get_all_batch_dto.dart';
import 'package:softwarica_student_management_bloc/features/batch/data/model/batch_api_model.dart';
import 'package:softwarica_student_management_bloc/features/batch/domain/entity/batch_entity.dart';

class BatchRemoteDataSource implements IBatchDataSource {
  final Dio _dio;

  BatchRemoteDataSource({
    required Dio dio,
  }) : _dio = dio;

  @override
  Future<void> createBatch(BatchEntity batch) async {
    try {
      // Convert entity to model
      var batchApiModel = BatchApiModel.fromEntity(batch);
      var response = await _dio.post(
        ApiEndpoints.createBatch,
        data: batchApiModel.toJson(),
      );
      if (response.statusCode == 201) {
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
  Future<void> deleteBatch(String id, String? token) async {
    try {
      var response = await _dio.delete(
        ApiEndpoints.deleteBatch + id,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
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
  Future<List<BatchEntity>> getBatches() async {
    try {
      var response = await _dio.get(ApiEndpoints.getAllBatch);
      if (response.statusCode == 200) {
        GetAllBatchDTO batchAddDTO = GetAllBatchDTO.fromJson(response.data);
        return BatchApiModel.toEntityList(batchAddDTO.data);
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

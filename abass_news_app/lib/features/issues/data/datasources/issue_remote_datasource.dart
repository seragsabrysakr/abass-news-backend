import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/api_client.dart';
import '../../../../shared/models/api_response.dart';
import '../../domain/entities/issue_entity.dart';
import '../models/issue_model.dart';

@injectable
class IssueRemoteDataSource {
  final ApiClient _apiClient;

  IssueRemoteDataSource(this._apiClient);

  Future<List<IssueModel>> getAllIssues() async {
    try {
      final response = await _apiClient.dio.get(AppConstants.issuesEndpoint);

      final apiResponse = ApiResponse.fromJson(response.data);

      if (!apiResponse.status) {
        throw Exception(apiResponse.message);
      }

      final issuesData = apiResponse.data['issues'] as List;
      return issuesData
          .map((issue) => IssueModel.fromJson(issue as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? 'Failed to fetch issues');
    }
  }

  Future<List<IssueModel>> getUserIssues() async {
    try {
      final response = await _apiClient.dio.get(
        AppConstants.userIssuesEndpoint,
      );

      final apiResponse = ApiResponse.fromJson(response.data);

      if (!apiResponse.status) {
        throw Exception(apiResponse.message);
      }

      final issuesData = apiResponse.data['issues'] as List;
      return issuesData
          .map((issue) => IssueModel.fromJson(issue as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? 'Failed to fetch user issues',
      );
    }
  }

  Future<IssueModel> createIssue({
    required String title,
    required String description,
    String? imageUrl,
    List<String>? attachments,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        AppConstants.issuesEndpoint,
        data: {
          'title': title,
          'description': description,
          if (imageUrl != null) 'imageUrl': imageUrl,
          if (attachments != null) 'attachments': attachments,
        },
      );

      final apiResponse = ApiResponse.fromJson(response.data);

      if (!apiResponse.status) {
        throw Exception(apiResponse.message);
      }

      final issueData = apiResponse.data['issue'] as Map<String, dynamic>;
      return IssueModel.fromJson(issueData);
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? 'Failed to create issue');
    }
  }

  Future<IssueModel> updateIssueStatus({
    required int id,
    required IssueStatus status,
    String? adminNotes,
  }) async {
    try {
      final response = await _apiClient.dio.put(
        '${AppConstants.issuesEndpoint}/$id/status',
        data: {
          'status': status.name,
          if (adminNotes != null) 'adminNotes': adminNotes,
        },
      );

      final apiResponse = ApiResponse.fromJson(response.data);

      if (!apiResponse.status) {
        throw Exception(apiResponse.message);
      }

      final issueData = apiResponse.data['issue'] as Map<String, dynamic>;
      return IssueModel.fromJson(issueData);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? 'Failed to update issue status',
      );
    }
  }
}

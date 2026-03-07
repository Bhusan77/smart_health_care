import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_health_care/core/api/api_client.dart';
import 'package:smart_health_care/core/api/api_endpoints.dart';
import 'package:smart_health_care/core/services/storage/token_service.dart';
import 'package:smart_health_care/core/services/storage/user_session_service.dart';
import 'package:smart_health_care/features/profile/data/datasources/profile_datasource.dart';
import 'package:smart_health_care/features/profile/data/models/profile_model.dart';

final profileRemoteDatasourceProvider = Provider<IProfileRemoteDatasource>((ref) {
  return ProfileRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
    userSessionService: ref.read(userSessionServiceProvider),
    tokenService: ref.read(tokenServiceProvider),
  );
});

class ProfileRemoteDatasource implements IProfileRemoteDatasource {
  final ApiClient _apiClient;
  final UserSessionService _userSessionService;
  final TokenService _tokenService;

  ProfileRemoteDatasource({
    required ApiClient apiClient,
    required UserSessionService userSessionService,
    required TokenService tokenService,
  })  : _apiClient = apiClient,
        _userSessionService = userSessionService,
        _tokenService = tokenService;

  @override
  Future<ProfileModel?> updatePersonalInfo(ProfileModel personalInfo) async {
    try {
      final token = await _tokenService.getToken();

      final Map<String, dynamic> formMap = {};

      if (personalInfo.username != null &&
          personalInfo.username!.trim().isNotEmpty) {
        formMap['username'] = personalInfo.username!.trim();
      }

      if (personalInfo.password != null &&
          personalInfo.password!.trim().isNotEmpty) {
        formMap['password'] = personalInfo.password!.trim();
      }

      if (personalInfo.profile != null) {
        formMap['profile'] = await MultipartFile.fromFile(
          personalInfo.profile!.path,
          filename: personalInfo.profile!.path.split('/').last,
        );
      }

      final formData = FormData.fromMap(formMap);

      debugPrint('PATCH URL: ${ApiEndpoints.updateProfile}');
      debugPrint('PATCH DATA: $formMap');

      final response = await _apiClient.patch(
        ApiEndpoints.updateProfile,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
          contentType: 'multipart/form-data',
        ),
      );

      debugPrint('UPDATE RESPONSE: ${response.data}');

      if (response.data['success'] == true) {
        final data = response.data['data'] as Map<String, dynamic>;
        final updatedUser = ProfileModel.fromJson(data);

        final existingUserId = _userSessionService.getCurrentUserId();

        await _userSessionService.saveUserSession(
          userId: updatedUser.userId ?? existingUserId,
        );

        return updatedUser;
      }

      return null;
    } catch (e) {
      debugPrint('updatePersonalInfo error: $e');
      rethrow;
    }
  }

  @override
  Future<ProfileModel?> getUserById(String userId) async {
    try {
      final response = await _apiClient.get('${ApiEndpoints.getUser}/$userId');

      debugPrint('GET USER RESPONSE: ${response.data}');

      if (response.data['success'] == true) {
        final data = response.data['data'] as Map<String, dynamic>;
        return ProfileModel.fromJson(data);
      }

      return null;
    } catch (e) {
      debugPrint('getUserById error: $e');
      rethrow;
    }
  }
}
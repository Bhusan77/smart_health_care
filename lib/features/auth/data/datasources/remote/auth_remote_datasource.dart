import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_health_care/core/api/api_client.dart';
import 'package:smart_health_care/core/api/api_endpoints.dart';
import 'package:smart_health_care/core/services/storage/token_service.dart';
import 'package:smart_health_care/core/services/storage/user_session_service.dart';
import 'package:smart_health_care/features/auth/data/datasources/auth_datasource.dart';
import 'package:smart_health_care/features/auth/data/models/auth_api_model.dart';

// Provider
final authRemoteDatasourceProvider = Provider<IAuthRemoteDataSource>((ref) {
  return AuthRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
    userSessionService: ref.read(userSessionServiceProvider),
    tokenSessionService: ref.read(tokenServiceProvider),
  );
});

class AuthRemoteDatasource implements IAuthRemoteDataSource {
  final ApiClient _apiClient;
  final UserSessionService _userSessionService;
  final TokenService _tokenSessionService;

  AuthRemoteDatasource({
    required ApiClient apiClient,
    required UserSessionService userSessionService,
    required TokenService tokenSessionService,
  })  : _apiClient = apiClient,
        _userSessionService = userSessionService,
        _tokenSessionService = tokenSessionService;

  @override
  Future<AuthApiModel?> login(String email, String password) async {
    final response = await _apiClient.post(
      ApiEndpoints.userLogin,
      data: {'email': email, 'password': password},
    );

    // Debug (remove later if you want)
    // print("LOGIN RESPONSE: ${response.data}");

    // Ensure response is Map
    if (response.data is! Map) {
      throw Exception("Unexpected login response format");
    }

    final root = Map<String, dynamic>.from(response.data as Map);

    // If success false, return null
    if (root["success"] != true) {
      return null;
    }

    // Ensure data exists and is Map
    final rawData = root["data"];
    if (rawData is! Map) {
      throw Exception("Login response missing 'data' object");
    }

    final data = Map<String, dynamic>.from(rawData);

    // Create user model from data
    final user = AuthApiModel.fromJson(data);

    // ✅ Token is usually inside data.token in your backend
    final token = root["token"] ??
        data["token"] ??
        data["accessToken"] ??
        data["jwt"];

    if (token == null || token.toString().isEmpty || token.toString() == "null") {
      throw Exception("Token not found in login response");
    }

    // Save token
    await _tokenSessionService.saveToken(token.toString());

    // Save user session userId safely
    final userId = user.id ?? data["_id"]?.toString() ?? data["id"]?.toString();
    if (userId != null && userId.isNotEmpty) {
      await _userSessionService.saveUserSession(userId: userId);
    }

    return user;
  }

  @override
  Future<AuthApiModel> register(AuthApiModel user) async {
    final response = await _apiClient.post(
      ApiEndpoints.userRegister,
      data: user.toJson(),
    );

    if (response.data is Map && response.data["success"] == true) {
      final data = response.data["data"];
      if (data is Map) {
        return AuthApiModel.fromJson(Map<String, dynamic>.from(data));
      }
    }

    return user;
  }

  @override
  Future<AuthApiModel?> getCurrentUser() {
    throw UnimplementedError();
  }

  @override
  Future<bool> logout() {
    throw UnimplementedError();
  }
}
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:smart_health_care/core/api/api_endpoints.dart';
import 'package:smart_health_care/core/services/storage/token_service.dart';

// Provider for ApiClient
final apiClientProvider = Provider<ApiClient>((ref) {
  final tokenService = ref.read(tokenServiceProvider);
  return ApiClient(tokenService: tokenService);
});

class ApiClient {
  final TokenService tokenService;
  late final Dio _dio;

  ApiClient({required this.tokenService}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: ApiEndpoints.connectionTimeout,
        receiveTimeout: ApiEndpoints.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // ✅ Add auth interceptor (adds Bearer token)
    _dio.interceptors.add(AuthInterceptor(tokenService));

    // Auto retry on network failures
    _dio.interceptors.add(
      RetryInterceptor(
        dio: _dio,
        retries: 3,
        retryDelays: const [
          Duration(seconds: 1),
          Duration(seconds: 2),
          Duration(seconds: 3),
        ],
        retryEvaluator: (error, attempt) {
          return error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.sendTimeout ||
              error.type == DioExceptionType.receiveTimeout ||
              error.type == DioExceptionType.connectionError;
        },
      ),
    );

    if (kDebugMode) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
        ),
      );
    }
  }

  Dio get dio => _dio;

  Future<Response> get(String path,
          {Map<String, dynamic>? queryParameters, Options? options}) =>
      _dio.get(path, queryParameters: queryParameters, options: options);

  Future<Response> post(String path,
          {dynamic data, Map<String, dynamic>? queryParameters, Options? options}) =>
      _dio.post(path, data: data, queryParameters: queryParameters, options: options);

  Future<Response> put(String path,
          {dynamic data, Map<String, dynamic>? queryParameters, Options? options}) =>
      _dio.put(path, data: data, queryParameters: queryParameters, options: options);

  Future<Response> patch(String path,
          {dynamic data, Map<String, dynamic>? queryParameters, Options? options}) =>
      _dio.patch(path, data: data, queryParameters: queryParameters, options: options);

  Future<Response> delete(String path,
          {dynamic data, Map<String, dynamic>? queryParameters, Options? options}) =>
      _dio.delete(path, data: data, queryParameters: queryParameters, options: options);
}

/// ✅ Reads token from SharedPreferences TokenService
/// ✅ Adds Authorization: Bearer <token>
class AuthInterceptor extends Interceptor {
  final TokenService tokenService;
  AuthInterceptor(this.tokenService);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await tokenService.getToken();

    if (token != null && token.isNotEmpty && token != "null" && token != "undefined") {
      options.headers["Authorization"] = "Bearer $token";
    } else {
      options.headers.remove("Authorization");
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      await tokenService.removeToken();
      // optional: trigger logout provider / navigation
    }
    handler.next(err);
  }
}
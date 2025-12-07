import 'package:dio/dio.dart';
import 'package:flutter_application/utils/http_interceptor.dart';

/// HTTP客户端配置
class HttpClient {
  static final HttpClient _instance = HttpClient._internal();
  late Dio _dio;

  factory HttpClient() {
    return _instance;
  }

  HttpClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
      ),
    );

    // 添加拦截器
    _dio.interceptors.add(HttpInterceptor());
  }

  /// 获取Dio实例
  Dio get dio => _dio;

  /// POST请求
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return await _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  /// GET请求
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return await _dio.get(
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  /// 文件上传
  Future<Response> uploadFile(
    String path,
    String filePath, {
    String name = 'file',
    Map<String, dynamic>? data,
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
  }) async {
    final formData = FormData.fromMap({
      ...?data,
      name: await MultipartFile.fromFile(filePath),
    });

    return await _dio.post(
      path,
      data: formData,
      onSendProgress: onSendProgress,
      cancelToken: cancelToken,
    );
  }
}

/// API配置
class ApiConfig {
  static const String baseUrl = 'http://otc-api-dev.ibitpay.io/';
}

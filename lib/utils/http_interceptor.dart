import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application/main.dart';

/// HTTP拦截器
/// 处理token、错误、日志等
class HttpInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // 异步获取token并添加到请求头
    _getToken()
        .then((token) {
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        })
        .catchError((error) {
          // 如果获取token失败，继续发送请求（不带token）
          handler.next(options);
        });
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // 处理响应数据
    if (response.data is Map<String, dynamic>) {
      final data = response.data as Map<String, dynamic>;

      // 检查业务状态码
      if (data.containsKey('code')) {
        final code = data['code'];
        if (code != 200 && code != 0) {
          // 业务错误
          final message = data['message'] ?? data['msg'] ?? '请求失败';
          _showError(message);
          handler.reject(
            DioException(
              requestOptions: response.requestOptions,
              response: response,
              type: DioExceptionType.badResponse,
              error: message,
            ),
          );
          return;
        }
      }
    }

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 打印错误日志
    log('❌ Error: ${err.type} ${err.requestOptions.uri}');
    log('📦 Error Message: ${err.message}');
    log('📦 Error Response: ${err.response?.data}');
    log('📦 Error: ${err.error}');

    String errorMessage = '网络请求失败';

    // 根据错误类型处理
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        errorMessage = '请求超时，请检查网络连接';
        break;
      case DioExceptionType.connectionError:
        // 连接错误，可能是网络不可达或权限问题
        if (err.error != null &&
            err.error.toString().contains('Operation not permitted')) {
          errorMessage = '网络连接被拒绝，请检查网络权限或尝试使用HTTPS';
        } else if (err.error != null &&
            err.error.toString().contains('Connection failed')) {
          errorMessage = '无法连接到服务器，请检查网络连接或服务器地址';
        } else {
          errorMessage = '网络连接失败，请检查网络设置';
        }
        break;
      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode;
        if (statusCode == 401) {
          errorMessage = '未授权，请重新登录';
          // 清除token并跳转到登录页
          _clearToken();
        } else if (statusCode == 403) {
          errorMessage = '没有权限访问';
        } else if (statusCode == 404) {
          errorMessage = '请求的资源不存在';
        } else if (statusCode == 500) {
          errorMessage = '服务器内部错误';
        } else {
          // 尝试从响应中获取错误信息
          if (err.response?.data is Map<String, dynamic>) {
            final data = err.response!.data as Map<String, dynamic>;
            errorMessage =
                data['message'] ?? data['msg'] ?? data['error'] ?? '请求失败';
          }
        }
        break;
      case DioExceptionType.cancel:
        errorMessage = '请求已取消';
        break;
      case DioExceptionType.unknown:
        errorMessage = '网络连接失败，请检查网络设置';
        break;
      default:
        errorMessage = err.message ?? '未知错误';
    }

    _showError(errorMessage);

    super.onError(err, handler);
  }

  /// 获取token（从本地存储）
  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  /// 清除token
  Future<void> _clearToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  /// 显示错误提示
  void _showError(String message) {
    log('⚠️ Error: $message');

    // 使用全局 navigatorKey 显示错误提示
    final context = navigatorKey.currentContext;
    if (context != null) {
      // 显示顶部错误提示
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating, // 浮动显示
          margin: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 0),
          duration: Duration(seconds: 3),
          dismissDirection: DismissDirection.horizontal, // 允许左右滑动关闭
        ),
      );
    }
  }
}

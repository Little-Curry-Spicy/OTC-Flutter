import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_application/api/api_service.dart';

/// API使用示例
/// 展示如何在Flutter中使用API服务
class ApiExample {
  /// 登录示例
  static Future<void> loginExample() async {
    try {
      final response = await ApiService.login({
        'username': 'test@example.com',
        'password': '123456',
      });

      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        log('登录成功: ${data['data']}');
        
        // TODO: 保存token到本地存储
        // final token = data['data']['token'];
        // await SharedPreferences.getInstance().then((prefs) {
        //   prefs.setString('token', token);
        // });
      }
    } catch (e) {
      log('登录失败: $e');
    }
  }

  /// 获取用户信息示例
  static Future<void> getUserInfoExample() async {
    try {
      final response = await ApiService.getUserInfo();
      
      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        log('用户信息: ${data['data']}');
      }
    } catch (e) {
      log('获取用户信息失败: $e');
    }
  }

  /// 获取广告列表示例
  static Future<void> getAdListExample() async {
    try {
      final response = await ApiService.getSaleAdList({
        'page': 1,
        'pageSize': 10,
        'currency': 'CNY',
      });
      
      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        log('广告列表: ${data['data']}');
      }
    } catch (e) {
      log('获取广告列表失败: $e');
    }
  }

  /// 上传图片示例
  static Future<void> uploadImageExample(String imagePath) async {
    try {
      final response = await ApiService.uploadImage(imagePath);
      
      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        final imageUrl = data['data']['url'];
        log('图片上传成功: $imageUrl');
      }
    } catch (e) {
      log('图片上传失败: $e');
    }
  }

  /// 在Widget中使用API的示例
  static Widget buildExampleWidget() {
    return FutureBuilder(
      future: ApiService.getIndexInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        
        if (snapshot.hasError) {
          return Text('加载失败: ${snapshot.error}');
        }
        
        if (snapshot.hasData) {
          final response = snapshot.data!;
          if (response.data is Map<String, dynamic>) {
            final data = response.data as Map<String, dynamic>;
            return Text('首页数据: ${data['data']}');
          }
        }
        
        return Text('暂无数据');
      },
    );
  }
}


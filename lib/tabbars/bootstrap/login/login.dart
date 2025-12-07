import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_application/api/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  String _selectedLanguage = 'zh-CN'; // 默认中文

  @override
  void initState() {
    super.initState();
    // 在初始化时设置默认值
    _emailController.text = '2939117014@qq.com';
    _passwordController.text = '123456';
  }

  @override
  void dispose() {
    // 释放资源
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(maxWidth: 400),
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    autofocus: true,
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'Enter your email',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          !value.contains('@')) {
                        return 'Email is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    // 启用实时校验模式
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                    ),
                    validator: (value) {
                      // 如果密码为空，返回必填提示
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      return null;
                    },
                    obscureText: !_isPasswordVisible,
                  ),
                  SizedBox(height: 20),
                  // 语言选择器
                  DropdownButtonFormField<String>(
                    initialValue: _selectedLanguage,
                    dropdownColor: Colors.white,
                    decoration: InputDecoration(
                      labelText: 'Language',
                      hintText: 'Select language',
                      prefixIcon: Icon(Icons.language),
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      DropdownMenuItem(value: 'zh-CN', child: Text('中文')),
                      DropdownMenuItem(value: 'en-US', child: Text('English')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedLanguage = value;
                        });
                      }
                    },
                  ),
                  // 使用SizedBox让按钮占满宽度
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            // 显示加载提示
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder:
                                  (context) => Center(
                                    child: CircularProgressIndicator(),
                                  ),
                            );

                            // 发送登录请求
                            final response = await ApiService.login({
                              'email': _emailController.text,
                              'password': _passwordController.text,
                              'language': _selectedLanguage,
                            });

                            // 关闭加载提示
                            Navigator.of(context).pop();

                            // 如果代码执行到这里，说明请求成功（拦截器已经处理了错误）
                            final data = response.data;
                            if (data is Map<String, dynamic> &&
                                data['code'] == 0) {
                              // 登录成功，存储token
                              final token = data['data']?['token'];
                              if (token != null) {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.setString('token', token);
                              }

                              // 跳转到主页面
                              if (context.mounted) {
                                Navigator.pushReplacementNamed(
                                  context,
                                  '/tabbar',
                                );
                              }
                            }
                          } catch (e) {
                            // 关闭加载提示
                            if (context.mounted) {
                              Navigator.of(context).pop();
                            }
                            // 错误已经在拦截器中处理并提示，这里只需要记录日志
                            log('登录错误: $e');
                          }
                        }
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        child: Text(
                          'Forgot password?',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        onPressed: () {
                          log('Forgot password? pressed');
                        },
                      ),
                      TextButton(
                        child: Text(
                          'Register',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        onPressed: () {
                          log('Register pressed');
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application/api/api_service.dart';

class HomeMain extends StatefulWidget {
  const HomeMain({super.key});

  @override
  State<HomeMain> createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain> {
  Map<String, double>? _indexData = {'balance': 0, 'commission': 0};

  @override
  void initState() {
    super.initState();
    _loadIndexInfo();
  }

  Future<void> _loadIndexInfo() async {
    try {
      final response = await ApiService.getIndexInfo();
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic> && data['code'] == 0) {
          setState(() {
            _indexData = data['data'];
          });
        }
      }
    } catch (e) {
      log('获取首页数据失败: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade200, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // 返佣账户行
            _buildAccountRow(
              accountName: '返佣账户',
              balance: '${_indexData?['commission']} USDT',
              onTap: () {
                // TODO: 跳转到返佣账户详情
              },
            ),
            // 分隔线
            Divider(
              height: 1,
              thickness: 1,
              color: Colors.grey.shade100,
              indent: 16,
              endIndent: 16,
            ),
            // 交易账户行
            _buildAccountRow(
              accountName: '交易账户',
              balance: '${_indexData?['balance']} USDT',
              onTap: () {
                // TODO: 跳转到交易账户详情
              },
            ),
          ],
        ),
      ),
    );
  }

  // 构建账户行组件
  Widget _buildAccountRow({
    required String accountName,
    required String balance,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 账户名称
            Text(
              accountName,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            // 余额和箭头
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  balance,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

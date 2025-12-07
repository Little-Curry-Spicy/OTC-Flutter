import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application/api/api_service.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  // 模拟订单数据
  List<Map<String, dynamic>> _orders = [];

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  void _loadOrders() async {
    try {
      final response = await ApiService.getCommissionList({'count': 8});
      log('load: $response');

      // 检查响应数据
      if (response.data is Map<String, dynamic>) {
        final responseData = response.data as Map<String, dynamic>;

        // 检查业务状态码
        final code = responseData['code'];
        if (code == 0) {
          // 获取数据列表
          final data = responseData['data'];
          if (data is List) {
            setState(() {
              _orders = List<Map<String, dynamic>>.from(data);
            });
          }
        }
      }
    } catch (e) {
      log('加载订单失败: $e');
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
        child:
            _orders.isNotEmpty
                ? Column(
                  children: List.generate(_orders.length, (index) {
                    final order = _orders[index];
                    final isLast = index == _orders.length - 1;

                    return Column(
                      children: [
                        _buildOrderItem(order),
                        if (!isLast)
                          Divider(
                            height: 1,
                            thickness: 1,
                            color: Colors.grey.shade100,
                            indent: 16,
                            endIndent: 16,
                          ),
                      ],
                    );
                  }),
                )
                : SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: Center(child: Text('暂无数据')),
                ),
      ),
    );
  }

  // 构建订单项
  Widget _buildOrderItem(Map<String, dynamic> order) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 左侧图标
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.wallet,
              color: Theme.of(context).primaryColor,
              size: 22,
            ),
          ),
          SizedBox(width: 12),
          // 中间订单信息
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 订单号
                Text(
                  '订单号：${order['orderNo'] ?? '未知'}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 8),
                // 订单金额
                Text(
                  '订单金额：${order['orderAmount'] ?? '0'}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12),
          // 右侧金额和时间
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // 金额
              Text(
                '${order['quantity'] ?? '0'}U',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                  height: 1.2,
                ),
              ),
              SizedBox(height: 8),
              // 日期和时间
              Text(
                '${order['postOn'] ?? ''}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

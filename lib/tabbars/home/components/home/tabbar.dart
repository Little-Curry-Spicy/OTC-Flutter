import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application/api/api_service.dart';

class HomeTabbar extends StatefulWidget {
  const HomeTabbar({super.key});

  @override
  State<HomeTabbar> createState() => _HomeTabbarState();
}

class _HomeTabbarState extends State<HomeTabbar> {
  // 当前选中的tab索引（0: 今日, 1: 昨日, 2: 本月）
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _onTabTap(0);
  }

  // Tab选项列表
  final List<String> _tabs = ['今日', '昨日', '本月'];
  Map<String, double> _currentData = {'total': 0, 'count': 0};
  Future<void> _onTabTap(int index) async {
    try {
      final response = await ApiService.getCommissionStats({'type': index + 1});
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic> && data['code'] == 0) {
          final responseData = data['data'];
          if (responseData is Map<String, dynamic>) {
            setState(() {
              _currentData = {
                'total': (responseData['total'])?.toDouble() ?? 0.0,
                'count': (responseData['count'] as num?)?.toDouble() ?? 0.0,
              };
              _selectedIndex = index;
              log('数据更新成功: $_currentData');
            });
          }
        }
      }
    } catch (e) {
      log('加载统计数据失败: $e');
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
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: List.generate(_tabs.length, (index) {
                bool isSelected = _selectedIndex == index;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => _onTabTap(index),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      padding: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? Theme.of(context).primaryColor
                                : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _tabs[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color:
                              isSelected ? Colors.white : Colors.grey.shade700,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            SizedBox(height: 16),
            // 数据卡片
            Row(
              children: [
                // 订单预估收入卡片
                Expanded(
                  child: _buildDataCard(
                    value: _currentData['total']!,
                    label: '订单预估收入',
                  ),
                ),
                SizedBox(width: 12),
                // 订单数量卡片
                Expanded(
                  child: _buildDataCard(
                    value: _currentData['count']!,
                    label: '订单数量',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 构建数据卡片
  Widget _buildDataCard({required double value, required String label}) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade100, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              height: 1.2,
            ),
          ),
          SizedBox(height: 8),
          Text(
            label.toString(),
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

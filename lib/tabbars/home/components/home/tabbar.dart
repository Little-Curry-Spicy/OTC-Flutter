import 'package:flutter/material.dart';

class HomeTabbar extends StatefulWidget {
  const HomeTabbar({super.key});

  @override
  State<HomeTabbar> createState() => _HomeTabbarState();
}

class _HomeTabbarState extends State<HomeTabbar> {
  // 当前选中的tab索引（0: 今日, 1: 昨日, 2: 本月）
  int _selectedIndex = 0;

  // 模拟数据，根据选中的tab显示不同的数据
  final Map<String, Map<String, String>> _data = {
    '今日': {'income': '¥0', 'quantity': '0'},
    '昨日': {'income': '¥100', 'quantity': '5'},
    '本月': {'income': '¥5000', 'quantity': '120'},
  };

  // Tab选项列表
  final List<String> _tabs = ['今日', '昨日', '本月'];

  @override
  Widget build(BuildContext context) {
    // 获取当前选中的tab对应的数据
    String currentTab = _tabs[_selectedIndex];
    final Map<String, String> currentData = _data[currentTab]!;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade200, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // 自定义Tab选择器
            Row(
              children: List.generate(_tabs.length, (index) {
                bool isSelected = _selectedIndex == index;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
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
                    value: currentData['income']!,
                    label: '订单预估收入',
                  ),
                ),
                SizedBox(width: 12),
                // 订单数量卡片
                Expanded(
                  child: _buildDataCard(
                    value: currentData['quantity']!,
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
  Widget _buildDataCard({required String value, required String label}) {
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
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              height: 1.2,
            ),
          ),
          SizedBox(height: 8),
          Text(
            label,
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

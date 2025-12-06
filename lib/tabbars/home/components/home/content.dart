import 'package:flutter/material.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  // 模拟订单数据
  final List<Map<String, String>> _orders = List.generate(
    10,
    (index) => {
      'orderNo': '1234567890${index.toString().padLeft(2, '0')}',
      'amount': '${1000000 + index * 1000} USDT',
      'price': '${0.9 + index * 0.1}',
      'date': '2025-10-11',
      'time': '${10 + index}:00:00',
    },
  );

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
        ),
      ),
    );
  }

  // 构建订单项
  Widget _buildOrderItem(Map<String, String> order) {
    return InkWell(
      onTap: () {
        // TODO: 跳转到订单详情
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
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
                    '订单号：${order['orderNo']!}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 8),
                  // 订单金额
                  Text(
                    '订单金额：${order['amount']!}',
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
                  '￥${order['price']!}',
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
                  '${order['date']!} ${order['time']!}',
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
      ),
    );
  }
}

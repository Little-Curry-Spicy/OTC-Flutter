import 'dart:async';
import 'package:flutter/material.dart';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  // 当前选中的订单状态（0: 进行中, 1: 未完成, 2: 已完成）
  int _selectedStatus = 1;

  // 是否自动刷新
  bool _autoRefresh = false;

  // 刷新倒计时
  int _refreshCountdown = 15;

  // 定时器
  Timer? _refreshTimer;
  Timer? _countdownTimer;

  // 订单状态列表
  final List<String> _statusList = ['进行中', '未完成', '已完成'];

  // 模拟订单数据
  final List<Map<String, dynamic>> _allOrders = List.generate(
    15,
    (index) => {
      'orderNo': 'payin${745233207292727296 + index}',
      'timestamp':
          '2025-08-18 ${10 + index % 12}:${50 + index % 10}:${42 + index % 18}',
      'price': (6.8 + index * 0.1).toStringAsFixed(2),
      'quantity': (100 + index * 10).toStringAsFixed(2),
      'amount': (100 + index * 50).toString(),
      'kycName': index % 3 == 0 ? '' : '用户${index + 1}',
      'actualAmount': (100.0 + index * 50).toStringAsFixed(2),
      'status': index % 3, // 0: 进行中, 1: 未完成, 2: 已完成
      'statusText':
          index % 3 == 0
              ? '交易进行中'
              : index % 3 == 1
              ? '交易已过期'
              : '交易已完成',
      'currency': ['CNY', 'HKD', 'USD'][index % 3],
    },
  );

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _countdownTimer?.cancel();
    super.dispose();
  }

  // 开始倒计时
  void _startCountdown() {
    if (_autoRefresh) {
      _countdownTimer?.cancel();
      _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          if (_refreshCountdown > 0) {
            _refreshCountdown--;
          } else {
            _refreshCountdown = 15;
            _refreshOrders();
          }
        });
      });
    }
  }

  // 刷新订单
  void _refreshOrders() {
    // TODO: 实际刷新逻辑
    setState(() {
      // 刷新数据
    });
  }

  // 获取当前状态的订单列表
  List<Map<String, dynamic>> get _filteredOrders {
    return _allOrders
        .where((order) => order['status'] == _selectedStatus)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('订单'),
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        shape: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      body: Column(
        children: [
          // 顶部状态选择和刷新设置
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200, width: 1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 订单状态选择
                Row(
                  children: [
                    Text(
                      '订单状态: ',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    SizedBox(width: 8),
                    ...List.generate(_statusList.length, (index) {
                      final isSelected = _selectedStatus == index;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedStatus = index;
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 8),
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isSelected
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            _statusList[index],
                            style: TextStyle(
                              fontSize: 14,
                              color:
                                  isSelected
                                      ? Colors.white
                                      : Colors.grey.shade700,
                              fontWeight:
                                  isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
                // 自动刷新开关
                Row(
                  children: [
                    Text(
                      _autoRefresh ? '$_refreshCountdown秒后刷新' : '15秒后刷新',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(width: 8),
                    Switch(
                      value: _autoRefresh,
                      onChanged: (value) {
                        setState(() {
                          _autoRefresh = value;
                          if (value) {
                            _refreshCountdown = 15;
                            _startCountdown();
                          } else {
                            _countdownTimer?.cancel();
                          }
                        });
                      },
                      activeColor: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // 订单列表
          Expanded(
            child:
                _filteredOrders.isEmpty
                    ? Center(
                      child: Text(
                        '暂无订单',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    )
                    : SingleChildScrollView(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: List.generate(_filteredOrders.length, (
                          index,
                        ) {
                          final order = _filteredOrders[index];
                          return Padding(
                            padding: EdgeInsets.only(bottom: 12),
                            child: _buildOrderCard(order),
                          );
                        }),
                      ),
                    ),
          ),
        ],
      ),
    );
  }

  // 构建订单卡片
  Widget _buildOrderCard(Map<String, dynamic> order) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/order_detail', arguments: order);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 顶部：订单编号和时间
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '订单编号: ${order['orderNo']}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        order['timestamp'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                // 状态标签
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(
                      order['status'],
                    ).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    order['statusText'],
                    style: TextStyle(
                      fontSize: 12,
                      color: _getStatusColor(order['status']),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            Divider(height: 20, thickness: 1, color: Colors.grey.shade100),
            // 订单详情
            _buildOrderDetailRow(
              '交易价格',
              '${order['currency']}${order['price']}',
            ),
            SizedBox(height: 8),
            _buildOrderDetailRow('交易数量', '${order['quantity']}'),
            SizedBox(height: 8),
            _buildOrderDetailRow('交易金额', '${order['amount']}'),
            SizedBox(height: 8),
            _buildOrderDetailRow(
              'KYC姓名',
              order['kycName'].toString().isEmpty ? '未填写' : order['kycName'],
            ),
            SizedBox(height: 8),
            _buildOrderDetailRow(
              '实际到账金额',
              '${order['actualAmount']}',
              isHighlight: true,
            ),
          ],
        ),
      ),
    );
  }

  // 构建订单详情行
  Widget _buildOrderDetailRow(
    String label,
    String value, {
    bool isHighlight = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$label:',
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            color:
                isHighlight ? Theme.of(context).primaryColor : Colors.black87,
            fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  // 获取状态颜色
  Color _getStatusColor(int status) {
    switch (status) {
      case 0:
        return Colors.blue; // 进行中
      case 1:
        return Colors.red; // 未完成/已过期
      case 2:
        return Colors.green; // 已完成
      default:
        return Colors.grey;
    }
  }
}

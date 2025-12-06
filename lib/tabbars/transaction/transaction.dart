import 'dart:developer';

import 'package:flutter/material.dart';

class Transaction extends StatefulWidget {
  const Transaction({super.key});

  @override
  State<Transaction> createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  // 选中的法币
  String _selectedCurrency = 'CNY';

  // 选中的支付方式（-1表示全部）
  int _selectedPaymentType = -1;

  // 法币列表
  final List<String> _currencies = ['CNY', 'HKD', 'USD', 'THB', 'VND'];

  // 支付方式列表（-1表示全部）
  final List<Map<String, dynamic>> _paymentOptions = [
    {'value': -1, 'name': '全部'},
    {'value': 0, 'name': '支付宝'},
    {'value': 1, 'name': '微信'},
    {'value': 2, 'name': '银行卡'},
  ];

  // 获取支付方式名称
  String _getPaymentName(int type) {
    switch (type) {
      case 0:
        return '支付宝';
      case 1:
        return '微信';
      case 2:
        return '银行卡';
      default:
        return '未知';
    }
  }

  // 获取支付方式颜色
  Color _getPaymentColor(int type) {
    switch (type) {
      case 0:
        return Color(0xFF1677FF); // 支付宝蓝
      case 1:
        return Color(0xFF07C160); // 微信绿
      case 2:
        return Color(0xFF1890FF); // 银行卡蓝
      default:
        return Colors.grey;
    }
  }

  // 获取法币符号
  String _getCurrencySymbol(String currency) {
    switch (currency) {
      case 'CNY':
        return '¥';
      case 'HKD':
        return 'HK\$';
      case 'USD':
        return '\$';
      case 'THB':
        return '฿';
      case 'VND':
        return '₫';
      default:
        return '¥';
    }
  }

  @override
  Widget build(BuildContext context) {
    // 生成所有交易数据
    final List<Map<String, dynamic>> allTransactions = List.generate(
      20,
      (index) => {
        'merchant': '商户${index + 1}',
        'currency': ['CNY', 'HKD', 'USD', 'THB', 'VND'][index % 5], // 法币
        'price': (6.8 + index * 0.1).toStringAsFixed(2),
        'min': '${100 + index * 50}',
        'max': '${10000 + index * 1000}',
        'volume': '${100000 + index * 5000}',
        'usdtAmount': '${10000 + index * 1000}', // USDT数量
        // 支持多个支付方式，不同商户有不同的支付方式组合
        'paymentTypes':
            [
              if (index % 3 == 0) [0, 1], // 支付宝+微信
              if (index % 3 == 1) [1, 2], // 微信+银行卡
              if (index % 3 == 2) [0, 1, 2], // 全部三种
            ].first,
        'rating': 4.5 + (index % 5) * 0.1, // 评分
        'orders': 100 + index * 10, // 订单数
      },
    );

    // 根据筛选条件过滤数据
    final List<Map<String, dynamic>> filteredTransactions =
        allTransactions.where((transaction) {
          // 法币筛选
          if (transaction['currency'] != _selectedCurrency) {
            return false;
          }
          // 支付方式筛选
          if (_selectedPaymentType != -1) {
            final List<int> paymentTypes = List<int>.from(
              transaction['paymentTypes'],
            );
            if (!paymentTypes.contains(_selectedPaymentType)) {
              return false;
            }
          }
          return true;
        }).toList();

    // 计算汇率显示
    final double exchangeRate = 6.96;

    return Scaffold(
      appBar: AppBar(
        title: Text('交易市场', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        shape: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: InkWell(
              onTap: () {
                log('跳转到历史记录页面');
                // TODO: 跳转到历史记录页面
              },
              child: Text(
                '历史记录',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Column(
        children: [
          // 筛选栏
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200, width: 1),
              ),
            ),
            child: Column(
              children: [
                // 汇率显示
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '1 USDT ≈ $exchangeRate $_selectedCurrency',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                // 筛选选项
                Row(
                  children: [
                    // 法币选择
                    Expanded(
                      child: _buildFilterButton(
                        label: _selectedCurrency,
                        onTap: () => _showCurrencyDialog(context),
                      ),
                    ),
                    SizedBox(width: 12),
                    // 支付方式选择
                    Expanded(
                      child: _buildFilterButton(
                        label:
                            _selectedPaymentType == -1
                                ? '全部'
                                : _getPaymentName(_selectedPaymentType),
                        onTap: () => _showPaymentDialog(context),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // 交易列表
          Expanded(
            child:
                filteredTransactions.isEmpty
                    ? Center(
                      child: Text(
                        '暂无数据',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    )
                    : SingleChildScrollView(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        children: List.generate(filteredTransactions.length, (
                          index,
                        ) {
                          final transaction = filteredTransactions[index];
                          final isLast =
                              index == filteredTransactions.length - 1;

                          return Padding(
                            padding: EdgeInsets.only(
                              left: 16,
                              right: 16,
                              bottom: isLast ? 16 : 8,
                            ),
                            child: _buildTransactionCard(context, transaction),
                          );
                        }),
                      ),
                    ),
          ),
        ],
      ),
    );
  }

  // 构建筛选按钮
  Widget _buildFilterButton({
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
            Icon(Icons.arrow_drop_down, color: Colors.grey.shade600, size: 20),
          ],
        ),
      ),
    );
  }

  // 显示法币选择对话框
  void _showCurrencyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('法币列表'),
          content: SingleChildScrollView(
            child: Column(
              // mainAxisSize: MainAxisSize.min 的意思是让列的主轴尺寸尽量小，仅包裹其子内容，而不是占满可用空间
              mainAxisSize: MainAxisSize.min,
              children:
                  _currencies.map((currency) {
                    final isSelected = currency == _selectedCurrency;
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _selectedCurrency = currency;
                        });
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? Theme.of(
                                    context,
                                  ).primaryColor.withValues(alpha: 0.1)
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              currency,
                              style: TextStyle(
                                fontSize: 16,
                                color:
                                    isSelected
                                        ? Theme.of(context).primaryColor
                                        : Colors.black87,
                                fontWeight:
                                    isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                              ),
                            ),
                            if (isSelected)
                              Icon(
                                Icons.check,
                                color: Theme.of(context).primaryColor,
                                size: 20,
                              ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),
        );
      },
    );
  }

  // 显示支付方式选择对话框
  void _showPaymentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('支付方式'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children:
                  _paymentOptions.map((option) {
                    final isSelected = option['value'] == _selectedPaymentType;
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _selectedPaymentType = option['value'] as int;
                        });
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? Theme.of(
                                    context,
                                  ).primaryColor.withValues(alpha: 0.1)
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              option['name'] as String,
                              style: TextStyle(
                                fontSize: 16,
                                color:
                                    isSelected
                                        ? Theme.of(context).primaryColor
                                        : Colors.black87,
                                fontWeight:
                                    isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                              ),
                            ),
                            if (isSelected)
                              Icon(
                                Icons.check,
                                color: Theme.of(context).primaryColor,
                                size: 20,
                              ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),
        );
      },
    );
  }

  // 构建交易卡片
  Widget _buildTransactionCard(
    BuildContext context,
    Map<String, dynamic> transaction,
  ) {
    final List<int> paymentTypes = List<int>.from(transaction['paymentTypes']);

    return InkWell(
      onTap: () {
        // TODO: 跳转到交易详情
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
            // 顶部：商户名称和支付方式
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  transaction['merchant'] as String,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                // 多个支付方式标签
                Wrap(
                  spacing: 6,
                  children:
                      paymentTypes.map((type) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getPaymentColor(
                              type,
                            ).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            _getPaymentName(type),
                            style: TextStyle(
                              fontSize: 12,
                              color: _getPaymentColor(type),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ],
            ),
            SizedBox(height: 16),
            Divider(height: 1, color: Colors.grey.shade100),
            SizedBox(height: 16),
            // 价格信息
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '价格',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${_getCurrencySymbol(transaction['currency'] as String)}${transaction['price']}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '限额',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${_getCurrencySymbol(transaction['currency'] as String)}${transaction['min']}-${_getCurrencySymbol(transaction['currency'] as String)}${transaction['max']}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 12),
            Divider(height: 1, color: Colors.grey.shade100),
            SizedBox(height: 12),
            // USDT数量和成交量
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '数量：${transaction['usdtAmount']} USDT',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                Text(
                  '成交量：${transaction['volume']}',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 构建悬浮按钮
  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: () {
        Navigator.pushNamed(context, '/publish');
      },
      label: Text("一键发布"),
    );
  }
}

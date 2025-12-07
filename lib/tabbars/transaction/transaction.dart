import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application/api/api_service.dart';
import 'package:flutter_application/components/selectCurrency/selectCurrency.dart';
import 'package:flutter_application/components/selectPayment/selectPayment.dart';
import 'package:flutter_application/tabbars/transaction/saleAdModel.dart';
import 'package:flutter_application/tabbars/transaction/components/transaction_card.dart';
import 'package:flutter_application/tabbars/transaction/components/transaction_action_button.dart';

class Transaction extends StatefulWidget {
  const Transaction({super.key});

  @override
  State<Transaction> createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  List<SaleAdModel> _transactions = [];
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
    });
    _loadTransactions();
  }

  void _loadTransactions() async {
    setState(() {
      _isLoading = true;
    });
    try {
      // 构建请求参数，如果选择"全部"则不传递 paymentType
      final Map<String, dynamic> params = {'currency': _selectedCurrency};
      // 只有当不是"全部"时才添加 paymentType 参数
      if (_selectedPaymentType != -1) {
        params['paymentType'] = _selectedPaymentType;
      }

      final response = await ApiService.getSaleAdList(params);
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic> && data['code'] == 0) {
          final responseData = data['data'];
          if (responseData is Map<String, dynamic>) {
            final items = responseData['items'];
            if (items is List) {
              setState(() {
                _transactions =
                    items
                        .map(
                          (item) => SaleAdModel.fromJson(
                            item as Map<String, dynamic>,
                          ),
                        )
                        .toList();
                log('交易数据加载成功: ${_transactions.length} 条');
              });
            } else {
              log('数据格式错误: items 不是 List 类型');
            }
          }
        }
      }
    } catch (e) {
      log('加载交易数据失败: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // 选中的法币
  String _selectedCurrency = 'CNY';

  // 选中的支付方式（-1表示全部）
  int _selectedPaymentType = -1;

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

  @override
  Widget build(BuildContext context) {
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
      floatingActionButton: buildFloatingActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  // 筛选栏
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.shade200,
                          width: 1,
                        ),
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
                        _transactions.isEmpty
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
                                children: List.generate(_transactions.length, (
                                  index,
                                ) {
                                  final transaction = _transactions[index];
                                  final isLast =
                                      index == _transactions.length - 1;
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      left: 16,
                                      right: 16,
                                      bottom: isLast ? 16 : 8,
                                    ),
                                    child: TransactionCard(
                                      transaction: transaction,
                                      onTap: () {
                                        // TODO: 跳转到交易详情
                                      },
                                    ),
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
  void _showCurrencyDialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SelectCurrency(
          context: context,
          selectedCurrency: _selectedCurrency,
          onSelected: (String currency) {
            setState(() {
              _selectedCurrency = currency;
            });
            // 法币选择后重新加载数据
            _loadTransactions();
          },
        );
      },
    );
  }

  // 显示支付方式选择对话框
  void _showPaymentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SelectPayment(
          context: context,
          selectedPayment: _selectedPaymentType,
          onSelected: (Map<String, dynamic> payment) {
            setState(() {
              _selectedPaymentType = payment['value'];
            });
            // 支付方式选择后重新加载数据
            _loadTransactions();
          },
        );
      },
    );
  }
}

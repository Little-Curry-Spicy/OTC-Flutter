import 'package:flutter/material.dart';
import 'package:flutter_application/tabbars/transaction/saleAdModel.dart';

/// 交易卡片组件
/// 用于显示单个交易广告的详细信息
class TransactionCard extends StatelessWidget {
  final SaleAdModel transaction;
  final VoidCallback? onTap;

  const TransactionCard({super.key, required this.transaction, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:
          onTap ??
          () {
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
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 顶部：商户名称和支付方式
            _buildHeader(context),
            SizedBox(height: 16),
            // 价格和限额信息
            _buildPriceSection(context),
            SizedBox(height: 12),
            Divider(height: 1, color: Colors.grey.shade100),
            SizedBox(height: 12),
            // 数量和成交量
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  /// 构建头部（商户名称和支付方式）
  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 商户名称
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.nickName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 12),
        // 支付方式标签
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children:
              transaction.paymentTypes.map<Widget>((int type) {
                return _buildPaymentTag(type);
              }).toList(),
        ),
      ],
    );
  }

  /// 构建支付方式标签
  Widget _buildPaymentTag(int type) {
    final paymentInfo = _getPaymentInfo(type);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: paymentInfo['color'].withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: paymentInfo['color'].withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            paymentInfo['icon'] as IconData,
            size: 14,
            color: paymentInfo['color'] as Color,
          ),
          SizedBox(width: 4),
          Text(
            paymentInfo['name'] as String,
            style: TextStyle(
              fontSize: 12,
              color: paymentInfo['color'] as Color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建价格部分
  Widget _buildPriceSection(BuildContext context) {
    final currencySymbol = _getCurrencySymbol(transaction.currency);

    return Row(
      children: [
        // 价格
        Expanded(
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '单价',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      transaction.price,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                        height: 1.0,
                      ),
                    ),
                    SizedBox(width: 4),
                    Padding(
                      padding: EdgeInsets.only(bottom: 2),
                      child: Text(
                        transaction.currency,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 12),
        // 限额
        Expanded(
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '限额',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  '$currencySymbol${transaction.minimum.toStringAsFixed(0)}-$currencySymbol${transaction.maximum.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// 构建底部信息
  Widget _buildFooter(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 可用数量
        _buildInfoItem(
          icon: Icons.account_balance_wallet_outlined,
          label: '可用',
          value: '${transaction.remaining.toStringAsFixed(2)} USDT',
          color: Colors.blue,
        ),
        SizedBox(width: 16),
        // 成交量
        _buildInfoItem(
          icon: Icons.trending_up,
          label: '成交量',
          value: transaction.volume.toStringAsFixed(2),
          color: Colors.green,
        ),
      ],
    );
  }

  /// 构建信息项
  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
                SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 获取支付方式信息
  Map<String, dynamic> _getPaymentInfo(int type) {
    switch (type) {
      case 1: // BANK
        return {
          'name': '银行卡',
          'color': Color(0xFFE53E3E), // 红色
          'icon': Icons.account_balance,
        };
      case 2: // WECHAT
        return {
          'name': '微信',
          'color': Color(0xFF07C160),
          'icon': Icons.chat_bubble_outline,
        };
      case 3: // ALIPAY
        return {
          'name': '支付宝',
          'color': Color(0xFF1677FF),
          'icon': Icons.payment,
        };
      default:
        return {'name': '未知', 'color': Colors.grey, 'icon': Icons.help_outline};
    }
  }

  /// 获取法币符号
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
}

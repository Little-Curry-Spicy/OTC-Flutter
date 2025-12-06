import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OrderDetailPage extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderDetailPage({super.key, required this.order});

  // 复制到剪贴板
  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('已复制到剪贴板'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('销售订单'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 订单详情卡片
            _buildDetailCard(
              title: '订单详情',
              children: [
                _buildDetailRow(
                  context,
                  label: '订单编号',
                  value: order['orderNo'] ?? '',
                  showCopy: true,
                ),
                SizedBox(height: 12),
                _buildDetailRow(
                  context,
                  label: '交易金额(${order['currency'] ?? 'CNY'})',
                  value: order['amount'] ?? '0',
                ),
                SizedBox(height: 12),
                _buildDetailRow(
                  context,
                  label: 'KYC姓名',
                  value: (order['kycName'] ?? '').toString().isEmpty
                      ? '未填写'
                      : order['kycName'],
                ),
                SizedBox(height: 12),
                _buildDetailRow(
                  context,
                  label: '付款人姓名',
                  value: (order['payerName'] ?? '').toString().isEmpty
                      ? '未填写'
                      : order['payerName'],
                ),
                SizedBox(height: 12),
                _buildDetailRow(
                  context,
                  label: '交易数量(USDT)',
                  value: order['quantity'] ?? '0',
                ),
                SizedBox(height: 12),
                _buildDetailRow(
                  context,
                  label: '交易价格(${order['currency'] ?? 'CNY'})',
                  value: order['price'] ?? '0',
                ),
                SizedBox(height: 12),
                _buildDetailRow(
                  context,
                  label: '交易时间',
                  value: order['timestamp'] ?? '',
                ),
                SizedBox(height: 12),
                _buildDetailRow(
                  context,
                  label: '实际到账金额',
                  value: order['actualAmount'] ?? '0.00',
                  isHighlight: true,
                ),
              ],
            ),
            SizedBox(height: 16),
            // 支付信息卡片
            _buildDetailCard(
              title: '支付信息',
              children: [
                _buildDetailRow(
                  context,
                  label: '用户名',
                  value: (order['username'] ?? '').toString().isEmpty
                      ? '未填写'
                      : order['username'],
                  showCopy: true,
                ),
                SizedBox(height: 12),
                _buildDetailRow(
                  context,
                  label: '银行名称',
                  value: (order['bankName'] ?? '').toString().isEmpty
                      ? '未填写'
                      : order['bankName'],
                ),
                SizedBox(height: 12),
                _buildDetailRow(
                  context,
                  label: '开户行信息',
                  value: (order['bankInfo'] ?? '').toString().isEmpty
                      ? '未填写'
                      : order['bankInfo'],
                ),
                SizedBox(height: 12),
                _buildDetailRow(
                  context,
                  label: '银行账号',
                  value: (order['bankAccount'] ?? '').toString().isEmpty
                      ? '未填写'
                      : order['bankAccount'],
                  showCopy: true,
                ),
              ],
            ),
            SizedBox(height: 16),
            // 交易提醒卡片
            _buildReminderCard(),
            SizedBox(height: 30),
            // 底部状态按钮
            _buildStatusButton(context),
          ],
        ),
      ),
    );
  }

  // 构建详情卡片
  Widget _buildDetailCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  // 构建详情行
  Widget _buildDetailRow(
    BuildContext context, {
    required String label,
    required String value,
    bool showCopy = false,
    bool isHighlight = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            '$label:',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  value,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontSize: 14,
                    color: isHighlight
                        ? Theme.of(context).primaryColor
                        : Colors.black87,
                    fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
              if (showCopy) ...[
                SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _copyToClipboard(context, value),
                  child: Icon(
                    Icons.copy,
                    size: 18,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  // 构建交易提醒卡片
  Widget _buildReminderCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '交易提醒',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 12),
          _buildReminderItem(
            '请您及时付款并上传付款凭证。',
          ),
          SizedBox(height: 8),
          _buildReminderItem(
            '如遇特殊情况,请及时联系客服处理。',
          ),
        ],
      ),
    );
  }

  // 构建提醒项
  Widget _buildReminderItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 6, right: 8),
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: Colors.grey.shade400,
            shape: BoxShape.circle,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  // 构建状态按钮
  Widget _buildStatusButton(BuildContext context) {
    final statusText = order['statusText'] ?? '交易已过期';
    final status = order['status'] ?? 1;
    final isDisabled = status == 1; // 未完成状态按钮禁用

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isDisabled
            ? null
            : () {
                // TODO: 根据状态执行相应操作
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: isDisabled
              ? Colors.grey.shade300
              : Theme.of(context).primaryColor,
          foregroundColor: isDisabled ? Colors.grey.shade600 : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
        ),
        child: Text(
          statusText,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}


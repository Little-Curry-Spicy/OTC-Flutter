import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_application/api/api_service.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader({super.key});

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  // 首页数据
  Map<String, dynamic>? _indexData = {
    'balance': 0,
    'latestTotalCommission': 0,
    'currency': 'CNY',
  };
  // 汇率数据
  double _rateData = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadIndexInfo();
  }

  // 加载首页数据
  Future<void> _loadIndexInfo() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final response = await ApiService.getIndexInfo();

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic> && data['code'] == 0) {
          setState(() {
            _indexData = data['data'];
            _loadRate(_indexData!['currency']);
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      log('获取首页数据失败: $e');
      setState(() {
        _isLoading = false;
      });
      // 错误已经在拦截器中处理并提示
    }
  }

  // 加载汇率数据
  Future<void> _loadRate(String currency) async {
    try {
      final response = await ApiService.getUSDTRate({'currency': currency});
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic> && data['code'] == 0) {
          setState(() {
            _rateData = data['data']['rate'] as double;
          });
        }
      }
    } catch (e) {
      log('获取汇率数据失败: $e');
    }
  }

  // 获取总资产估值
  String _getTotalAssets() {
    if (_indexData == null) return '0.00 USDT';
    final balance = _indexData!['balance'];
    if (balance == null) return '0.00 USDT';

    final value =
        balance is num ? balance.toStringAsFixed(2) : balance.toString();
    return '$value USDT';
  }

  // 获取半年收益
  String _getHalfYearEarnings() {
    if (_indexData == null) return '0.00 CNY';
    // 格式化数字，保留2位小数
    final value =
        _indexData!['latestTotalCommission'] is num
            ? _indexData!['latestTotalCommission'].toStringAsFixed(2)
            : _indexData!['latestTotalCommission'].toString();
    final numValue = (double.parse(value) * _rateData).toStringAsFixed(2);
    return '$numValue ${_indexData!['currency']}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: Color(0xFFFFF3C4), // 更明显的暖黄色背景
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset('assets/images/logo.png', width: 100, height: 60),
          SizedBox(height: 16),
          // 总资产估值
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '总资产估值',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade700,
                  height: 1.2,
                ),
              ),
              SizedBox(height: 4),
              _isLoading
                  ? SizedBox(
                    width: 120,
                    height: 24,
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.grey.shade300,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor,
                      ),
                    ),
                  )
                  : Text(
                    _getTotalAssets(),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      height: 1.2,
                      letterSpacing: 0.5,
                    ),
                  ),
            ],
          ),
          SizedBox(height: 12),
          // 半年收益
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '半年收益',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade700,
                  height: 1.2,
                ),
              ),
              SizedBox(height: 4),
              _isLoading
                  ? SizedBox(
                    width: 120,
                    height: 22,
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.grey.shade300,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor,
                      ),
                    ),
                  )
                  : Text(
                    _getHalfYearEarnings(),
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                      height: 1.2,
                      letterSpacing: 0.5,
                    ),
                  ),
            ],
          ),
          SizedBox(height: 16),
          // 操作按钮区域
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildActionButton(
                icon: Icons.arrow_downward,
                label: '充币',
                onTap: () {
                  // TODO: 跳转到充币页面
                },
              ),
              _buildActionButton(
                icon: Icons.arrow_upward,
                label: '提币',
                onTap: () {
                  // TODO: 跳转到提币页面
                },
              ),
              _buildActionButton(
                icon: Icons.swap_horiz,
                label: '划转',
                onTap: () {
                  // TODO: 跳转到划转页面
                },
              ),
              _buildActionButton(
                icon: Icons.send,
                label: '转账',
                onTap: () {
                  // TODO: 跳转到转账页面
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 构建操作按钮
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(
                      context,
                    ).primaryColor.withValues(alpha: 0.3),
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 22),
            ),
            SizedBox(height: 4),
            Text(label),
          ],
        ),
      ),
    );
  }
}

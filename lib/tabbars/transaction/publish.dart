import 'package:flutter/material.dart';

class PublishPage extends StatefulWidget {
  const PublishPage({super.key});

  @override
  State<PublishPage> createState() => _PublishPageState();
}

class _PublishPageState extends State<PublishPage> {
  // 表单Key，用于验证表单
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // 表单控制器
  final TextEditingController _premiumController = TextEditingController(
    text: '0.1',
  );
  final TextEditingController _priceController = TextEditingController(
    text: '7.89',
  );
  final TextEditingController _quantityController = TextEditingController(
    text: '0',
  );
  final TextEditingController _maxAmountController = TextEditingController(
    text: '0',
  );
  final TextEditingController _minAmountController = TextEditingController(
    text: '20',
  );

  // 地区到货币的映射
  final Map<String, String> _regionToCurrency = {
    '香港': 'HKD',
    '中国大陆': 'CNY',
    '台湾': 'TWD',
    '澳门': 'MOP',
    '新加坡': 'SGD',
  };

  // 地区到汇率的映射
  final Map<String, double> _regionToExchangeRate = {
    '香港': 7.79,
    '中国大陆': 6.96,
    '台湾': 30.5,
    '澳门': 8.0,
    '新加坡': 1.35,
  };

  // 选中的值
  String _selectedRegion = '香港';

  // 根据地区获取货币和汇率
  String get _selectedCurrency => _regionToCurrency[_selectedRegion] ?? 'HKD';
  double get _exchangeRate => _regionToExchangeRate[_selectedRegion] ?? 7.79;

  // 选中的支付方式
  final Map<int, bool> _paymentMethods = {
    0: false, // 支付宝
    1: false, // 微信
    2: true, // 银行卡（默认选中）
  };

  @override
  void dispose() {
    _premiumController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _maxAmountController.dispose();
    _minAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('发布交易广告'), elevation: 0),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 顶部提示信息
              _buildInfoSection(),
              SizedBox(height: 20),
              // 地区和货币选择（放在同一行）
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200, width: 1),
                ),
                child: Row(
                  children: [
                    // 地区选择
                    Expanded(
                      child: _buildSelectableField(
                        label: '地区',
                        value: _selectedRegion,
                        onTap: () => _showRegionDialog(context),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.grey.shade200,
                      margin: EdgeInsets.symmetric(horizontal: 12),
                    ),
                    // 货币显示（不可选择）
                    Expanded(
                      child: _buildDisplayField(
                        label: '货币',
                        value: _selectedCurrency,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // 白色背景容器，包含所有输入框
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200, width: 1),
                ),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _premiumController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 2,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        labelText: '溢价',
                        hintText: '请输入溢价',
                        prefixIcon: Icon(Icons.trending_up),
                        suffixText: '%',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '请输入溢价';
                        }
                        if (double.tryParse(value) == null) {
                          return '请输入有效的数字';
                        }
                        return null;
                      },
                    ),
                    Divider(
                      height: 20,
                      thickness: 1,
                      color: Colors.grey.shade200,
                    ),
                    // 价格输入
                    TextFormField(
                      controller: _priceController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 2,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        labelText: '价格',
                        hintText: '请输入价格',
                        prefixIcon: Icon(Icons.attach_money),
                        suffixText: 'USDT',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '请输入价格';
                        }
                        if (double.tryParse(value) == null) {
                          return '请输入有效的数字';
                        }
                        return null;
                      },
                    ),
                    Divider(
                      height: 20,
                      thickness: 1,
                      color: Colors.grey.shade200,
                    ),
                    // 数量输入
                    TextFormField(
                      controller: _quantityController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 2,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        labelText: '数量 (您将获得 0.00 $_selectedCurrency)',
                        hintText: '请输入数量',
                        prefixIcon: Icon(Icons.account_balance_wallet),
                        suffixText: 'USDT',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '请输入数量';
                        }
                        if (double.tryParse(value) == null) {
                          return '请输入有效的数字';
                        }
                        return null;
                      },
                    ),
                    Divider(
                      height: 20,
                      thickness: 1,
                      color: Colors.grey.shade200,
                    ),
                    // 最大交易金额
                    TextFormField(
                      controller: _maxAmountController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 2,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        labelText: '最大交易金额',
                        hintText: '请输入最大交易金额',
                        prefixIcon: Icon(Icons.arrow_upward),
                        suffixText: 'USDT',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '请输入最大交易金额';
                        }
                        if (double.tryParse(value) == null) {
                          return '请输入有效的数字';
                        }
                        return null;
                      },
                    ),
                    Divider(
                      height: 20,
                      thickness: 1,
                      color: Colors.grey.shade200,
                    ),
                    // 最小交易金额
                    TextFormField(
                      controller: _minAmountController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 2,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        labelText: '最小交易金额',
                        hintText: '请输入最小交易金额',
                        prefixIcon: Icon(Icons.arrow_downward),
                        suffixText: 'USDT',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '请输入最小交易金额';
                        }
                        if (double.tryParse(value) == null) {
                          return '请输入有效的数字';
                        }
                        // 验证最小金额不能大于最大金额
                        final minValue = double.tryParse(value);
                        final maxValue = double.tryParse(
                          _maxAmountController.text,
                        );
                        if (minValue != null &&
                            maxValue != null &&
                            minValue > maxValue) {
                          return '最小金额不能大于最大金额';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // 支付方式
              _buildPaymentMethodsSection(),
              SizedBox(height: 20),
              // 支付时间（固定15分钟）
              _buildPaymentTimeSection(),
              SizedBox(height: 30),
              // 发布按钮
              _buildPublishButton(context),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // 构建信息提示区域
  Widget _buildInfoSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '发布一则交易广告是免费的，请确保您的钱包中有足够的USDT',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
          ),

          SizedBox(height: 8),
          Row(
            children: [
              Text(
                '当前汇率: ',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
              ),
              Text(
                '$_exchangeRate $_selectedCurrency',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 构建可选择的字段
  Widget _buildSelectableField({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 构建只显示的字段（不可选择）
  Widget _buildDisplayField({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // 构建支付方式选择区域
  Widget _buildPaymentMethodsSection() {
    final paymentNames = {0: '支付宝', 1: '微信', 2: '银行卡'};

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '支付方式',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          SizedBox(height: 12),
          ...paymentNames.entries.map((entry) {
            return CheckboxListTile(
              value: _paymentMethods[entry.key],
              onChanged: (value) {
                setState(() {
                  _paymentMethods[entry.key] = value ?? false;
                });
              },
              title: Text(entry.value, style: TextStyle(fontSize: 16)),
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
            );
          }),
        ],
      ),
    );
  }

  // 构建支付时间区域（固定15分钟）
  Widget _buildPaymentTimeSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '支付时间',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              SizedBox(height: 4),
              Text(
                '15',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Text(
            '分',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // 构建发布按钮
  Widget _buildPublishButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          // 验证表单
          if (_formKey.currentState!.validate()) {
            // 验证支付方式至少选择一个
            final hasSelectedPayment = _paymentMethods.values.any(
              (value) => value,
            );
            if (!hasSelectedPayment) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('请至少选择一种支付方式')));
              return;
            }

            // TODO: 提交发布
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('发布成功')));
            Navigator.of(context).pop();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          '发布',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // 显示地区选择对话框
  void _showRegionDialog(BuildContext context) {
    final regions = ['香港', '中国大陆', '台湾', '澳门', '新加坡'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('选择地区'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children:
                  regions.map((region) {
                    final isSelected = region == _selectedRegion;
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _selectedRegion = region;
                          // 货币会根据地区自动更新（通过getter）
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
                              region,
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
}

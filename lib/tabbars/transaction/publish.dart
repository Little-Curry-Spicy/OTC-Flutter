import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_application/api/api_service.dart';
import 'package:flutter_application/utils/common.dart';

/// 国家/法币数据模型
class CurrencyContryData {
  String currency;
  num id;
  bool isSelect;
  String name;

  CurrencyContryData({
    required this.currency,
    required this.id,
    required this.isSelect,
    required this.name,
  });

  /// 从 JSON 创建对象
  factory CurrencyContryData.fromJson(Map<String, dynamic> json) {
    return CurrencyContryData(
      currency: json['currency']?.toString() ?? '',
      id: json['id'] as num? ?? 0,
      isSelect: json['isSelect'] as bool? ?? false,
      name: json['name']?.toString() ?? '',
    );
  }

  /// 转换为 JSON
  Map<String, dynamic> toJson() {
    return {'currency': currency, 'id': id, 'isSelect': isSelect, 'name': name};
  }
}

class PublishPage extends StatefulWidget {
  const PublishPage({super.key});

  @override
  State<PublishPage> createState() => _PublishPageState();
}

class _PublishPageState extends State<PublishPage> {
  // 表单Key，用于验证表单
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // 常量
  static const double LIMIT_MINIMUM = 20.0;
  static const double LIMIT_MAXIMUM = 30000.0;

  // 表单控制器
  final TextEditingController _premiumController = TextEditingController(
    text: '0.1',
  );
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _maxAmountController = TextEditingController();
  final TextEditingController _minAmountController = TextEditingController(
    text: '20',
  );

  // 状态变量
  bool _isLoading = false;
  double _rate = 0.0; // 汇率
  double _maxQuantity = 0.0; // 最大可用数量
  String _selectedLocation = ''; // 选中的位置/国家
  String _selectedCurrency = ''; // 选中的法币
  String _paymentTime = '15'; // 支付时间（分钟）

  // 国家/法币列表
  List<CurrencyContryData> _countryCurrencyList = [];

  // 支付方式（使用 paymentTypeMap 的值：1=银行卡, 2=微信, 3=支付宝）
  final Map<int, bool> _paymentTypes = {
    1: false, // 银行卡
    2: false, // 微信
    3: false, // 支付宝
  };

  // 用户信息
  Map<String, dynamic>? _userInfo;

  @override
  void initState() {
    super.initState();
    _getCountryCurrencyList();
  }

  @override
  void dispose() {
    _premiumController.dispose();
    _quantityController.dispose();
    _maxAmountController.dispose();
    _minAmountController.dispose();
    super.dispose();
  }

  // 获取国家/法币列表
  Future<void> _getCountryCurrencyList() async {
    try {
      final response = await ApiService.getCountryCurrencyList();

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          // 使用 CommonResponse 解析响应
          final commonResponse = CommonResponse<
            List<CurrencyContryData>
          >.fromJson(data, (jsonData) {
            if (jsonData is List) {
              return jsonData
                  .map(
                    (item) => CurrencyContryData.fromJson(
                      item as Map<String, dynamic>,
                    ),
                  )
                  .toList();
            }
            return <CurrencyContryData>[];
          });

          if (commonResponse.code == 0) {
            setState(() {
              _countryCurrencyList = commonResponse.data;

              // 设置默认选中的国家/法币
              final defaultItem = _countryCurrencyList.firstWhere(
                (item) => item.isSelect,
                orElse:
                    () =>
                        _countryCurrencyList.isNotEmpty
                            ? _countryCurrencyList.first
                            : CurrencyContryData(
                              currency: '',
                              id: 0,
                              isSelect: false,
                              name: '',
                            ),
              );

              if (defaultItem.name.isNotEmpty) {
                _selectedLocation = defaultItem.name;
                _selectedCurrency = defaultItem.currency;
                log("123123");
                _getUSDTRate();
              }
            });
          }
        }
      }
    } catch (e) {
      log('获取国家/法币列表失败: $e');
    }
  }

  // 获取汇率
  Future<void> _getUSDTRate() async {
    try {
      final response = await ApiService.getUSDTRate({
        'currency': _selectedCurrency,
      });
      if (response.statusCode == 200) {
        final data = response.data;
        log('汇率数据: $data');
        if (data is Map<String, dynamic> && data['code'] == 0) {
          setState(() {
            _rate = (data['data']['rate'] as num?)?.toDouble() ?? 0.0;
          });
        }
      }
    } catch (e) {
      log('获取汇率失败: $e');
    }
  }
  

  // 计算价格（汇率 + 溢价）
  double get _computedPrice {
    final premium = double.tryParse(_premiumController.text) ?? 0.0;
    return _rate + premium;
  }

  // 计算支付金额（数量 * 价格）
  double get _computedPayAmount {
    final quantity = double.tryParse(_quantityController.text) ?? 0.0;
    return quantity * _computedPrice;
  }

  // 选择国家/法币
  void _selectCountry(CurrencyContryData item) {
    setState(() {
      _selectedLocation = item.name;
      _selectedCurrency = item.currency;
    });
    _getUSDTRate();
  }

  // 提交发布
  Future<void> _submit() async {
    // 验证用户是否实名认证
    if (_userInfo != null) {
      final authStatus = _userInfo!['authenticationStatus'];
      if (authStatus != 1) {
        // 假设 1 表示认证成功
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('请先完成实名认证')));
        return;
      }

      // 验证是否有默认支付方式
      if (_userInfo!['defaultPaymentId'] == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('请先设置默认支付方式')));
        return;
      }
    }

    // 验证表单
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // 验证支付方式至少选择一个
    final selectedPayments =
        _paymentTypes.entries
            .where((entry) => entry.value)
            .map((entry) => entry.key)
            .toList();

    if (selectedPayments.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('请至少选择一种支付方式')));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final params = {
        'digitalCurrency': 'USDT',
        'location': _selectedLocation,
        'currency': _selectedCurrency,
        'premium': double.tryParse(_premiumController.text) ?? 0.0,
        'price': _computedPrice.toStringAsFixed(2),
        'quantity': double.tryParse(_quantityController.text) ?? 0.0,
        'minimum': double.tryParse(_minAmountController.text) ?? LIMIT_MINIMUM,
        'maximum': double.tryParse(_maxAmountController.text) ?? 0.0,
        'paymentTypes': selectedPayments,
        'time': _paymentTime,
      };

      final response = await ApiService.postAd(params);
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic> && data['code'] == 0) {
          if (mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('发布成功')));
            Navigator.of(context).pop();
          }
        }
      }
    } catch (e) {
      log('发布失败: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('发布失败，请重试')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
              SizedBox(height: 16),
              // 地区和货币选择
              _buildLocationCurrencySection(),
              SizedBox(height: 16),
              // 溢价提示
              _buildPremiumHint(),
              SizedBox(height: 16),
              // 溢价输入
              _buildPremiumInput(),
              SizedBox(height: 16),
              // 价格显示（自动计算）
              _buildPriceDisplay(),
              SizedBox(height: 16),
              // 数量、最大金额、最小金额、支付方式、支付时间
              _buildMainFormSection(),
              SizedBox(height: 30),
              // 发布按钮
              _buildPublishButton(),
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
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '发布一则交易广告是免费的',
            style: TextStyle(fontSize: 14, color: Colors.blue.shade700),
          ),
          SizedBox(height: 4),
          Text(
            '请确保您的钱包中有足够的USDT',
            style: TextStyle(fontSize: 14, color: Colors.blue.shade700),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Text(
                '当前汇率: ',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
              ),
              Text(
                '$_rate $_selectedCurrency',
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

  // 构建地区/货币选择区域
  Widget _buildLocationCurrencySection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Column(
        children: [
          _buildSelectableField(
            label: '位置',
            value: _selectedLocation.isEmpty ? '请选择' : _selectedLocation,
            onTap: _showCountryCurrencyDialog,
          ),
          Divider(height: 24, thickness: 1, color: Colors.grey.shade200),
          _buildSelectableField(
            label: '法币',
            value: _selectedCurrency.isEmpty ? '请选择' : _selectedCurrency,
            onTap: _showCountryCurrencyDialog,
          ),
        ],
      ),
    );
  }

  // 构建溢价提示
  Widget _buildPremiumHint() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        '溢价提示：溢价范围 0-5%',
        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
      ),
    );
  }

  // 构建溢价输入
  Widget _buildPremiumInput() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: TextFormField(
        controller: _premiumController,
        decoration: InputDecoration(
          labelText: '溢价',
          hintText: '请输入溢价',
          border: InputBorder.none,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 2,
            ),
          ),
        ),
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        style: TextStyle(fontSize: 18),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '请输入溢价';
          }
          final premium = double.tryParse(value);
          if (premium == null) {
            return '请输入有效的数字';
          }
          if (premium < 0 || premium > 5) {
            return '溢价范围 0-5%';
          }
          return null;
        },
        onChanged: (value) {
          setState(() {}); // 触发价格重新计算
        },
      ),
    );
  }

  // 构建价格显示（自动计算，不可编辑）
  Widget _buildPriceDisplay() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: TextFormField(
        controller: TextEditingController(
          text: _computedPrice.toStringAsFixed(2),
        ),
        enabled: false,
        decoration: InputDecoration(
          labelText: '价格',
          border: InputBorder.none,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          disabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        style: TextStyle(fontSize: 18, color: Colors.black87),
      ),
    );
  }

  // 构建主表单区域
  Widget _buildMainFormSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Column(
        children: [
          // 数量输入
          TextFormField(
            controller: _quantityController,
            decoration: InputDecoration(
              labelText:
                  '数量 (您将获得 ${_computedPayAmount.toStringAsFixed(2)} $_selectedCurrency)',
              hintText:
                  '数量限制: $LIMIT_MINIMUM - ${_maxQuantity.toStringAsFixed(2)}',
              border: InputBorder.none,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 2,
                ),
              ),
              suffixText: 'U',
            ),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            style: TextStyle(fontSize: 18),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '请输入数量';
              }
              final quantity = double.tryParse(value);
              if (quantity == null) {
                return '请输入有效的数字';
              }
              if (quantity < LIMIT_MINIMUM || quantity > _maxQuantity) {
                return '数量范围: $LIMIT_MINIMUM - ${_maxQuantity.toStringAsFixed(2)}';
              }
              return null;
            },
            onChanged: (value) {
              setState(() {}); // 触发支付金额重新计算
            },
          ),
          Divider(height: 24, thickness: 1, color: Colors.grey.shade200),
          // 最大金额
          TextFormField(
            controller: _maxAmountController,
            decoration: InputDecoration(
              labelText: '最大交易金额',
              hintText: '请输入最大交易金额',
              border: InputBorder.none,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 2,
                ),
              ),
              suffixText: 'U',
              enabled: _quantityController.text.isNotEmpty,
            ),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            style: TextStyle(fontSize: 18),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '请输入最大交易金额';
              }
              final maxAmount = double.tryParse(value);
              if (maxAmount == null) {
                return '请输入有效的数字';
              }
              if (maxAmount < LIMIT_MINIMUM || maxAmount > LIMIT_MAXIMUM) {
                return '最大金额范围: $LIMIT_MINIMUM - $LIMIT_MAXIMUM';
              }
              return null;
            },
          ),
          Divider(height: 24, thickness: 1, color: Colors.grey.shade200),
          // 最小金额
          TextFormField(
            controller: _minAmountController,
            decoration: InputDecoration(
              labelText: '最小交易金额',
              hintText: '请输入最小交易金额',
              border: InputBorder.none,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 2,
                ),
              ),
              suffixText: 'U',
            ),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            style: TextStyle(fontSize: 18),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '请输入最小交易金额';
              }
              final minAmount = double.tryParse(value);
              if (minAmount == null) {
                return '请输入有效的数字';
              }
              if (minAmount < LIMIT_MINIMUM) {
                return '最小金额不能小于 $LIMIT_MINIMUM';
              }
              final maxAmount = double.tryParse(_maxAmountController.text);
              if (maxAmount != null && minAmount > maxAmount) {
                return '最小金额不能大于最大金额';
              }
              return null;
            },
          ),
          Divider(height: 24, thickness: 1, color: Colors.grey.shade200),
          // 支付方式
          _buildPaymentMethodsSection(),
          Divider(height: 24, thickness: 1, color: Colors.grey.shade200),
          // 支付时间
          _buildPaymentTimeSection(),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          SizedBox(height: 8),
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
                size: 16,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 构建支付方式选择区域
  Widget _buildPaymentMethodsSection() {
    final paymentNames = {1: '银行卡', 2: '微信', 3: '支付宝'};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '支付方式',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
        SizedBox(height: 12),
        ...paymentNames.entries.map((entry) {
          return CheckboxListTile(
            value: _paymentTypes[entry.key] ?? false,
            onChanged: (value) {
              setState(() {
                _paymentTypes[entry.key] = value ?? false;
              });
            },
            title: Text(entry.value, style: TextStyle(fontSize: 16)),
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
          );
        }),
      ],
    );
  }

  // 构建支付时间区域（固定15分钟）
  Widget _buildPaymentTimeSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '支付时间',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            SizedBox(height: 8),
            Text(
              _paymentTime,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Text(
          '分钟',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // 构建发布按钮
  Widget _buildPublishButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child:
            _isLoading
                ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                : Text(
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

  // 显示国家/法币选择对话框
  void _showCountryCurrencyDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('选择国家/法币'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children:
                  _countryCurrencyList.map((item) {
                    final isSelected = item.name == _selectedLocation;
                    return InkWell(
                      onTap: () {
                        _selectCountry(item);
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
                              '${item.name} (${item.currency})',
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

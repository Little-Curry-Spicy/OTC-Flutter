class SaleAdModel {
  final String nickName;
  final String price;
  final String currency;
  final double minimum;
  final double maximum;
  final double volume;
  final double remaining;
  final List<int> paymentTypes;
  SaleAdModel({
    required this.nickName,
    required this.price,
    required this.currency,
    required this.minimum,
    required this.maximum,
    required this.volume,
    required this.remaining,
    required this.paymentTypes,
  });

  /// 这是一个工厂构造函数，用于将接口返回的json数据转换为SaleAdModel的实例
  factory SaleAdModel.fromJson(Map<String, dynamic> json) {
    return SaleAdModel(
      nickName: json['nickName']?.toString() ?? '',
      price: json['price']?.toString() ?? '0',
      currency: json['currency']?.toString() ?? '',
      minimum: (json['minimum'] as num?)?.toDouble() ?? 0.0,
      maximum: (json['maximum'] as num?)?.toDouble() ?? 0.0,
      volume: (json['volume'] as num?)?.toDouble() ?? 0.0,
      remaining: (json['remaining'] as num?)?.toDouble() ?? 0.0,
      paymentTypes:
          json['paymentTypes'] != null
              ? List<int>.from(json['paymentTypes'] as List)
              : [],
    );
  }
}

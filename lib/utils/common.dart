/// 通用响应类
/// T 是 data 字段的类型，可以是任何类型（List、Map、具体对象等）
class CommonResponse<T> {
  int code;
  T data;
  String message;

  CommonResponse({
    required this.code,
    required this.data,
    required this.message,
  });

  /// 从 JSON 创建响应对象
  /// [fromJson] 是一个函数，用于将 JSON 数据转换为 T 类型
  /// 例如：如果 T 是 List<CurrencyContryData>，则 fromJson 应该将 List<Map> 转换为 List<CurrencyContryData>
  factory CommonResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJson,
  ) {
    return CommonResponse<T>(
      code: json['code'] as int? ?? 0,
      data: fromJson(json['data']),
      message: json['message']?.toString() ?? '',
    );
  }

  /// 将响应对象转换为 JSON
  Map<String, dynamic> toJson() {
    return {'code': code, 'data': data, 'message': message};
  }
}

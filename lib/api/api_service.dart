import 'package:dio/dio.dart';
import 'package:flutter_application/utils/http_client.dart';

/// API服务类
/// 参考 api.js 的结构，提供所有API接口
class ApiService {
  static final HttpClient _http = HttpClient();

  // ==================== 用户相关 ====================
  
  /// 注册
  static Future<Response> register(Map<String, dynamic> params) {
    return _http.post('api/member/register', data: params);
  }

  /// 登录
  static Future<Response> login(Map<String, dynamic> params) {
    return _http.post('api/member/login', data: params);
  }

  /// 忘记密码
  static Future<Response> forgetPassword(Map<String, dynamic> params) {
    return _http.post('api/member/forget/password', data: params);
  }

  /// 获取用户信息
  static Future<Response> getUserInfo([Map<String, dynamic>? params]) {
    return _http.post('api/member/info', data: params ?? {});
  }

  /// 修改用户信息
  static Future<Response> updateUserInfo(Map<String, dynamic> params) {
    return _http.post('api/member/update/info', data: params);
  }

  /// 修改登录密码
  static Future<Response> updateLoginPassword(Map<String, dynamic> params) {
    return _http.post('api/member/changeLoginPassword', data: params);
  }

  // ==================== 支付方式相关 ====================

  /// 支付方式列表
  static Future<Response> getPaymentList([Map<String, dynamic>? params]) {
    return _http.post('api/payment/list', data: params ?? {});
  }

  /// 添加支付方式
  static Future<Response> addPayment(Map<String, dynamic> params) {
    return _http.post('api/payment/add', data: params);
  }

  /// 删除支付方式
  static Future<Response> deletePayment(Map<String, dynamic> params) {
    return _http.post('api/payment/delete', data: params);
  }

  /// 支付方式详情
  static Future<Response> getPaymentInfo(Map<String, dynamic> params) {
    return _http.post('api/payment/info', data: params);
  }

  /// 编辑支付方式
  static Future<Response> editPayment(Map<String, dynamic> params) {
    return _http.post('api/payment/edit', data: params);
  }

  /// 设置默认支付方式
  static Future<Response> setDefaultPayment(Map<String, dynamic> params) {
    return _http.post('api/member/setting/payment', data: params);
  }

  /// 设置是否开启轮训
  static Future<Response> setEnableBankCardPolling(Map<String, dynamic> params) {
    return _http.post('api/payment/togglePayment', data: params);
  }

  // ==================== 站内信相关 ====================

  /// 站内信列表
  static Future<Response> getMessageList([Map<String, dynamic>? params]) {
    return _http.post('api/privateMessage/list', data: params ?? {});
  }

  /// 站内信已读
  static Future<Response> markMessageRead(Map<String, dynamic> params) {
    return _http.post('api/privateMessage/read', data: params);
  }

  // ==================== 汇率相关 ====================

  /// 获取货币汇率
  static Future<Response> getUSDTRate([Map<String, dynamic>? params]) {
    return _http.post('api/help/rate', data: params ?? {});
  }

  /// 获取所有汇率
  static Future<Response> getRate([Map<String, dynamic>? params]) {
    return _http.post('api/help/rate/all', data: params ?? {});
  }

  /// 获取国家与法币列表
  static Future<Response> getCountryCurrencyList([Map<String, dynamic>? params]) {
    return _http.post('api/help/country/list', data: params ?? {});
  }

  /// 获取国家列表
  static Future<Response> getCountryList([Map<String, dynamic>? params]) {
    return _http.post('api/help/country/list', data: params ?? {});
  }

  // ==================== 广告相关 ====================

  /// 广告列表
  static Future<Response> getSaleAdList([Map<String, dynamic>? params]) {
    return _http.post('api/saleAd/list', data: params ?? {});
  }

  /// 下单广告
  static Future<Response> orderSaleAd(Map<String, dynamic> params) {
    return _http.post('api/saleAd/order', data: params);
  }

  /// 取消订单
  static Future<Response> cancelOrder(Map<String, dynamic> params) {
    return _http.post('api/saleAd/order/cancel', data: params);
  }

  /// 订单详情
  static Future<Response> getOrderDetail(Map<String, dynamic> params) {
    return _http.post('api/saleAd/order/details', data: params);
  }

  /// 历史记录
  static Future<Response> getSaleAdHistoryList([Map<String, dynamic>? params]) {
    return _http.post('api/saleAd/list/my', data: params ?? {});
  }

  /// 订单管理
  static Future<Response> getOrderList([Map<String, dynamic>? params]) {
    return _http.post('api/saleAd/order/my', data: params ?? {});
  }

  /// 标记订单已付款
  static Future<Response> markOrderPayed(Map<String, dynamic> params) {
    return _http.post('api/saleAd/order/payed', data: params);
  }

  /// 释放订单
  static Future<Response> releaseOrder(Map<String, dynamic> params) {
    return _http.post('api/saleAd/order/release', data: params);
  }

  /// 获取广告详情
  static Future<Response> getAdDetails(Map<String, dynamic> params) {
    return _http.post('api/saleAd/details', data: params);
  }

  /// 我的广告列表
  static Future<Response> getMyAdList([Map<String, dynamic>? params]) {
    return _http.post('api/saleAd/list/my', data: params ?? {});
  }

  /// 下架广告
  static Future<Response> offAd(Map<String, dynamic> params) {
    return _http.post('api/saleAd/off', data: params);
  }

  /// 发布广告
  static Future<Response> postAd(Map<String, dynamic> params) {
    return _http.post('api/saleAd/post', data: params);
  }

  // ==================== 验证相关 ====================

  /// 验证邮箱
  static Future<Response> verifyEmail(Map<String, dynamic> params) {
    return _http.post('api/verify/email', data: params);
  }

  /// 验证UID
  static Future<Response> verifyMemberId(Map<String, dynamic> params) {
    return _http.post('api/get/memberInfo/id', data: params);
  }

  /// 获取用户信息（通过邮箱）
  static Future<Response> getMemberInfoByEmail(Map<String, dynamic> params) {
    return _http.post('api/get/memberInfo', data: params);
  }

  /// 验证资金密码
  static Future<Response> verifyWalletPassword(Map<String, dynamic> params) {
    return _http.post('api/verify/wallet/password', data: params);
  }

  /// 验证登录密码
  static Future<Response> verifyLoginPassword(Map<String, dynamic> params) {
    return _http.post('api/verify/login/password', data: params);
  }

  /// 发送验证码
  static Future<Response> sendCaptcha(Map<String, dynamic> params) {
    return _http.post('api/help/send/verification/code', data: params);
  }

  // ==================== 资产相关 ====================

  /// 资产列表
  static Future<Response> getMemberAssetsList([Map<String, dynamic>? params]) {
    return _http.post('api/member/assets/list', data: params ?? {});
  }

  /// 资产转账
  static Future<Response> transferAssets(Map<String, dynamic> params) {
    return _http.post('api/member/assets/transfer', data: params);
  }

  /// 资产概览
  static Future<Response> getAssetsOverview([Map<String, dynamic>? params]) {
    return _http.post('api/member/assets/view', data: params ?? {});
  }

  /// 充值
  static Future<Response> rechargeAssets(Map<String, dynamic> params) {
    return _http.post('api/member/assets/deposite', data: params);
  }

  /// 提币
  static Future<Response> withdrawAssets(Map<String, dynamic> params) {
    return _http.post('api/member/assets/withdrawal', data: params);
  }

  /// 我的资产
  static Future<Response> getAssetsDetail([Map<String, dynamic>? params]) {
    return _http.post('api/member/assets/index', data: params ?? {});
  }

  /// 获取会员资产
  static Future<Response> getInfoAssets([Map<String, dynamic>? params]) {
    return _http.post('api/member/info/asset', data: params ?? {});
  }

  /// 账户互转
  static Future<Response> transferAccount(Map<String, dynamic> params) {
    return _http.post('api/member/assets/moveFunds', data: params);
  }

  // ==================== 钱包地址相关 ====================

  /// 钱包地址列表
  static Future<Response> getWalletList([Map<String, dynamic>? params]) {
    return _http.post('api/member/wallet/list', data: params ?? {});
  }

  /// 添加钱包地址
  static Future<Response> addWallet(Map<String, dynamic> params) {
    return _http.post('api/member/wallet/add', data: params);
  }

  /// 编辑钱包地址
  static Future<Response> editWallet(Map<String, dynamic> params) {
    return _http.post('api/member/wallet/edit', data: params);
  }

  /// 删除钱包地址
  static Future<Response> deleteWallet(Map<String, dynamic> params) {
    return _http.post('api/member/wallet/delete', data: params);
  }

  // ==================== 实名认证相关 ====================

  /// 提交实名认证信息
  static Future<Response> submitIdentityInfo(Map<String, dynamic> params) {
    return _http.post('api/member/submit/identity/info', data: params);
  }

  /// 上传实名认证图片
  static Future<Response> uploadIdentityImage(Map<String, dynamic> params) {
    return _http.post('api/member/submit/identity/image', data: params);
  }

  // ==================== 设置相关 ====================

  /// 设置区域
  static Future<Response> setCountry(Map<String, dynamic> params) {
    return _http.post('api/member/setting/country', data: params);
  }

  /// 切换语言
  static Future<Response> changeLanguage(Map<String, dynamic> params) {
    return _http.post('api/member/change/language', data: params);
  }

  /// 修改资金密码
  static Future<Response> updateWalletPassword(Map<String, dynamic> params) {
    return _http.post('api/member/setting/walletPassword', data: params);
  }

  /// 获取是否开启轮训
  static Future<Response> getTogglePolling([Map<String, dynamic>? params]) {
    return _http.post('api/member/togglePolling', data: params ?? {});
  }

  // ==================== 邀请相关 ====================

  /// 我的邀请
  static Future<Response> getInviteList([Map<String, dynamic>? params]) {
    return _http.post('api/member/invite/view', data: params ?? {});
  }

  /// 获取团队成员
  static Future<Response> getTeamMembers([Map<String, dynamic>? params]) {
    return _http.post('api/member/invite/getTeamMembers', data: params ?? {});
  }

  /// 设置返佣比例
  static Future<Response> setRakeBackRate(Map<String, dynamic> params) {
    return _http.post('api/member/setRakeBackRate', data: params);
  }

  // ==================== 佣金相关 ====================

  /// 佣金流水列表
  static Future<Response> getCommissionList([Map<String, dynamic>? params]) {
    return _http.post('api/member/getCommissionFlowList', data: params ?? {});
  }

  /// 佣金流水统计
  static Future<Response> getCommissionStats([Map<String, dynamic>? params]) {
    return _http.post('api/member/getCommissionFlowStats', data: params ?? {});
  }

  /// 获取佣金流水统计
  static Future<Response> getCommissionFlowStats([Map<String, dynamic>? params]) {
    return _http.post('api/commission/commissionFlowStats', data: params ?? {});
  }

  /// 获取团队成员统计
  static Future<Response> getTeamStats([Map<String, dynamic>? params]) {
    return _http.post('api/commission/myTeamStats', data: params ?? {});
  }

  /// 获取我的统计
  static Future<Response> getMyStats([Map<String, dynamic>? params]) {
    return _http.post('api/commission/myStats', data: params ?? {});
  }

  // ==================== 首页相关 ====================

  /// 首页数据
  static Future<Response> getIndexInfo([Map<String, dynamic>? params]) {
    return _http.post('api/member/getIndexInfo', data: params ?? {});
  }

  // ==================== 文件上传 ====================

  /// 上传图片
  static Future<Response> uploadImage(String filePath) {
    return _http.uploadFile(
      'api/help/upload/image',
      filePath,
      name: 'file',
    );
  }
}


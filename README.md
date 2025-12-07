# OTC Flutter 应用

这是一个基于 Flutter 的 OTC（场外交易）应用，支持 Android、iOS、Web、Windows、Linux 和 macOS 平台。

## 项目简介

这是一个 OTC 交易平台应用，提供用户交易、订单管理、资产查看等功能。

## 今日完成工作（最新更新）

### 1. 修复登录页面问题
- ✅ 修复了 `TextFormField` 中 `initialValue` 和 `controller` 不能同时使用的问题
- ✅ 将默认值设置改为在 `initState` 中通过 `controller.text` 设置
- ✅ 添加了 `dispose` 方法释放资源

### 2. 修复 macOS 网络权限问题
- ✅ 在 `DebugProfile.entitlements` 和 `Release.entitlements` 中添加了 `com.apple.security.network.client` 权限
- ✅ 优化了 `Info.plist` 中的 App Transport Security (ATS) 配置
- ✅ 解决了 "Operation not permitted" 网络连接错误

### 3. 修复数据解析问题
- ✅ 修复了首页佣金列表数据解析问题（从 `response.data['data']` 正确提取列表）
- ✅ 修复了交易统计数据的类型转换问题（`Map<String, dynamic>` 转 `Map<String, double>`）
- ✅ 修复了交易列表数据解析问题（正确处理 `List<Map>` 转 `List<SaleAdModel>`）

### 4. 创建交易卡片组件
- ✅ 创建了独立的 `TransactionCard` 组件（`lib/tabbars/transaction/components/transaction_card.dart`）
- ✅ 优化了 UI 设计：
  - 添加了商户头像图标
  - 优化了支付方式标签样式（添加图标和边框）
  - 重新设计了价格和限额展示（卡片式布局）
  - 优化了底部信息展示（添加图标）
- ✅ 将银行卡支付方式颜色改为红色

### 5. 创建发布广告页面
- ✅ 实现了完整的发布广告表单（`lib/tabbars/transaction/publish.dart`）
- ✅ 实现了所有字段：
  - 位置/国家选择
  - 法币选择
  - 溢价输入（0-5%）
  - 价格显示（自动计算：汇率 + 溢价）
  - 数量输入（显示将获得的金额）
  - 最大/最小交易金额
  - 支付方式多选
  - 支付时间（固定 15 分钟）
- ✅ 集成了相关 API：
  - 获取国家/法币列表
  - 获取汇率
  - 获取用户资产
  - 获取用户信息
  - 提交发布广告
- ✅ 实现了表单验证和提交逻辑

### 6. 创建通用响应类
- ✅ 创建了 `CommonResponse<T>` 通用响应类（`lib/utils/common.dart`）
- ✅ 支持泛型，`data` 字段类型可变，`code` 和 `message` 固定
- ✅ 添加了 `fromJson` 工厂方法，支持自定义数据转换
- ✅ 添加了 `toJson` 方法，便于序列化

### 7. 创建数据模型
- ✅ 创建了 `CurrencyContryData` 数据模型（国家/法币数据）
- ✅ 创建了 `SaleAdModel` 数据模型（交易广告数据）
- ✅ 所有模型都包含 `fromJson` 和 `toJson` 方法

### 8. 代码优化
- ✅ 优化了错误处理和日志记录
- ✅ 改进了代码结构和可读性
- ✅ 添加了必要的注释

## 环境要求

在运行项目之前，请确保已安装以下环境：

1. **Flutter SDK** (版本 >= 3.7.2)
   - 下载地址：https://docs.flutter.dev/get-started/install
   - 安装完成后，运行 `flutter doctor` 检查环境配置

2. **开发工具**（至少选择一种）：
   - Android Studio / IntelliJ IDEA（推荐）
   - VS Code
   - Xcode（仅macOS，用于iOS开发）

3. **平台特定要求**：
   - **Android开发**：需要Android SDK和Android Studio
   - **iOS开发**（仅macOS）：需要Xcode和CocoaPods
   - **Web开发**：需要Chrome浏览器
   - **桌面开发**：需要相应的平台SDK

## 快速开始

### 1. 检查Flutter环境

```bash
flutter doctor
```

确保所有必要的组件都已正确配置。

### 2. 安装项目依赖

```bash
flutter pub get
```

### 3. 运行项目

```bash
# 查看可用的设备
flutter devices

# 运行到指定设备
flutter run -d <device-id>

# macOS
flutter run -d macos

# iOS
flutter run -d ios

# Android
flutter run -d android
```

## 项目结构

```
lib/
├── api/                    # API 服务
│   └── api_service.dart
├── components/             # 公共组件
│   ├── selectCurrency/     # 法币选择组件
│   └── selectPayment/      # 支付方式选择组件
├── tabbars/                # 主要页面
│   ├── bootstrap/          # 启动/登录页面
│   ├── home/               # 首页
│   ├── transaction/        # 交易页面
│   │   ├── components/     # 交易相关组件
│   │   │   ├── transaction_card.dart
│   │   │   └── transaction_action_button.dart
│   │   ├── publish.dart    # 发布广告页面
│   │   ├── transaction.dart
│   │   └── saleAdModel.dart
│   ├── order/              # 订单页面
│   └── settings/           # 设置页面
├── utils/                  # 工具类
│   ├── common.dart         # 通用响应类
│   ├── constant.dart       # 常量定义
│   ├── http_client.dart    # HTTP 客户端
│   └── http_interceptor.dart # HTTP 拦截器
└── main.dart               # 应用入口
```

## 主要功能

1. **用户认证**：登录、注册、忘记密码
2. **交易市场**：查看交易广告、筛选、发布广告
3. **订单管理**：查看订单、订单详情
4. **资产管理**：查看资产、充值、提币
5. **个人中心**：用户信息、设置

## 技术栈

- **Flutter**：跨平台 UI 框架
- **Dio**：HTTP 客户端
- **SharedPreferences**：本地存储
- **Material Design**：UI 设计规范

## 常见问题

### macOS 网络连接被拒绝

如果出现 "Operation not permitted" 错误，请确保：
1. 已在 `macos/Runner/DebugProfile.entitlements` 和 `macos/Runner/Release.entitlements` 中添加了 `com.apple.security.network.client` 权限
2. 已重新构建应用：`flutter clean && flutter run`

### 数据解析错误

如果遇到类型转换错误，请确保：
1. 使用 `CommonResponse<T>` 正确解析 API 响应
2. 数据模型类实现了 `fromJson` 方法
3. 正确处理空值和类型检查

## 开发说明

### 代码规范

- 使用 `CommonResponse<T>` 处理所有 API 响应
- 数据模型类必须实现 `fromJson` 和 `toJson` 方法
- 组件应该独立且可复用
- 添加必要的注释和错误处理

### 提交代码

```bash
# 添加所有更改
git add .

# 提交更改
git commit -m "描述你的更改"

# 推送到远程仓库
git push
```

## 更新日志

### 2024-12-XX（今日）
- 完成交易卡片组件和发布广告页面
- 创建通用响应类和数据模型
- 修复多个数据解析和类型转换问题
- 修复 macOS 网络权限问题

---

**注意**：首次运行项目时，Flutter可能需要下载一些平台特定的依赖，这可能需要一些时间。请耐心等待。


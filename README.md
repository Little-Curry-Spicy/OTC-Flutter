# Flutter Application

这是一个Flutter跨平台应用项目，支持Android、iOS、Web、Windows、Linux和macOS平台。

## 项目简介

这是一个基础的Flutter应用示例，包含一个简单的计数器功能。应用使用Material Design设计风格，展示了Flutter的基本开发模式。

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

首先检查Flutter是否正确安装：

```bash
flutter doctor
```

确保所有必要的组件都已正确配置。

### 2. 安装项目依赖

在项目根目录下运行：

```bash
flutter pub get
```

这将下载并安装 `pubspec.yaml` 中定义的所有依赖包。

### 3. 运行项目

根据目标平台选择相应的运行命令：

#### 在Android设备/模拟器上运行

```bash
# 查看可用的设备
flutter devices

# 运行到Android设备
flutter run

# 或者指定设备ID运行
flutter run -d <device-id>
```

#### 在iOS设备/模拟器上运行（仅macOS）

```bash
# 查看可用的iOS设备
flutter devices

# 运行到iOS设备
flutter run

# 或者指定设备ID运行
flutter run -d <device-id>
```

#### 在Web浏览器中运行

```bash
# 运行到Chrome浏览器
flutter run -d chrome

# 运行到Edge浏览器
flutter run -d edge
```

#### 在桌面平台运行

```bash
# macOS
flutter run -d macos

# Windows
flutter run -d windows

# Linux
flutter run -d linux
```

### 4. 热重载（Hot Reload）

应用运行后，你可以使用以下方式快速查看代码更改：

- **在IDE中**：点击热重载按钮（⚡图标）或按快捷键
- **在命令行中**：按 `r` 键进行热重载
- **完全重启**：按 `R` 键进行热重启（会重置应用状态）

## 项目结构

```
flutter_application/
├── lib/
│   └── main.dart          # 应用主入口文件
├── android/               # Android平台相关配置
├── ios/                   # iOS平台相关配置
├── web/                   # Web平台相关配置
├── windows/               # Windows平台相关配置
├── linux/                 # Linux平台相关配置
├── macos/                 # macOS平台相关配置
├── test/                  # 测试文件
├── pubspec.yaml           # 项目依赖配置文件
└── README.md             # 项目说明文档
```

## 主要功能

当前应用包含以下功能：

1. **计数器功能**：点击浮动按钮可以增加计数
2. **Material Design UI**：使用Flutter的Material组件库
3. **响应式布局**：适配不同屏幕尺寸

## 开发说明

### 代码结构

- `main.dart`：应用入口，包含 `MyApp` 和 `MyHomePage` 两个主要组件
- `MyApp`：应用的根组件，配置主题和路由
- `MyHomePage`：主页面，包含计数器逻辑和UI

### 修改代码

1. 打开 `lib/main.dart` 文件
2. 修改代码后保存
3. 使用热重载功能查看更改效果

### 添加依赖

在 `pubspec.yaml` 文件的 `dependencies` 部分添加所需包，然后运行：

```bash
flutter pub get
```

## 构建发布版本

### Android APK

```bash
flutter build apk
```

### Android App Bundle（用于Google Play）

```bash
flutter build appbundle
```

### iOS（仅macOS）

```bash
flutter build ios
```

### Web

```bash
flutter build web
```

### 桌面应用

```bash
# macOS
flutter build macos

# Windows
flutter build windows

# Linux
flutter build linux
```

## 常见问题

### 1. Flutter命令未找到

确保Flutter已添加到系统PATH环境变量中。在macOS/Linux上，可以编辑 `~/.zshrc` 或 `~/.bash_profile`：

```bash
export PATH="$PATH:/path/to/flutter/bin"
```

### 2. 设备未连接

- Android：确保已启用USB调试，或启动Android模拟器
- iOS：确保设备已信任，或启动iOS模拟器

### 3. 依赖安装失败

尝试清理并重新安装：

```bash
flutter clean
flutter pub get
```

### 4. 构建失败

运行 `flutter doctor` 检查环境配置，确保所有必要的工具都已正确安装。

## 学习资源

- [Flutter官方文档](https://docs.flutter.dev/)
- [Flutter中文网](https://flutter.cn/)
- [Dart语言教程](https://dart.dev/guides)

## 项目改进计划

- [ ] 添加更多功能模块
- [ ] 优化UI设计
- [ ] 添加状态管理（如Provider、Riverpod等）
- [ ] 添加网络请求功能
- [ ] 添加本地存储功能
- [ ] 完善错误处理和日志记录

---

**注意**：首次运行项目时，Flutter可能需要下载一些平台特定的依赖，这可能需要一些时间。请耐心等待。

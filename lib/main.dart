import 'package:flutter/material.dart';
import 'package:flutter_application/tabbars/order/order.dart';
import 'package:flutter_application/tabbars/transaction/transaction.dart';
import 'package:flutter_application/tabbars/transaction/publish.dart';
import 'package:flutter_application/tabbars/bootstrap/login/login.dart';
import 'package:flutter_application/tabbars/home/home.dart';
import 'package:flutter_application/tabbars/settings/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 全局导航键，用于在拦截器中显示错误提示
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey, // 设置全局导航键
      debugShowCheckedModeBanner: false,
      title: 'OTC',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFF0B90B)),
        primaryColor: Color(0xFFF0B90B),
      ),
      routes: {
        '/login': (context) => Login(),
        '/tabbar': (context) => TabBarExample(), // 主页面，包含底部导航
        '/home': (context) => Home(),
        '/transaction': (context) => Transaction(),
        '/publish': (context) => PublishPage(), // 发布页面
        '/settings': (context) => Settings(),
        '/order': (context) => Order(),
      },
      home: FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          // 判断异步获取SharedPreferences是否完成
          if (snapshot.connectionState == ConnectionState.done) {
            final prefs = snapshot.data;
            if (prefs != null && prefs.getString('token') != null) {
              return TabBarExample();
            } else {
              return Login();
            }
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class TabBarExample extends StatefulWidget {
  const TabBarExample({super.key});

  @override
  State<TabBarExample> createState() => _TabBarExampleState();
}

class _TabBarExampleState extends State<TabBarExample> {
  // 当前选中的底部导航栏索引
  int _currentIndex = 0;

  // 页面列表
  final List<Widget> _pages = [
    const Home(),
    const Transaction(),
    const Order(),
    const Settings(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 使用IndexedStack来管理页面切换，保持页面状态
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          // 切换底部导航栏时，更新当前索引
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed, // 固定显示所有标签
        backgroundColor: Colors.white, // 白色背景
        selectedItemColor: Theme.of(context).primaryColor, // 选中项颜色（金色）
        unselectedItemColor: Colors.grey.shade600, // 未选中项颜色（灰色）
        selectedFontSize: 12, // 选中项字体大小
        unselectedFontSize: 12, // 未选中项字体大小
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w600, // 选中项字体加粗
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w500, // 未选中项字体正常
        ),
        elevation: 8, // 增加阴影效果，让导航栏更突出
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            activeIcon: Icon(Icons.account_balance_wallet),
            label: 'Transaction',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            activeIcon: Icon(Icons.shopping_bag),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

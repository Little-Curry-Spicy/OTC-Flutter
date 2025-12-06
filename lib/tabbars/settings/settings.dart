import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  // 模拟用户数据
  final String _uid = '000007';
  final String _username = 'OTC-1111';
  final String _email = '2939117014@qq.com';

  // 复制UID到剪贴板
  void _copyUID() {
    Clipboard.setData(ClipboardData(text: _uid));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('UID已复制到剪贴板'),
        duration: Duration(seconds: 2),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
    log('UID已复制: $_uid');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text('个人资料'),
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        shape: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings_outlined),
            onPressed: () {
              log('点击设置按钮');
              // TODO: 跳转到设置页面
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 顶部个人信息区域（深色背景）
            _buildProfileSection(),
            SizedBox(height: 12),
            // 中间导航卡片（横向）
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: _buildMiddleNavCard(),
            ),
            SizedBox(height: 12),
            // 底部导航卡片（纵向）
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: _buildBottomNavCard(),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // 构建个人信息区域
  Widget _buildProfileSection() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFFFF3C4), // 更明显的暖黄色背景
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // 头像
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).primaryColor,
                width: 2.5,
              ),
            ),
            child: Icon(
              Icons.person,
              size: 44,
              color: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(width: 16),
          // 用户信息
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // UID行（可复制）
                Row(
                  children: [
                    Text(
                      'UID: $_uid',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 8),
                    InkWell(
                      onTap: _copyUID,
                      child: Icon(
                        Icons.copy,
                        size: 18,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                // 用户名
                Text(
                  '用户名: $_username',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                ),
                SizedBox(height: 6),
                // 邮箱
                Text(
                  '邮箱: $_email',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 构建中间导航卡片（横向）
  Widget _buildMiddleNavCard() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildMiddleNavItem(
            icon: Icons.campaign,
            label: '我的广告',
            onTap: () {
              log('点击我的广告');
              // TODO: 跳转到我的广告页面
            },
          ),
          _buildMiddleNavItem(
            icon: Icons.security,
            label: '安全中心',
            iconColor: Color(0xFF07C160), // 绿色
            onTap: () {
              log('点击安全中心');
              // TODO: 跳转到安全中心页面
            },
          ),
          _buildMiddleNavItem(
            icon: Icons.account_balance_wallet,
            label: '我的资产',
            onTap: () {
              log('点击我的资产');
              // TODO: 跳转到我的资产页面
            },
          ),
        ],
      ),
    );
  }

  // 构建中间导航项
  Widget _buildMiddleNavItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    final color = iconColor ?? Theme.of(context).primaryColor;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 28, color: color),
            SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 构建底部导航卡片（纵向）
  Widget _buildBottomNavCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildBottomNavItem(
            icon: Icons.location_on,
            label: '提币地址',
            onTap: () {
              log('点击提币地址');
              // TODO: 跳转到提币地址页面
            },
          ),
          Divider(height: 1, color: Colors.grey.shade200),
          _buildBottomNavItem(
            icon: Icons.share,
            label: '我的邀请',
            onTap: () {
              log('点击我的邀请');
              // TODO: 跳转到我的邀请页面
            },
          ),
          Divider(height: 1, color: Colors.grey.shade200),
          _buildBottomNavItem(
            icon: Icons.link,
            label: '邀请链接',
            onTap: () {
              log('点击邀请链接');
              // TODO: 跳转到邀请链接页面
            },
          ),
        ],
      ),
    );
  }

  // 构建底部导航项
  Widget _buildBottomNavItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 22, color: Theme.of(context).primaryColor),
            SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(Icons.chevron_right, size: 18, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}

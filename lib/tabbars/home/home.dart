import 'package:flutter/material.dart';
import 'package:flutter_application/tabbars/home/components/home/content.dart';
import 'package:flutter_application/tabbars/home/components/home/header.dart';
import 'package:flutter_application/tabbars/home/components/home/main.dart';
import 'package:flutter_application/tabbars/home/components/home/tabbar.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Color(0xFFfef7f2),
        scrolledUnderElevation: 0,
        shape: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      // 使用SingleChildScrollView包裹，让内容可以滚动，防止溢出
      body: SingleChildScrollView(
        child: Column(
          children: [
            HomeHeader(),
            SizedBox(height: 16),
            HomeMain(),
            SizedBox(height: 16),
            HomeTabbar(),
            SizedBox(height: 16),
            HomeContent(),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

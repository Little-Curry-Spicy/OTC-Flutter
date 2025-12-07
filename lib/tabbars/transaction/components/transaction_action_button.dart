import 'package:flutter/material.dart';

// 构建悬浮按钮
Widget buildFloatingActionButton(BuildContext context) {
  return FloatingActionButton.extended(
    backgroundColor: Theme.of(context).primaryColor,
    onPressed: () {
      Navigator.pushNamed(context, '/publish');
    },
    label: Text("一键发布"),
  );
}

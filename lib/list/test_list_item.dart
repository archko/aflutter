import 'package:flutter/material.dart';

class TestListItem extends StatelessWidget {
  TestListItem({this.bean, this.onPressed}) : super();
  final String bean;
  final VoidCallback onPressed;

  void detail(String bean) {}

  @override
  Widget build(BuildContext context) {
    return Card(child: Center(child: Text(bean)));
  }
}

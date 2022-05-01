import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {
  TestScreen({Key? key}) : super(key: key);

  @override
  _TestScreen createState() => _TestScreen();
}

class _TestScreen extends State<TestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.green,
      ),
    );
  }
}

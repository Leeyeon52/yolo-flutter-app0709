// presentation/screens/mypage_screen.dart
import 'package:flutter/material.dart';
class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('마이페이지')),
      body: const Center(child: Text('마이페이지 내용')),
    );
  }
}